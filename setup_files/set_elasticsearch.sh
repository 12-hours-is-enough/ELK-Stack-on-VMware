#!/bin/bash

# Elasticsearch 설정 자동화 스크립트

CONFIG_FILE="/etc/elasticsearch/elasticsearch.yml"

echo "Elasticsearch 설정 파일을 수정합니다: $CONFIG_FILE"

# 백업 파일 생성
if [ ! -f "$CONFIG_FILE.bak" ]; then
    echo "기존 설정 파일 백업 생성 중..."
    sudo cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
    echo "백업 파일 생성 완료: $CONFIG_FILE.bak"
else
    echo "기존 백업 파일이 이미 존재합니다: $CONFIG_FILE.bak"
fi

# 설정 파일 수정
echo "network.host와 discovery.type 설정을 적용합니다..."

sudo sed -i "s/^#*\s*network\.host:.*/network.host: 0.0.0.0/" "$CONFIG_FILE" || echo "network.host: 0.0.0.0" | sudo tee -a "$CONFIG_FILE"
sudo sed -i "/^discovery\.type:/d" "$CONFIG_FILE" && echo "discovery.type: single-node" | sudo tee -a "$CONFIG_FILE"

echo "Elasticsearch 설정이 완료되었습니다."
