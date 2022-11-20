BIN = k8s-api-client
SRC = main.go
DOCKER = k8s-api-client:latest
FLAGS = -ldflags="-extldflags=-static"

default: ${BIN}

${BIN}: ${SRC}
	CGO_ENABLED=0 go build ${FLAGS} -o ${BIN} ${SRC}

docker: ${BIN}
	docker build . -t ${DOCKER}
	minikube image load ${DOCKER}
	
clean:
	rm -rf ${BIN}

.PHONY: ${BIN} # rebuild the binary every time