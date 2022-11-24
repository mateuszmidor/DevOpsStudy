BIN = k8s-api-client-crd
SRC = main.go
DOCKER = ${BIN}:latest
FLAGS = -ldflags="-extldflags=-static"

default: ${BIN}

${BIN}: ${SRC}
	CGO_ENABLED=0 go build ${FLAGS} -o ${BIN} ${SRC}

docker: ${BIN}
	minikube image unload ${DOCKER} && docker build . -t ${DOCKER} && minikube image load ${DOCKER}
	
clean:
	rm -rf ${BIN}

.PHONY: ${BIN} # rebuild the binary every time