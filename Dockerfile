FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

COPY /scripts/entrypoint.sh /
COPY /scripts/supervisord.conf /

RUN apt update && apt install -y curl tar perl libnet-ssleay-perl libauthen-pam-perl expect tzdata supervisor jq && \
    export latestVer=$(curl -sL https://api.github.com/repos/webmin/webmin/releases/latest | jq -r ".tag_name") && \
    mkdir /opt/webmin && curl -sSL https://sourceforge.net/projects/webadmin/files/webmin/${latestVer}/webmin-${latestVer}.tar.gz/download | tar xz -C /opt/webmin --strip-components=1 && \
    mkdir -p /var/webmin/ && \
    mkdir -p /srv/ && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error && \
    /opt/webmin/setup.sh && \
    chmod +x entrypoint.sh && \
    apt autoremove --purge && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt

VOLUME /mnt /data

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
