## Purpose
### Adding Following support for jenkins Slave
- NodeJS
- MongoShell
- GO
- Python
- Docker
- kubectl
- git lfs
- Apache-Maven

## Building
```ssh
docker build -t urashidmalik/jenkins-jnlp-kubectl-docker:latest .
docker push  urashidmalik/jenkins-jnlp-kubectl-docker:latest
```

## Testing
```ssh
docker run -it --entrypoint /bin/bash   urashidmalik/jenkins-jnlp-kubectl-docker
```


echo "@edge http://dl-3.alpinelinux.org/alpine/v3.7/main/" >> /etc/apk/repository
