#!/usr/bin/env bash
set -ex
for item in $(sudo cat /etc/passwd | grep -v "nologin" | grep -v "false" | cut -d: -f1)
do
	if [ -f $(eval echo ~$item)/.ssh/authorized_keys ]; then
                echo "${item}"
                sudo cat $(eval echo ~$item)/.ssh/authorized_keys | grep -oE "ssh-rsa [A-Za-z0-9/+=]+" >> keys.list
        fi
        done
while read -r linekey; do
        a=$(echo "${linekey}" | md5sum | grep -oE "[A-Fa-f0-9]+")
        flag=0
while read -r line; do
        b=$(echo "${line}" | cut -d' ' -f1)
        c=$(echo -n "${line}" | grep -oE "ssh-rsa [A-Za-z0-9/+=]+")
        d=$(echo "${c}" | md5sum | grep -oE "[A-Fa-f0-9]+")

        if [[ ${a} == ${d} ]]; then
                flag=1
                echo "user: ${b}" >> login.list
                break
        fi
        done < keys
        if [ ${flag} == 0 ]; then
                echo "key: ${linekey}" >> nologin.list
        fi
done < keys.list

echo "user co the login :"
cat -n login.list
echo "-------------------------------"
echo "key khong thuoc user nao :"
cat -n nologin.list
