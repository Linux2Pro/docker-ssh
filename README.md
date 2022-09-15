## SSH Daemon (CentOS 8 & Supervisord Golang)

[![GitHub Open Issues](https://img.shields.io/github/issues/million12/docker-ssh.svg)](https://github.com/million12/docker-ssh/issues)
[![GitHub Stars](https://img.shields.io/github/stars/million12/docker-ssh.svg)](https://github.com/million12/docker-ssh)
[![GitHub Forks](https://img.shields.io/github/forks/million12/docker-ssh.svg)](https://github.com/million12/docker-ssh)
[![Stars on Docker Hub](https://img.shields.io/docker/stars/million12/ssh.svg)](https://hub.docker.com/r/million12/ssh)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/million12/ssh.svg)](https://hub.docker.com/r/million12/ssh)
[![](https://images.microbadger.com/badges/image/million12/ssh.svg)](http://microbadger.com/images/million12/ssh)


Docker image with SSHD running under CentOS 8 and Supervisor.

#### Usage
to be able to connect user can provide port and password for `root` user. Please see examples below.

Example:

	docker run -d --name ssh -p 10022:22 jniltinho/docker-ssh

**if `root` passoword is not provided image will generate one and it can be retrived from logs**

    docker logs ssh
    [SSHD 09:49:22] root password set to: ota7zohsh0AZu2Ex

Login using that password:

    ssh root@docker.io -p 10022
    root@docker.ip's password: ota7zohsh0AZu2Ex

#### Environmental Variable

`ROOT_PASS` = root user password

#### Custom Password deployment

Example:

	docker run -d --name ssh -p 10022:22 --env="ROOT_PASS=my_pass" jniltinho/docker-ssh

### Docker troubleshooting


Use docker command to see if all required containers are up and running:

    $ docker ps -a

Check online logs of ssh container:

    $ docker logs ssh

Attach to running ssh container (to detach the tty without exiting the shell,
use the escape sequence Ctrl+p + Ctrl+q):

    $ docker attach ssh

Sometimes you might just want to review how things are deployed inside a running container, you can do this by executing a _bash shell_ through _docker's exec_ command:

    docker exec -i -t ssh /bin/bash

History of an image and size of layers:

    docker history --no-trunc=true jniltinho/docker-ssh |tr -s ' '|tail -n+2|awk -F " ago " '{print $2}'


# Build Docker

If you want to build these images by yourself, please follow below commands.

```
git clone https://github.com/jniltinho/docker-ssh.git
cd docker-ssh
docker build --no-cache -t jniltinho/docker-ssh .
```

---
## Author

Author: Nilton Oliveira

