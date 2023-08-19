#!/usr/bin/env bash
# Updated for aqtion (action quake 2) by darksaint 2022-05-15
# small transfer script by Shaque 2012-11-22
# and more changes done by lots of people over the course ;)
mvd="$1"
#method="$2"

_filepath="action/demos"
_file="${mvd}"
_fullfilepath="${_filepath}/${_file}"

# If using s3cmd to upload, set this as your bucket name
_s3bucket="aq2world"

# if using scp or sftp to upload, someuser@aq2world.com is the target user and host, change that to your needs.
_targetuserhost="someuser@aq2world.com"

# here, demos/ is the target directory, change that to your needs.
_targetdir="demos/aqtion"

# Edit this for your demo list path (example: vrol/vrol_pickup_1)
_servertargetdir="SERVERTARGETDIR"

# if using scp to upload, set this as your private key file for PKI auth
_rsakeylocation="$HOME/.ssh/id_rsa"

## AQTion MVD transfer

if [ -f "${_fullfilepath}" ]; then
  ( sleep 10 ) && ( s3cmd put "${_fullfilepath}" s3://${_s3bucket}/${_targetdir}/${_servertargetdir}/${_file} ) &
elif [ -z "${_file}" ]; then
  echo "$0 Error: $_file not found. Not transferring anything. :("
  exit 1
else
  echo "Something went wrong other than file not found"
  exit 1
fi

## Old method, keeping around but unused:

# if [ -f "${_filepath}/${_file}" ]; then
#   sleep 2
#   # sleep a little, so q2proded has time to finalize the demo file
#   if [ "${method}" == "sftp" ]; then
#     ( echo "put ${_file} '${_targetdir}'" | sftp -q -o PasswordAuthentication=no -p ${_targetuserhost} ) &
#   elif [ "${method}" == "scp" ]; then
#     scp -i "${_rsakeylocation}" "${_file}" ${_targetuserhost} &
#   elif [ "${method}" == "s3cmd" ]; then
#     s3cmd put "$_file" s3://${_s3bucket}/${_targetdir}/${_servertargetdir}/"${_file}" &
#   elif [ "${method}" == "cp" ]; then
#     cp "${_file}" ${_targetdir} &
#   elif [ -z "${_file}" ]; then
#     echo "$0 Error: '$_file' not found. Not transferring anything. :("
#   else
#     echo "The second argument to this script is your upload method,"
#     echo "choose [ sftp | scp | s3cmd | cp ]"
#     echo "And set your mvd_transfer.sh script correctly!"
#     exit 1
#   fi
# fi


# vim: expandtab tabstop=2 autoindent:
# kate: space-indent on; indent-width 2; mixedindent off;
