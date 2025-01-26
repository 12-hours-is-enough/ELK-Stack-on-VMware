#!/bin/bash

# Kibana 설정 자동화 스크립트

CONFIG_FILE="/etc/kibana/kibana.yml"

echo "Kibana 설정 파일을 수정합니다: $CONFIG_FILE"

# 사용자에게 Elasticsearch 주소 입력받기
read -p "Elasticsearch 주소를 입력하세요 (예: http://192.168.0.135:9200): " elasticsearch_url

if [ -z "$elasticsearch_url" ]; then
    echo "Elasticsearch 주소를 입력하지 않았습니다. 스크립트를 종료합니다."
    exit 1
fi

# 백업 파일 생성
if [ ! -f "$CONFIG_FILE.bak" ]; then
    echo "기존 설정 파일 백업 생성 중..."
    sudo cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
    echo "백업 파일 생성 완료: $CONFIG_FILE.bak"
else
    echo "기존 백업 파일이 이미 존재합니다: $CONFIG_FILE.bak"
fi

# 설정 파일 수정
echo "server.host와 elasticsearch.hosts 설정을 적용합니다..."

# server.host 수정
sudo sed -i "s/^#*\s*server\.host:.*/server.host: \"0.0.0.0\"/" "$CONFIG_FILE" || echo "server.host: \"0.0.0.0\"" | sudo tee -a "$CONFIG_FILE"

# elasticsearch.hosts 수정
sudo sed -i "s|^#*\s*elasticsearch\.hosts:.*|elasticsearch.hosts: [\"$elasticsearch_url\"]|" "$CONFIG_FILE" || echo "elasticsearch.hosts: [\"$elasticsearch_url\"]" | sudo tee -a "$CONFIG_FILE"

echo "Kibana 설정이 완료되었습니다."
