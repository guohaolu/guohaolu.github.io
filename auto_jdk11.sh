#!/bin/bash

cd /opt/
wget https://repo.huaweicloud.com/openjdk/11.0.1/openjdk-11.0.1_linux-x64_bin.tar.gz
tar -zxvf openjdk-11.0.1_linux-x64_bin.tar.gz
mv jdk-11.0.1/ /usr/local/

echo " " >> /etc/profile
echo "# jdk11" >> /etc/profile
echo "export JAVA_HOME=/usr/local/jdk-11.0.1" >> /etc/profile
echo "export CLASSPATH=$:CLASSPATH:$JAVA_HOME/lib/" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile

source /etc/profile
java -version
