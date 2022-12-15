BIN = echo-server
SRC = main.go
DOCKER = ${BIN}:latest
FLAGS = -ldflags="-extldflags=-static"
DOCKERHUB_USER = ???

default: ${BIN}

${BIN}: ${SRC}
	CGO_ENABLED=0 go build ${FLAGS} -o ${BIN} ${SRC}

docker: ${BIN}
	minikube image unload ${DOCKER} && docker build . -t ${DOCKER} && minikube image load ${DOCKER}
	
docker-push: ${BIN}
	docker build . -t ${DOCKERHUB_USER}/${DOCKER}
	docker push ${DOCKERHUB_USER}/${DOCKER}

start:
	kubectl apply -f echo-server.yaml

stop:
	kubectl delete -f echo-server.yaml

build-and-restart: stop docker start 

clean:
	rm -rf ${BIN}

.PHONY: ${BIN} # rebuild the binary every time