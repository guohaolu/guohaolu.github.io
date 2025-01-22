#!/bin/bash

myFile=/data/data1
if [ ! -x "$myFile" ]; then
    mkdir -p "$myFile"
fi

# 使用 here document 自动化 fdisk 操作
fdisk /dev/vdb <<EOF
n
p



w
EOF

echo -e "\n\n**************** 格式化磁盘 ****************\n\n"
sleep 5s

mkfs.ext4 /dev/vdb1

echo -e "\n\n**************** mount挂载磁盘 ****************\n\n"
sleep 1s

echo "/dev/vdb1 /data/data1 ext4 defaults 0 0" >> /etc/fstab
