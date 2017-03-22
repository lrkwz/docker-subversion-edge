FROM openjdk:jre-alpine

MAINTAINER Mario Mohr <mohr.mario@gmail.com>

RUN apk update && \
  apk add net-tools py-setuptools inotify-tools

ENV FILE https://downloads-guests.open.collab.net/files/documents/61/17071/CollabNetSubversionEdge-5.2.0_linux-x86_64.tar.gz

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl

RUN wget -q ${FILE} -O /tmp/csvn.tgz && \
    mkdir -p /opt/csvn && \
    tar -xzf /tmp/csvn.tgz -C /opt && \
    rm -rf /tmp/csvn.tgz

ENV RUN_AS_USER collabnet

RUN adduser -S collabnet && \
    chown -R collabnet /opt/csvn && \
    cd /opt/csvn && \
    ./bin/csvn install && \
    mkdir -p ./data-initial && \
    cp -r ./data/* ./data-initial

EXPOSE 3343 4434 18080

ADD files /

VOLUME /opt/csvn/data

WORKDIR /opt/csvn

ENTRYPOINT ["/config/bootstrap.sh"]
