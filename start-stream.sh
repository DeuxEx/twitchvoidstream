#script to start twitchstream on capturedevice
#run this cmd to bypass authentication every time
#gsr info: gsr_kms_client_init: gsr-kms-server is missing sys_admin cap and will require root authentication.

#To bypass this automatically, run:
#sudo setcap cap_sys_admin+ep '/usr/bin/gsr-kms-server'


# Force the loop to react if GSR or FFmpeg crashes
set -o pipefail


echo "Reading streamkey..."
# Read the file content and export it as a global variable
export keyvalue=$(cat stream.key)



echo "Starting twitchstream..."

capturedevice="HDMI-A-1"
platform="rtmp://live.twitch.tv/app"
format="flv"
resolution="1920x1080"

#aac or opus
#default opus for mp4/mkv (128 bitrate)
#otherwise aac (160 bitrate)
audiocodec="opus"
audiobitrate="128"

videocodec="h264"

#quality: medium, high, very_high, ultra for vbr or bitrate for cbr.
quality="8000"


frameratemode="vfr"
colorrange="limited"
framerate="60"

#add text to stream?
#ffmpeg -i input.mp4 -vf "drawtext=fontfile=/path/to/font.ttf:textfile=text.txt:reload=1:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy output.mp4

startposx="200"
startposy="200"
#default; boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2
textfield="drawtext=fontfile=/usr/share/fonts/TTF/ZillaSlab-Regular.ttf:textfile=streamtext.txt:reload=10:fontcolor=white:fontsize=36:box=1:boxcolor=black@0.5:boxborderw=5:x=$startposx:y=$startposy"




# -f format
# -i input file url
# -i - = standard input

#output to file
#$ gpu-screen-recorder -w portal -o [path/to/video.mp4]


#gpu-screen-recorder -w $capturedevice -c $videocodec -s $resolution -bm cbr -q $quality -encoder gpu -ab $audiobitrate  -f $framerate -a default_output |
# ffmpeg -i - -f mpegts -c:a copy -f flv $platform/$streamkey


#dump to file
#gpu-screen-recorder -ab $audiobitrate -w $capturedevice -c $format -s $resolution -bm cbr -q $quality -ac $audiocodec -cursor no -cr $colorrange -k $videocodec -encoder gpu -f $framerate -a default_output -restore-portal-session yes -o /home/void/testrun.mp4


#stream to twitch

# change to true (without $) for a eternal loop
while true
do
    echo "[$(date +%T)] Starting the stream..."


gpu-screen-recorder \
-w $capturedevice \
-c flv \
-s $resolution \
-bm qp \
-q ultra \
-ac aac \
-cursor no \
-cr $colorrange \
-k h264 \
-encoder gpu \
-f $framerate \
-a default_output \
-restore-portal-session yes \
| ffmpeg \
-re \
-thread_queue_size 4096 \
-correct_ts_overflow 1 \
-i - \
-loop 1 \
-i "/home/void/deux-start-logo.jpeg" \
-filter_complex "[0:v]$textfield[game];[1:v]scale=$resolution[scaled_img];[game][scaled_img]overlay=enable='lt(t,15)'[outv]" \
-map "[outv]" \
-map 0:a \
-c:v h264_nvenc \
-profile:v high \
-preset:v p2 \
-tune:v ll \
-b:v 6000k \
-maxrate:v 6000k \
-bufsize 12000k \
-g $framerate \
-fps_mode cfr \
-af aresample=async=1 \
-c:a aac \
-b:a 160k \
-threads 0 \
-flags:v +global_header \
-f fifo \
-fifo_format flv \
-drop_pkts_on_overflow 1 \
-attempt_recovery 1 \
-recovery_wait_time 1 \
$platform/$keyvalue





    # Check if you stopped with purpose (Ctrl+C)
    exit_status=$?
    if [ $exit_status -eq 130 ]; then
        echo "[$(date +%T)] The stream was interrupted by the user. Stopping the loop."
        break
    fi

    echo "[$(date +%T)] The stream crashed or was dispatched. (Errorcode: $exit_status)."
    echo "Waiting 5 secs before the stream tries to auto-respawn..."
    sleep 5
done




killall ffmpeg
killall gpu-screen-recorder

# -re = read input frame rate
#-c:v libx264, h264_nvenc

#-c:v h264_nvenc
#-c:a aac

#send testsignal
#ffmpeg -re -f lavfi -i testsrc2=size=$resolution -f lavfi -i aevalsrc="sin(0*2*PI*t)" -vcodec libx264 -r 30 -g 30 -preset fast -vb 3000k -pix_fmt rgb24 -pix_fmt yuv420p -f flv $platform/$keyvalue



