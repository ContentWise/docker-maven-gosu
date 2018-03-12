FROM maven:3.5.3-jdk-8-alpine

ARG GOSU_VERSION=1.10

RUN apk update && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl && \
    apk add --no-cache \
        make \
        openssh-client && \
    for server in ha.pool.sks-keyservers.net \
        hkp://p80.pool.sks-keyservers.net:80 \
        keyserver.ubuntu.com \
        hkp://keyserver.ubuntu.com:80 \
        pgp.mit.edu; \
    do \
        gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || echo "Trying new server..."; \
    done && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
	chmod +x /usr/local/bin/gosu && \
	apk del .gosu-deps

ENV LOCAL_USER_HOME=/home/user
RUN mkdir -p $LOCAL_USER_HOME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mvn"]

