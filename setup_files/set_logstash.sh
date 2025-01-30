#!/bin/bash

# Logstash 설정 자동화 스크립트

CONF_SAMPLE="/etc/logstash/logstash-sample.conf"
CONF_TARGET="/etc/logstash/conf.d/logstash.conf"

# 사용자에게 Elasticsearch 주소 입력받기
read -p "Elasticsearch 주소를 입력하세요 (예: http://192.168.0.135:9200): " elasticsearch_url

if [ -z "$elasticsearch_url" ]; then
    echo "Elasticsearch 주소를 입력하지 않았습니다. 스크립트를 종료합니다."
    exit 1
fi

echo "Logstash 설정 파일을 복사합니다..."
sudo cp "$CONF_SAMPLE" "$CONF_TARGET"

# hosts 부분 수정
sudo sed -i "s|hosts => \[\"http://localhost:9200\"\]|hosts => [\"$elasticsearch_url\"]|" "$CONF_TARGET"

echo "Logstash 설정이 완료되었습니다."
