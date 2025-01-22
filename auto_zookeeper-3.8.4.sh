#!/bin/bash

cd /opt/
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz
tar -zxvf apache-zookeeper-3.8.4-bin.tar.gz
mv apache-zookeeper-3.8.4-bin/ /usr/local/

cd /usr/local/apache-zookeeper-3.8.4-bin/conf
cp zoo_sample.cfg zoo.cfg

sed -i '12c\dataDir=/root/zkdata/zookeeper' zoo.cfg
sed -i '14c\clientPort=5188' zoo.cfg
mkdir -p /root/zkdata/zookeeper

echo '' | sudo tee -a /etc/profile
echo '# zookeeper' | sudo tee -a /etc/profile
echo 'export ZOOKEEPER_HOME=/usr/local/apache-zookeeper-3.8.4-bin' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$ZOOKEEPER_HOME/bin' | sudo tee -a /etc/profile

source /etc/profile
