FROM centos:8

ENV TZ America/Sao_Paulo
ENV ROOT_PASS=password

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum clean all; yum install -y epel-release; yum update -y \
    && yum install --nogpgcheck -y which telnet ncurses pwgen net-tools wget curl \
    && yum clean all && rm -rf /tmp/yum*

## https://github.com/ochinchina/supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

RUN yum install --nogpgcheck -y openssh-server openssh-clients sudo hostname \
    && yum clean all \
    && ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
    && sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz \
    && tar -xf upx-*.tar.xz; mv upx-*/upx /usr/local/bin/; rm -rf upx-3.* \
    && upx --best --lzma /usr/local/bin/supervisord

EXPOSE 9001 22

COPY container-files /
VOLUME ["/data"]
ENTRYPOINT ["/config/bootstrap.sh"]
