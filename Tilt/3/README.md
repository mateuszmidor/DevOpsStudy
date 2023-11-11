# live_update

Build docker image with custom http server in golang, deploy it to kubernetes and display the index page in firefox

* every time `main.go` is updated, it gets sent to the running docker container, the server binary gets rebuilt in-place and restarted
* it takes only 1 sec, as compared to ~22sec for total rebuild+redeploy

## Run
```sh
tilt up
```

```text
Will copy 1 file(s) to container: [http-server/http-server]
- '/home/user/SoftwareDevelopment/DevOpsStudy/Tilt/3/main.go' --> '/app/main.go'
RUNNING: tar -C / -x -f -
[CMD 1/2] sh -c cd /app && CGO_ENABLED=0 GOOS=linux go build -o /http-server
RUNNING: cd /app && CGO_ENABLED=0 GOOS=linux go build -o /http-server
[CMD 2/2] sh -c date > /tmp/.restart-proc
RUNNING: date > /tmp/.restart-proc
  → Container http-server/http-server updated!
2023/10/14 17:22:41 listening at :8080
2023/10/14 17:22:50 GET /
```