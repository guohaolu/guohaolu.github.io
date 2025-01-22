#!/bin/bash

cd /opt/
wget https://dragonwell.oss-cn-shanghai.aliyuncs.com/8.23.22/Alibaba_Dragonwell_Standard_8.23.22_x64_linux.tar.gz
tar -zxvf Alibaba_Dragonwell_Standard_8.23.22_x64_linux.tar.gz
mv dragonwell-8.23.22/ /usr/local/

echo '' | sudo tee -a /etc/profile
echo '# jdk8' | sudo tee -a /etc/profile
echo 'export JAVA_HOME=/usr/local/dragonwell-8.23.22' | sudo tee -a /etc/profile
echo 'export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib/' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile

source /etc/profile
java -version
