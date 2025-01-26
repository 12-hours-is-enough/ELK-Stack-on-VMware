# ELK-Stack-on-VMware

<br><br>

## 📑 목차 

1. [⏲팀 소개](#-team-12시간이-모자라)
2. [🔍 프로젝트 개요](#-프로젝트-개요)
3. [🖥️ 개발 환경](#%EF%B8%8F-개발-환경)
4. [🏗️ 아키텍쳐](#%EF%B8%8F-아키텍쳐)
5. [🌐 환경 구성](#-환경-구성)
6. [✨ 설치 자동화](#-설치-자동화)
7. [🚨 트러블 슈팅](#-트러블-슈팅)
8. [🔄 회고](#-회고)

<br><br>

## ⏲ TEAM 12시간이 모자라 
### 팀원 소개
<div align=center> 
  

|<img src="https://avatars.githubusercontent.com/u/95984922?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/165532198?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/121565744?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/179544856?v=4" width="150" height="150"/>|
|:-:|:-:|:-:|:-:|
|나홍찬<br/>[@nahong_c](https://github.com/HongChan1412)|김소연<br/>[@ssoyeonni](https://github.com/ssoyeonni)|이은정<br/>[@eundeom](https://github.com/eundeom)|이은준<br/>[@2EunJun](https://github.com/2EunJun)|

</div>

<br><br>

## 🔍 프로젝트 개요
### ◽ 목표
이 프로젝트의 목표는 각각의 가상 머신(VM)에 Elasticsearch, Logstash, Kibana를 구성하여 ELK Stack 시스템을 구축하는 것입니다. VM 간의 통신을 원활하게 하기 위해 VirtualBox의 어댑터 브릿지를 사용합니다.

<br><br>

## 🖥️ 개발 환경 
> 운영체제 : Ubuntu:24.04.1<br>
> ELK-Stack : 7.17.27<br>
> JDK : 17.0.13<br>
> SSH Connection Tool : mobaxterm

<br><br>

## 🏗️ 아키텍쳐
<div align="center">
  <img src="https://github.com/user-attachments/assets/4b249dd4-21f7-42dd-9d6d-b286efe3a12e" width="700">
</div>

<br><br>

## 🌐 환경 구성

<br>

## 기존 설치된 Elasticsearch, Kibana, Logstash 삭제
```
# apt 패키지관리자로 삭제
$ sudo apt purge elasticsearch -y
$ sudo apt purge kibana -y
$ sudo apt purge logstash -y

# 잔여파일 삭제
$ sudo apt autoremove
$ sudo rm -rf /etc/elasticsearch /var/lib/elasticsearch /etc/logstash /var/lib/logstash /etc/kibana /var/lib/kibana
```
<br>

## Elasticsearch, Kibana, Logstash 설치
### 7.17.27버전을 선택 이유 
> 7.X버전중 가장 최신 릴리스 버전 선택<br>
> https://www.elastic.co/blog/elastic-stack-7-17-27-released

### Elasticsearch 7.x 패키지 저장소 추가
```
# GPG 키 추가
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Elastic 7.x 저장소 추가
$ echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# 패키지 목록 업데이트
$ sudo apt update
```

### Elastic 7.17.27 설치
```
# 버전지정 옵션으로 7.17.27버전 설치
$ sudo apt install elasticsearch=7.17.27

# dpkg 패키지에 설치된거 확인
$ dpkg -l | grep elasticsearch

# 상태확인
$ sudo systemctl status elasticsearch
```

### Kibana 7.17.27 설치
```
# 버전지정 옵션으로 7.17.27버전 설치
$ sudo apt install kibana=7.17.27

# dpkg 패키지에 설치된거 확인
$ dpkg -l | grep kibana

# 상태확인
$ sudo systemctl status kibana
```

### Logstash 7.17.27 설치
```
# logstash 설치
$ sudo apt install logstash=1:7.17.27-1

# 설치확인
$ dpkg -l | grep logstash

# 상태확인
$ sudo systemctl status logstash
```

<br>

## VM 추가 생성
### myserver1 복제
> myserver1(Elasticsearch, Kibana, Logstash설치되어 있는 VM)을 복제<br>
> 각 서비스를 VM으로 나누어 실행하게되면 자원을 개별적으로 할당하고 관리할 수 있고, 부하를 분산할 수 있음<br>

| 1 | 2 | 3 |
|---|---|---|
| ![Image 1](https://github.com/user-attachments/assets/b7daa9e6-a6ee-4d95-9e83-35d1f61d04ac) | ![Image 2](https://github.com/user-attachments/assets/ba252a9b-d3d4-49bc-9c66-dfe458b4e210) | ![Image 3](https://github.com/user-attachments/assets/62801242-8b24-43c3-ada0-b878946e7677) |


### 복제한 VM에 새로운 IP 할당
> VM이 실행중이면 종료<br>
> 설정 \> 네트워크 \> 어댑터 1 \> 어댑터에 브리지로 변경<br>
> MAC주소 새로고침(MAC주소가 복사되었기때문에 안겹치도록 바꿔줘야함)

<img src="https://github.com/user-attachments/assets/dddf9c38-3530-4fc5-98b6-49a3b98bf95a" width="500">

### Ubuntu 로그인하여 할당된 IP 확인(* IP주소는 바뀔 수 있음)
<img src="https://github.com/user-attachments/assets/9fd11c47-c787-4b2e-81da-bc8dc9c961e5" width="500">

> Elasticsearch IP : 192.168.0.128<br>
> Kibana IP : 192.168.0.126<br>
> Logstash IP : 192.168.0.127.128<br>

### Elasticsearch 실행
#### mobaxterm으로 Elasticsearch VM(192.168.0.128) 접속
```
$ sudo vi /etc/elasticsearch/elasticsearch.yml

# /etc/elasticsearch/elasticsearch.yml 수정
network.host: 0.0.0.0 # 외부에서 접속할 수 있도록 0.0.0.0으로 수정

$ sudo systemctl start elasticsearch.service
```

### Kibana 실행
#### mobaxterm으로 Kibana VM(192.168.0.126) 접속
```
$ sudo vi /etc/kibana/kibana.yml

# /etc/kibana/kibana.yml 수정

server.host: "0.0.0.0" # 외부에서 접속할 수 있도록 0.0.0.0으로 수정
elasticsearch.hosts: ["http://192.168.0.128:9200"] # elasticsearch의 주소 입력

$ sudo systemctl start kibana.service
```

### Logstash 실행
#### mobaxterm으로 Logstash VM(192.168.0.127) 접속
```
$ sudo vi /etc/logstash/conf.d/logstash.conf

# /etc/logstash/conf.d/logstash.conf 생성
# output 설정

output {
  elasticsearch {
    hosts => ["http://192.168.0.128:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
  stdout { codec => rubydebug }
}

$ sudo systemctl start kibana.service
```
<br>

## ✨ 설치 자동화
### 목표
> 스크립트 명령어를 모아 파일로 만들어 간단하게 설치할 수 있도록 함

### 설치 방법

```
# shell script 파일 설치

$ git clone https://github.com/12-hours-is-enough/ELK-Stack-on-VMware.git
$ cd setup_files/
```
<br>

> **[remove_elk.sh](https://github.com/12-hours-is-enough/ELK-Stack-on-VMware/blob/main/setup_files/remove_elk.sh)**
```
# 기존ELK 삭제

$ chmod +x remove_elk.sh
$ sudo ./remove_elk.sh
```
<br>

> **[install_elk.sh](https://github.com/12-hours-is-enough/ELK-Stack-on-VMware/blob/main/setup_files/intsall_elk.sh)**
```
# ELK 7.17.27 설치

$ chmod +x install_elk.sh
$ sudo ./install_elk.sh
```
<br>

> **[set_elasticsearch.sh](https://github.com/12-hours-is-enough/ELK-Stack-on-VMware/blob/main/setup_files/set_elasticsearch.sh)**
```
# elasticsearch .yml 수정

$ chmod+x set_elasticsearch.sh
$ sudo ./set_elasicsearch.sh
```
<br>

> **[set_kibana.sh](https://github.com/12-hours-is-enough/ELK-Stack-on-VMware/blob/main/setup_files/set_kibana.sh)**
```
# kibana.yml 수정

$ chmod+x set_kibana.sh
$ sudo ./set_kibana.sh
```
<br>

## [🧶 대용량실데이터 사용 링크](https://github.com/12-hours-is-enough/TomorrowTheInsuranceKing)

<br>

## 🚨 트러블 슈팅
### Elasticsearch 실행 오류
<img src="https://github.com/user-attachments/assets/910c65aa-36f3-46f5-bcf2-6814aa337551" width="700">

```
Job for elasticsearch.service failed because the control process exited with error code.
See "systemctl status elasticsearch.service" and "journalctl -xeu elasticsearch.service" for details.
```
> Elasticsearc의 버전이 7.13이상으로 업그레이드되면서 다중노드를 필요로함 강제로 2개 이상의 노드를 필요로 하는데 하나의 노드로 사용하기 위해 yml파일 수정

```
$ sudo vi /etc/elasticsearch/elasticsearch.yml

# 단일노드로 사용할수 있도록 구성
discovery.type: single-node
```

### Wifi사용시 VM 인터넷 연결 오류
![image](https://github.com/user-attachments/assets/c043e0ce-c293-433a-be4c-8b32c92a84b7)
> 설정 \> 네트워크 \> 이름 \> WI-FI랜카드 선택

<img src="https://github.com/user-attachments/assets/fde68fcf-d55f-4c00-80ce-0bf963cd0fb8" width="600">
<img src="https://github.com/user-attachments/assets/f8fb8837-f78d-47bd-bff0-e0e2cc764556" width="600">


<br><br>

## 🔄 회고
ELK 스택을 구성하는 과정에서, 모든 구성 요소를 하나의 VM에 올리는 대신 3개의 VM을 사용하여 서로 통신할 수 있도록 설정하는 것이 어려운 부분이었습니다. <br>
또한, 버전 간의 호환성 문제로 인해 발생한 트러블슈팅을 통해 해결 방법을 찾는 과정은 매우 흥미로웠습니다. <br>
3개의 VM을 운영하면서 부하를 분산하는 아키텍처를 구성해보는 경험을 쌓을 수 있었습니다. <br>
팀원들과 어떤 버전을 설치할지 고민하고, 설치 과정에서 발생한 문제를 함께 해결해보며 많은 것을 배운 좋은 경험이었습니다
