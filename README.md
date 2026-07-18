<a href="https://repo-default.voidlinux.org/">
<img src="void_button.gif" alt="Description"></a>

<h1>Stream on void linux with wayland</h1>

This is a shell/bash script to send a videostream to twitch.<br>
I use void linux but it can be used on all linux platforms.<br>
<p>
Details of my void install are:<br>
void linux x86_x64<br>
sddm display manager<br>
kde plasma windows manager<br>
wayland setup launching from sddm (kwin_wayland)<br>
<p>

first create this;

create a file called stream.key which contains your twitchkey.


<p></p>


#install the following<br>
xbps-install gpu-screen-recorder<br>
xbps-install gpu-screen-recorder-notification<br>
xbps-install gpu-screen-recorder-ui<br>
xbps-install ffmpeg<br>


#I find these installs to be helpful in this content<br>

xbps-install mediainfo-cli<br>
xbps-install rtmpdump<br>



I have a two-monitor setup and I run steam games on "HDMI-A-1" device which you can see in the variables in ths script, you can change to other options.<br>

I have remmed two other commandlines and swapping between those then im testing different setups.<br>
One commandline sends a testscreen to twitch and the other sends the captured data into a mp4 file.<br>




