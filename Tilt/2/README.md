# docker_build

Build docker image with custom http server in golang, deploy it to kubernetes and display the index page in firefox

* every time `main.go` is updated, the docker image of the application is automatically rebuilt and redeployed to kubernetes
* the whole rebuild+redeploy takes ~ 22sec

```text
STEP 1/3 — Building Dockerfile: [http-server-img]
Building Dockerfile for platform linux/amd64:
  # syntax=docker/dockerfile:1
  FROM golang:1.21

  WORKDIR /app

  COPY go.mod ./
  COPY go.sum ./
  COPY *.go ./

  RUN go mod download
  RUN CGO_ENABLED=0 GOOS=linux go build -o /http-server

  EXPOSE 8080
  CMD ["/http-server"]

     Building image
     resolve image config for docker.io/docker/dockerfile:1 [done: 589ms]
     docker-image://docker.io/docker/dockerfile:1@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
     [1/7] FROM docker.io/library/golang:1.21@sha256:24a09375a6216764a3eda6a25490a88ac178b5fcb9511d59d0da5ebf9e496474
     [background] read source files 484B [done: 15ms]
     [2/7] WORKDIR /app [cached]
     [3/7] COPY go.mod ./ [cached]
     [4/7] COPY go.sum ./ [cached]
     [5/7] COPY *.go ./ [cached]
     [6/7] RUN go mod download [cached]
     [7/7] RUN CGO_ENABLED=0 GOOS=linux go build -o /http-server [cached]
     exporting to image

STEP 2/3 — Pushing http-server-img:tilt-62ec15ec2277f914
     Skipping push: building on cluster's container runtime

STEP 3/3 — Deploying
     Applying YAML to cluster
     Objects applied to cluster:
       → http-server:pod

     Step 1 - 1.43s (Building Dockerfile: [http-server-img])
     Step 2 - 0.00s (Pushing http-server-img:tilt-62ec15ec2277f914)
     Step 3 - 0.02s (Deploying)
     DONE IN: 1.45s

[event: pod http-server] Container image "http-server-img:tilt-62ec15ec2277f914" already present on machine
Detected container restart. Pod: http-server. Container: http-server.
2023/10/14 17:24:40 listening at :8080
```