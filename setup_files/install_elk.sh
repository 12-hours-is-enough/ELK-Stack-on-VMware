#!/bin/bash

# Elasticsearch, Kibana, Logstash 설치 스크립트

echo "Elasticsearch, Kibana, Logstash 설치를 시작합니다..."

# GPG 키 추가
echo "GPG 키를 추가 중..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Elastic 7.x 저장소 추가
echo "Elastic 7.x 저장소를 추가 중..."
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# 패키지 목록 업데이트
echo "패키지 목록을 업데이트 중..."
sudo apt update

# Elasticsearch 설치
echo "Elasticsearch 7.17.27을 설치 중..."
sudo apt install elasticsearch=7.17.27 -y

# Kibana 설치
echo "Kibana 7.17.27을 설치 중..."
sudo apt install kibana=7.17.27 -y

# Logstash 설치
echo "Logstash 7.17.27을 설치 중..."
sudo apt install logstash=1:7.17.27-1 -y

echo "Elasticsearch, Kibana, Logstash 설치가 완료되었습니다."
