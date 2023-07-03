#!/usr/bin/env bash
set -e

for item in $(sudo cat /etc/passwd | grep -v "nologin" | grep -v "false" | cut -d: -f1)
do
 if [ -f $(eval echo ~$item)/.ssh/authorized_keys ]; then
    echo "${item}"
 	sudo cat $(eval echo ~$item)/.ssh/authorized_keys | grep -oE "ssh-rsa [A-Za-z0-9/+=]+" | while read line; do
 	  echo "${line}" | md5sum | grep -oE "[A-Fa-f0-9]+" >> keys.list 
 	done
 fi
done

while read -r line; do
	a=$(echo "${line}" | cut -d' ' -f1)
	b=$(echo -n "${line}" | grep -oE "ssh-rsa [A-Za-z0-9/+=]+" | md5sum | grep -oE "[A-Fa-f0-9]+")
	c=$(echo -n "${line}" | grep -oE "ssh-rsa [A-Za-z0-9/+=]+")
	while read -r linekey; do
		if [[  ${b} == ${linekey} ]]; then
			echo " key: ${c} thuoc user: ${a}"
		fi
	done < keys.list
done < keys


#while read -r linekey; do
#	while read -r lineuser; do
#	a=$(echo "${lineuser}"| cut -d' ' -f2)
#	if [[ ${linekey} == ${a} ]]; then
#		b=$(echo "${lineuser}" | cut -d' ' -f1)
#		echo " key : ${linekey} thuoc user: ${b}"
#	fi
#	done < user.list
#done < keys.list
		