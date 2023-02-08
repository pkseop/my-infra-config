
sudo yum update -y

sudo yum install java-11-amazon-corretto

sudo amazon-linux-extras install epel -y

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo yum install -y jenkins

sudo systemctl restart jenkins.service


sudo yum install -y nginx

location / {
		proxy_pass http://localhost:8080;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
	}

sudo systemctl enable nginx
sudo systemctl start nginx



1. kube config credential 생성
2. global tool 추가
  1) jdk
  2) gradle Gradle-5.6.4

3. awscli 설치
 curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
 unzip awscliv2.zip
 sudo ./aws/install
4. docker 설치
	sudo amazon-linux-extras install docker -y
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo usermod -a -G docker ec2-user
	sudo usermod -a -G docker jenkins
5. kubectl 설치
	curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
	curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl.sha256
	openssl sha1 -sha256 kubectl
	chmod +x ./kubectl
	sudo chown root:root kubectl
	sudo mv kubectl /usr/local/bin/

6. aws-iam-authenticator
	curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator

7. /log/statistics 디렉토리 생성 owner jenkins로 설절

		
Jenkinsfile_cloud_real

Real-grip-cloud-Admin
https://github.com/kspark-gripcorp/grip-admin.git

Real-grip-cloud-API
https://github.com/kspark-gripcorp/grip-api.git

Real-grip-cloud-FS
https://github.com/kspark-gripcorp/grip-fs.git

Real-grip-cloud-LMS
https://github.com/kspark-gripcorp/grip-lms.git


aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 639472183540.dkr.ecr.ap-northeast-2.amazonaws.com

# 젠킨스 사용자로 터미널 접속
sudo su - jenkins -s /bin/bash