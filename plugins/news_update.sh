#!/usr/bin/bash
# a script that checks and downloads of the news master file

# download URL
url="$1"
gamedir="$2"
# bypass modsecurity
usaragent="-d --user-agent=news-update-script"
# parse the filename from the download path
filename=$(echo $url | sed -n 's/^\(.*\/\)*\(.*\)/\2/p')

# script to download latest h_news.cfg from github
cd "${0%/*}"    # cd to current dir
cd ../$gamedir/   # cd back and to game dir

#### script
# download the file if updated since last time, and output wheter it updated or not to console

if [[ "$url" == *"githubusercontent"* ]]; then
  # not using -N switch for wget since github does not support "last update" parameter, the file will be downloaded on every check, wich is not optimal
  wget -O $filename $url 2>&1 | tee | grep -E 'Omitting download|"h_news.txt" saved|ERROR 404: Not Found'
else
  # using -N switch for wget since the file os not hosted on github, best solution, since file will only be downloaded if changed
  wget $usaragent -N $url 2>&1 | tee | grep -E 'Omitting download|"h_news.txt" saved|ERROR 404: Not Found'
fi

exit