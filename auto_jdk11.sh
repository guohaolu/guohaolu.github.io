#!/bin/bash

cd /opt/
wget https://repo.huaweicloud.com/openjdk/11.0.1/openjdk-11.0.1_linux-x64_bin.tar.gz
tar -zxvf openjdk-11.0.1_linux-x64_bin.tar.gz
mv jdk-11.0.1/ /usr/local/

echo '' | sudo tee -a /etc/profile
echo '# jdk11' | sudo tee -a /etc/profile
echo 'export JAVA_HOME=/usr/local/jdk-11.0.1' | sudo tee -a /etc/profile
echo 'export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib/' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile

source /etc/profile
java -version
