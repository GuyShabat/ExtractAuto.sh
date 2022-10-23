#!/bin/bash

#Author: Guy Shabat
#Date: 23/10/2022

#Description:
#This script get a MEM file or HDD file from the user and extracting information from the files using
#multiple carvers and then displaying the data to the user as creating a destinated directory to sort all files.
#Usage: ExtractAuto.sh


DATE=$(date +"%d-%m-%Y")
function MEM()
{
	#takes file and starting carving using multiple carvings.
		mkdir "$DATE-$user"
			echo "[*] Analyizing memory file $user..."
		echo	
			 echo "[!] Please wait as this can take sometime..."
				bulk_extractor "$user" -o "$DATE-$user"/bulk 1>/dev/null
				strings "$user" > "$DATE-$user"/stringsraw.txt
				strings "$user" | grep password > "$DATE-$user"/stringsfiltered.txt
				foremost -Q -i "$user" -t all -o "$DATE-$user"/foremost
				./vol -f "$user" imageinfo 2>/dev/null 1>"$DATE-$user"/profile.lst
				profile=$(cat "$DATE-$user"/profile.lst | grep -i profile | awk '{print $NF}')
				./vol -f "$user" --profile="$profile" pslist 2>/dev/null 1>"$DATE-$user"/pslist.txt
}

function HDD()
{
	#carving the hdd using multiple carvings.
	mkdir "$DATE-$user"
			echo "[*] Analyizing HDD file $user..."
			echo "[!] Please wait as this can take sometime"
				bulk_extractor "$user" -o "$DATE-$user"/bulk 1>/dev/null
				strings "$user" > "$DATE-$user"/stringsraw.txt
				strings "$user" | grep password > "$DATE-$user"/stringsfiltered.txt
				foremost -Q -i "$user" -t all -o "$DATE-$user"/foremost 1>/dev/null
}
function LOG()
{
	#Showing some statistcs about the data extracted.
	echo "[+] Directory added $DATE-$user.." 
	   echo
				sleep 1
				echo "[*] The analysis ended you can watch all the data extracted in the $DATE-$user directory."
				sleep 0.5
			echo
			find "$DATE-$user"/bulk -type f -size -1k -delete
				echo "[#] Total bulk files found: " $(tree "$DATE-$user"/bulk | tail -1 | awk '{print $3,$4}')
				echo
				if [ -d "$DATE-$user/bulk/jpeg_carved" ]
				 then
				 echo "[!] Found Jpeg files!"
				fi 
				 if [ -d "$DATE-$user/bulk/zip" ] 
				 then
				   echo "[!] Found ZIP files!"
				 fi  
				sleep 0.5
			echo
				echo "[#] Total foremost files found: " $(tree "$DATE-$user"/foremost | tail -1 | awk '{print $3,$4}')
				if [ -f "$DATE-$user"/bulk/packets.pcap ]
				then
				echo "[#] found a pcap file: " $(ls -lah "$DATE-$user"/bulk | grep pcap | awk '{print $NF,$5}')
			echo	
				fi	
}
read -p "Hello user please enter ur choice mem or hdd: " chc
read -p "Now enter the name of the file: " user

if [ "$chc" == mem ]
	then 
	 MEM
	 LOG
	 elif [ "$chc" == hdd ]
	 then
	 HDD
	 LOG
fi

exit 0
