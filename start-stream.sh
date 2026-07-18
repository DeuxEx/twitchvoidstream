#script to start twitchstream on capturedevice

#run this cmd to bypass authentication every time
#gsr info: gsr_kms_client_init: gsr-kms-server is missing sys_admin cap and will require root authentication.

#To bypass this automatically, run:
#sudo setcap cap_sys_admin+ep '/usr/bin/gsr-kms-server'

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

#-k codec
# Video codec: auto, h264, hevc, av1, vp8, vp9, hevc_hdr, av1_hdr,
# hevc_10bit, av1_10bit (default: auto → h264). HDR options not
# available on X11 or portal capture.




# -f format
# -i input file url
# -i - = standard input



#gpu-screen-recorder -w $capturedevice -c $videocodec -s $resolution -bm cbr -q $quality -encoder gpu -ab $audiobitrate  -f $framerate -a default_output |
# ffmpeg -i - -f mpegts -c:a copy -f flv $platform/$streamkey


#output to file
#gpu-screen-recorder -ab $audiobitrate -w $capturedevice -c $format -s $resolution -bm cbr -q $quality -ac $audiocodec -cursor no -cr $colorrange -k $videocodec -encoder gpu -f $framerate -a default_output -restore-portal-session yes -o /home/void/testrun.mp4


#stream to twitch
#Use ffmpeg to stream to an RTMP server, continue processing the stream at real-time rate even in case of temporary failure (network outage) and attempt to recover streaming every second indefinitely:
gpu-screen-recorder -ab $audiobitrate -w $capturedevice -c $format -s $resolution -bm cbr -q $quality -ac $audiocodec -cursor no -cr $colorrange -k $videocodec -encoder gpu -f $framerate -a default_output -restore-portal-session yes | ffmpeg -re -i - -c:v libx264 -c:a aac -f fifo -fifo_format flv -drop_pkts_on_overflow 1 -attempt_recovery 1 -recovery_wait_time 1 -map 0:v -map 0:a $platform/$keyvalue


#stop the stream after stop with ctrl-z
killall ffmpeg


#testsignal
#ffmpeg -re -f lavfi -i testsrc2=size=$resolution -f lavfi -i aevalsrc="sin(0*2*PI*t)" -vcodec libx264 -r 30 -g 30 -preset fast -vb 3000k -pix_fmt rgb24 -pix_fmt yuv420p -f flv $platform/$keyvalue




