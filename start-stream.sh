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

#plain text
textfield="drawtext=fontfile=/usr/share/fonts/TTF/ZillaSlab-Regular.ttf:textfile=streamtext.txt:reload=10:fontcolor=white:fontsize=36:box=1:boxcolor=black@0.5:boxborderw=5:x=$startposx:y=$startposy"


#text with rainbow effects

#pulserande bokstäver
#glitch_textfield="drawtext=fontfile=/usr/share/fonts/TTF/ZillaSlab-Regular.ttf:textfile=streamtext.txt:reload=10:box=1:boxcolor=black@0.5:boxborderw=5:fontcolor=white:fontsize='38+4*sin(2*t)':x=200:y=200"


glitch_textfield="drawtext=fontfile=/usr/share/fonts/TTF/ZillaSlab-Regular.ttf:textfile=streamtext.txt:reload=10:box=1:boxcolor=black@0.5:boxborderw=5:fontcolor=white:fontsize='36+if(gt(random(1)\,0.92)\,random(2)*16\,0)':x='200+if(gt(random(3)\,0.92)\,(random(4)-0.5)*12\,0)':y='200+if(gt(random(5)\,0.92)\,(random(6)-0.5)*12\,0)'"

# Stresstest-filter: Lägger på dynamiskt brus + tung gaussisk blur som aktiveras/testas
stress_filter="noise=alls=15:allf=t+u,$textfield"
blur_box="delogo=x=50:y=800:w=400:h=200:show=0"


#filter för att visa bildrutan)
#(-filter_complex "[0:v]$glitch_textfield[game];[1:v]scale=$resolution[scaled_img];[game][scaled_img]overlay=enable='lt(t,15)'[outv]") \
#(blurred box)
#(-filter_complex "[0:v]$blur_box[blurred_game];[blurred_game]$textfield[game];[1:v]scale=$resolution[scaled_img];[game][scaled_imgoverlay=enable='lt(t,15)'[outv]") \



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



logo_path="/home/void/gpu-scripts/deux-logo1-PERFEKT-test.png"
start_logo="/home/void/gpu-scripts/deux-start-logo.jpeg"

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
  -fflags +genpts+igndts \
  -thread_queue_size 4096 \
  -i - \
  -filter_complex "\
movie='$start_logo',loop=loop=-1:size=1,scale=$resolution,setsar=1[start_img];\
movie='$logo_path',loop=loop=-1:size=1,format=rgba,scale=200:-1[logo_img];\
[0:v]$textfield,setsar=1[game];\
[game][logo_img]overlay=x=main_w-overlay_w-30:y=30:format=auto[game_with_logo];\
[game_with_logo][start_img]overlay=enable='lt(t,15)':format=auto[outv]" \
  -map "[outv]" \
  -map 0:a \
  -c:v h264_nvenc \
  -profile:v high \
  -preset:v p1 \
  -tune:v ll \
  -b:v 6000k \
  -maxrate:v 6000k \
  -bufsize 12000k \
  -g $framerate \
  -c:a copy \
  -flvflags no_duration_filesize \
  -f flv \
  "$platform/$keyvalue"



    # Check if you shut down the stream on purpose (Ctrl+C)
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

#testsignal
#ffmpeg -re -f lavfi -i testsrc2=size=$resolution -f lavfi -i aevalsrc="sin(0*2*PI*t)" -vcodec libx264 -r 30 -g 30 -preset fast -vb 3000k -pix_fmt rgb24 -pix_fmt yuv420p -f flv $platform/$keyvalue


