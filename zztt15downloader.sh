#!/bin/bash

function ctlv_check_commands()
{
  for CMD in "$@"
  do
    if ! which $CMD > /dev/null
    then
      echo -e "You seem not to have '$CMD' command. Exit.." >&2
      exit -1
    fi
  done
}

ctlv_check_commands curl sed ffmpeg

URL=$1
if [ "$URL" == "" ]
then
  read -p "zztt15.com's URL: " URL
fi

OUTPUT=$2
if [ "$OUTPUT" == "" ]
then
  read -p "output file (default is output.mp4): " OUTPUT
  if [ "$OUTPUT" == "" ]
  then
    OUTPUT='output.mp4'
  fi
fi

M3U8=$(curl "$URL" | sed -n 's/.*\(http.*\.m3u8\).*/\1/gp' | sed 's/\\//g')

if [ "$M3U8" == "" ]
then
  echo "Video was not detected." >&2
  exit -1
fi

ffmpeg -i $M3U8 -c copy -bsf:a aac_adtstoasc -movflags faststart -user_agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.82 Safari/537.36' $OUTPUT
