#!/bin/bash

#this is just a testscript i did, maybe make it functionable in the future


myArray=("$@")
myArrayLength=${myArray[@]}


: <<'COMMENT'
       GPU Screen Recorder can be controlled via signals:
       SIGINT (Ctrl+C) - Stop and save recording (stop without save in replay mode).
       SIGUSR1 - Save replay (replay mode only).
       SIGUSR2 - Pause/unpause recording (not for streaming/replay).
       SIGRTMIN - Start/stop regular recording during replay/streaming.
       SIGRTMIN+1 - Save last 10 seconds (replay mode).
       SIGRTMIN+2 - Save last 30 seconds (replay mode).
       SIGRTMIN+3 - Save last 60 seconds (replay mode).
       SIGRTMIN+4 - Save last 5 minutes (replay mode).
       SIGRTMIN+5 - Save last 10 minutes (replay mode).
       SIGRTMIN+6 - Save last 30 minutes (replay mode).
       Use pkill to send signals (e.g., pkill -SIGUSR1 -f gpu-screen-recorder).
COMMENT


echo "pkill -SIGUSR1 -r gpu-screen-recorder"
echo "number of arguments $#"


#i=0


for arg; do
        #if $arg="SAVEREPLAY" {commands="SIGUSR1"}
        echo "---"
        echo "$arg"

        #if $arg="stop" {commands="stopstop"}
        #       echo "stop"


        #pkill -SIGUSR1 -r gpu-screen-recorder
        #$runcmdline = "pkill -SIGUSR1 -r gpu-screen-recorder"
        #echo $runcmdline
done

