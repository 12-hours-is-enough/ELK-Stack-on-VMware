# ELK-Stack-on-VMware

## 개발환경
> 운영체제 : Ubuntu:24.04.4<br>
> ELK-Stack : 7.17.27<br>
> JDK : 17.0.13<br>
> SSH Connection Tool : mobaxterm

## 아키텍쳐

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

## Elasticsearch, Kibana, Logstash 설치
### 7.17.27버전을 선택 이유 
> 7.X버전중 가장 최신 릴리스 버전 선택

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

## VM 추가 생성
### myserver1 복제
> myserver1(Elasticsearch, Kibana, Logstash설치되어 있는 VM)을 복제<br>
> 각 서비스를 VM으로 나누어 실행하게되면 자원을 개별적으로 할당하고 관리할 수 있고, 부하를 분산할 수 있음<br>

![image](https://github.com/user-attachments/assets/b7daa9e6-a6ee-4d95-9e83-35d1f61d04ac)![image](https://github.com/user-attachments/assets/ba252a9b-d3d4-49bc-9c66-dfe458b4e210)![image](https://github.com/user-attachments/assets/62801242-8b24-43c3-ada0-b878946e7677)

### 복제한 VM에 새로운 IP 할당
> VM이 실행중이면 종료<br>
> 설정 \> 네트워크 \> 어댑터 1 \> 어댑터에 브리지로 변경<br>
> MAC주소 새로고침(MAC주소가 복사되었기때문에 안겹치도록 바꿔줘야함)

![image](https://github.com/user-attachments/assets/dddf9c38-3530-4fc5-98b6-49a3b98bf95a)

### Ubuntu 로그인하여 할당된 IP 확인(* IP주소는 바뀔 수 있음)
![image](https://github.com/user-attachments/assets/9fd11c47-c787-4b2e-81da-bc8dc9c961e5)
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

## 대용량실데이터 사용 링크

## 트러블 슈팅
### Elasticsearch 실행 오류
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

![image](https://github.com/user-attachments/assets/910c65aa-36f3-46f5-bcf2-6814aa337551)

### Wifi사용시 VM 인터넷 연결 오류
![image](https://github.com/user-attachments/assets/c043e0ce-c293-433a-be4c-8b32c92a84b7)
> 설정 \> 네트워크 \> 이름 \> WI-FI랜카드 선택

![image](https://github.com/user-attachments/assets/fde68fcf-d55f-4c00-80ce-0bf963cd0fb8)
![image](https://github.com/user-attachments/assets/f8fb8837-f78d-47bd-bff0-e0e2cc764556)

## 회고
ELK 스택을 구성하는 과정에서, 모든 구성 요소를 하나의 VM에 올리는 대신 3개의 VM을 사용하여 서로 통신할 수 있도록 설정하는 것이 어려운 부분이었습니다. <br>
또한, 버전 간의 호환성 문제로 인해 발생한 트러블슈팅을 통해 해결 방법을 찾는 과정은 매우 흥미로웠습니다. <br>
3개의 VM을 운영하면서 부하를 분산하는 아키텍처를 구성해보는 경험을 쌓을 수 있었습니다. 
