FROM ubuntu:18.04
MAINTAINER Isidoro <mercogliano.isidoro@gmail.com>

# Setup environment
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update &&  apt-get upgrade -y





# ----------   SSH Daemon Service   ----------
RUN apt-get update && apt-get install -y openssh-server vim
RUN mkdir /var/run/sshd
#RUN echo 'root:pass' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
COPY ./ssh-entrypoint.sh /
RUN chmod 700 /ssh-entrypoint.sh
#CMD ["/usr/sbin/sshd", "-D"]





# ----------   supervisor   ----------
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/
EXPOSE 9001




CMD ["supervisord", "-n"]
