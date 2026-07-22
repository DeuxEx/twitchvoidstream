<a href="https://repo-default.voidlinux.org/">
<img src="void_button.gif" alt="Description"></a>

<h1>Stream on void linux with wayland</h1>

This is a shell/bash script to send a videostream to twitch.<br>
I use void linux but it can be used on all *nix platforms if configured right.<br>
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
xbps-install mbuffer<br>


#I find these installs to be helpful in this context<br>

xbps-install mediainfo-cli<br>
xbps-install rtmpdump<br>
xbps-install vlc<br>
xbps-install ImageMagick<br>
xbps-install nvtop<br>
xbps-install steam<br>
xbps-install droidcam<br>
xbps-install btop<br>
xbps-install google-fonts-ttf<br>
xbps-install feh<br>

<p></p>
Short procedure how everything works<br>
1. gpu-screen-recorder captures the screen, application etc<br>
2. the data is piped to a big mbuffer to prevent lag between gpu-screen-recorder and ffmpeg.<br>
3. the data is piped from mbuffer to ffmpeg and send to twitch<br>
<p></p>

I have a two-monitor setup and I run steam games on "HDMI-A-1" device which you can see in the variables in ths script, you can change to other options.<br>

I have remmarked two other commandlines and I am swapping between those when testing different setups.<br>
One commandline sends a testscreen to twitch and the other sends the captured data into a mp4 file.<br>

Dont forget to make the scriptfile executeable with<br>
chmod +x start-stream.sh<br>
<br>
And start it with:<br>
./start-stream.sh<br><p>


