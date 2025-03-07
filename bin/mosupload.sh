#!/usr/bin/env sh

[ -z $1 ] &&  echo "${0##*/} <file to upload>" && exit 1
p=$(realpath "$1")

[ ! -f "${p}" ] && echo "${p} is not a file." && exit 1; 

printf "SR: "; read s; 
printf "Login: "; read l; 
u="https://transport.oracle.com/upload/issue/${s}/"
curl --verbose --progress-bar --user ${l} --upload-file "${p}" ${u};
