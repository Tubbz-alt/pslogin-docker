TAG=20200616.0
IMAGE=slaclab/pslogin-docker

build:
	sudo docker build . -t ${IMAGE}:${TAG}
	sudo docker push ${IMAGE}:${TAG}
