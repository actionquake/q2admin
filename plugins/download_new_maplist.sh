#!/bin/bash
#
# set this file to run periodically in crontab to let it download
# and update the latest maplists from www.aq2.eu/votemap
#

#### variables
# download URL
uri="https://www.aq2.eu/votemap/public.ini"
# parse the filename from the download path
file=$(echo $uri | sed -n 's/^\(.*\/\)*\(.*\)/\2/p')
# where to copy the downloaded file
dst="/home/aq2/aq2server/q2srv/action/config/public.ini"
# bypass Fragbaits modsecurity
usaragent="-d --user-agent=refresh-action.ini-script"
# Screen names of the servers you want to send sv_recycle to
screens=( gs1 gs2 gs3 )

#### script
# download the file if updated since last time
wget $usaragent -N $uri

# copy the file to the correct destination (if changed since last time)
# first check if the online file is newer than the local
dwnldfile_ctime=$(stat -c %z "$file")
dwnldfile_ctime=$(date --date="$dwnldfile_ctime" +%s)
dstfile_ctime=$(stat -c %z "$dst")
dstfile_ctime=$(date --date="$dstfile_ctime" +%s)
echo $dwnldfile_ctime
echo $dstfile_ctime
if (( $dstfile_ctime < $dwnldfile_ctime )); then
   echo "updating file"
   cp $file $dst
   
   #tell the server to restart on next map change
   for i in "${screens[@]}"
   do
      screen -S $i -X stuff "sv_recycle 1
      say [ Maplist updated ]^M"
   done
else
   echo "not updating file"
fi