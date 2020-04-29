FROM mercisi/ubuntu18-supervisord:sshd
MAINTAINER Isidoro <mercogliano.isidoro@gmail.com>

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update &&  apt-get upgrade -y

# ----------   deps   ----------

RUN apt-get --no-install-recommends -y install \
    build-essential pkg-config \
    libicu-dev libcurl4-openssl-dev \
    git curl jq \
    gnupg libnspr4 libnspr4-dev libffi-dev \
    erlang


#version 22
# RUN cd /tmp && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
# dpkg -i erlang-solutions_1.0_all.deb
# RUN apt-get update && apt-get install -y erlang


# Installs the latest 21.x version available in the repository.
# RUN curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add -
# RUN echo "deb http://dl.bintray.com/rabbitmq-erlang/debian stretch erlang-20.x" | tee /etc/apt/sources.list.d/erlang.list
# RUN apt-get update && apt-get install -y erlang


#wget http://launchpadlibrarian.net/309343863/libmozjs185-1.0_1.8.5-1.0.0+dfsg-7_amd64.deb
#wget http://launchpadlibrarian.net/309343864/libmozjs185-dev_1.8.5-1.0.0+dfsg-7_amd64.deb
COPY libmozjs185-1.0_1.8.5-1.0.0+dfsg-7_amd64.deb /tmp/
COPY libmozjs185-dev_1.8.5-1.0.0+dfsg-7_amd64.deb /tmp/
RUN dpkg -i /tmp/libmozjs185-1.0_1.8.5-1.0.0+dfsg-7_amd64.deb && \
dpkg -i /tmp/libmozjs185-dev_1.8.5-1.0.0+dfsg-7_amd64.deb


# ----------   COUCHDB   ----------

LABEL couchdb_version=2.3.1
# CouchDB source code:
# curl -fSL https://www-eu.apache.org/dist/couchdb/source/2.3.1/apache-couchdb-2.3.1.tar.gz  -o couchdb.tar.gz
COPY couchdb.tar.gz /usr/src/

# compile couchdb
RUN mkdir -p /usr/src/couchdb \
     && tar -xzf /usr/src/couchdb.tar.gz -C /usr/src/couchdb --strip-components=1 \
     && cd /usr/src/couchdb && ./configure \
     touch /usr/lib/erlang/man/man1/gcov-tool-5.1.gz \
     touch /usr/lib/erlang/man/man1/gcov-tool-5.1.gz /usr/lib/erlang/man/man1/gconftool.1.gz \
touch /usr/lib/erlang/man/man1/gcov-tool-5.1.gz /usr/lib/erlang/man/man1/gcov-tool.1.gz \
touch /usr/lib/erlang/man/man1/gcov-tool-5.1.gz /usr/lib/erlang/man/man1/x86_64-linux-gnu-gcov-tool.1.gz \
     && make release

# create user couchdb and copy all files in home
 RUN adduser --system  --shell /bin/bash --group --gecos "CouchDB Administrator" couchdb \
     && adduser couchdb sudo \
     && echo 'couchdb:pass' | chpasswd \
     && cp -r /usr/src/couchdb/rel/couchdb /home/couchdb
 COPY local.ini /home/couchdb/couchdb/etc
 COPY vm.args /home/couchdb/couchdb/etc

# remove sourses
RUN rm -r /usr/src/couchdb



# this will let to use host directory to store data
RUN mkdir /data
RUN chown -R couchdb:couchdb /data


# create and fix permission for couchdb files
 RUN chown -R couchdb:couchdb /home/couchdb \
     && chown -R couchdb:couchdb /data \
     && find /home/couchdb/couchdb -type d -exec chmod 0770 {} \; \
     && chmod 0644 /home/couchdb/couchdb/etc/*

VOLUME ["/data"]

EXPOSE 5984 4369 9100


#special permission to open socker
RUN addgroup --gid 3003 aid_inet && adduser couchdb aid_inet 



# ----------   supervisord   ----------
COPY supervisord.conf /etc/

COPY ./docker-entrypoint.sh /
COPY ./install.sh /
RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /install.sh
CMD  ["/docker-entrypoint.sh"]



# ----------   NODEJS   ----------
#RUN apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
