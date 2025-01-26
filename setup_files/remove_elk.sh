#!/bin/bash

# Elasticsearch, Kibana, Logstash 삭제 스크립트

echo "Elasticsearch, Kibana, Logstash 삭제를 시작합니다..."

# apt 패키지 제거
echo "패키지 제거 중..."
sudo apt purge elasticsearch -y
sudo apt purge kibana -y
sudo apt purge logstash -y

# 잔여 파일 제거
echo "잔여 파일 제거 중..."
sudo apt autoremove -y
sudo rm -rf /etc/elasticsearch /var/lib/elasticsearch
sudo rm -rf /etc/logstash /var/lib/logstash
sudo rm -rf /etc/kibana /var/lib/kibana

echo "Elasticsearch, Kibana, Logstash 삭제가 완료되었습니다."