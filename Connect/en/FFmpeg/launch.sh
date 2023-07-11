#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
echo "🟢  Starting FFmpeg-Commander..."
(
    cd FFmpeg-Commander || exit
    touch nohup.out
    nohup npm run serve 2>&1 &
)

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="at ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Auxiliary interface starting ${MGM}..."

if [ ${FFMPEGD_STATUS} == "1" ]; then
    echo "🟢  Starting FFmpegd in 15 seconds..."
    sleep 15
    (
        cd FFmpegd || exit
        touch nohup.out
        ./ffmpegd "${FFMPEGD_PORT}"
    )
else
    echo "🙂  FFmpegd is disabled, and let it stay that way!"
fi

if [ ${FFMPEGD_STATUS} == "0" ]; then
    printf "\n \n🔎  The interface is only for you to copy the command that it will generate based on your settings,\n place your video files in the Media folder, and then paste the command here, and simply press [ENTER].\n \n"
fi

echo "📃  Available Commands: ${bold}${lightblue}ffmpeg ${normal}[your code]..."

while read -r line; do
    if [[ "$line" == *"ffmpeg"* ]]; then
        echo "Executing: ${bold}${lightblue}${line}"
        (
            cd Media || exit
            eval "$line"
        )
        printf "\n \n✅  Command Executed\n \n"
    elif [[ "$line" != *"ffmpeg"* ]]; then
        echo "Invalid Command. What are you trying to do? Try something with ${bold}${lightblue}ffmpeg."
    else
        echo "Script Failed."
    fi
done
