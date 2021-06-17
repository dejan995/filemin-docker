FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
ENV WEBMIN_VERSION 1.979

RUN apt update && apt install -y curl tar perl libnet-ssleay-perl libauthen-pam-perl expect tzdata supervisor && \
    mkdir /opt/webmin && curl -sSL https://sourceforge.net/projects/webadmin/files/webmin/${WEBMIN_VERSION}/webmin-${WEBMIN_VERSION}.tar.gz/download | tar xz -C /opt/webmin --strip-components=1 && \
    mkdir -p /var/webmin/ && \
    mkdir -p /srv/ && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error

COPY /scripts/entrypoint.sh /
COPY /scripts/supervisord.conf /

ENV nostart=true
ENV nouninstall=true
ENV noportcheck=true
ENV ssl=0
ENV login=admin
ENV password=admin
ENV atboot=false
ENV nochown=true

RUN  /opt/webmin/setup.sh && \
     chmod +x entrypoint.sh

VOLUME [ "/srv" ]

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
