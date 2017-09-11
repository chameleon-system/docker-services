#!/bin/bash
mount -t cifs //$1 $2 -o vers=3.0,username=$3,password=$4,dir_mode=0777,file_mode=0777,sec=ntlmssp
tail -f /dev/null
