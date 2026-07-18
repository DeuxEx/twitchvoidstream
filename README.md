This is a shell/bash script to send a videostream to twitch.
I use void linux but it can be used on all linux platforms, maybe even on windows.

create a file called stream.key which contains your twitchkey.





#install the following

xbps-install gpu-screen-recorder

xbps-install gpu-screen-recorder-notification

xbps-install gpu-screen-recorder-ui

xbps-install ffmpeg


#I find these installs to be helpful in this content

xbps-install mediainfo-cli-26.05_1

xbps-install rtmpdump-2.4.20161210_10



I have a two-monitor setup and I run steam games on "HDMI-A-1" device which you can see in the variables in ths script, you can change to other options.

I have remmed two other commandlines and swapping between those then im testing different setups.
One commandline sends a testscreen to twitch and the other sends the captured data into a mp4 file.




