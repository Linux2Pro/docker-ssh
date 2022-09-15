#FROM centos:centos7
FROM centos:8

ENV ROOT_PASS=password

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* ; \
  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN rpm --rebuilddb && yum clean all; yum install -y epel-release; yum update -y; \
  yum install --nogpgcheck -y python3-pip which telnet ncurses pwgen && \
  yum clean all && rm -rf /tmp/yum*

COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

RUN yum install --nogpgcheck -y openssh-server openssh-clients \
  sudo hostname wget curl && yum clean all && \
  ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
  ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
  ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
  sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
  sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY container-files /

VOLUME ["/data"]
ENTRYPOINT ["/config/bootstrap.sh"]

EXPOSE 9111
EXPOSE 22
