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