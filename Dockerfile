FROM alpine:latest

ENV WEBMIN_VERSION 1.981
ENV nostart=true
ENV nouninstall=true
ENV noportcheck=true
ENV ssl=0
ENV login=admin
ENV password=admin
ENV atboot=false
ENV nochown=true

COPY /scripts/entrypoint.sh /
COPY /scripts/supervisord.conf /

RUN apk add --no-cache bash perl-net-ssleay curl tar perl expect tzdata supervisor && \
    mkdir /opt/webmin && curl -sSL https://sourceforge.net/projects/webadmin/files/webmin/${WEBMIN_VERSION}/webmin-${WEBMIN_VERSION}.tar.gz/download | tar xz -C /opt/webmin --strip-components=1 && \
    mkdir -p /var/webmin/ && \
    mkdir -p /srv/ && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error && \
    /opt/webmin/setup.sh && \
    chmod +x entrypoint.sh && \
    rm -rf /var/cache/apk/*

VOLUME /mnt /data

EXPOSE 10000

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
