FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

COPY /scripts/entrypoint.sh /
COPY /scripts/supervisord.conf /

RUN echo "##### Installing Requierments #####" && \
    apt update && apt install --no-install-recommends -y curl tar perl libnet-ssleay-perl libauthen-pam-perl expect tzdata supervisor jq ca-certificates && \
    echo "##### Getting Latest Version of Webmin #####" && \
    export latestVer=$(curl -sL https://api.github.com/repos/webmin/webmin/releases/latest | jq -r ".tag_name") && \
    echo "##### Downloading Webmin #####" && \
    mkdir /opt/webmin && curl -sSL https://sourceforge.net/projects/webadmin/files/webmin/${latestVer}/webmin-${latestVer}.tar.gz/download | tar xz -C /opt/webmin --strip-components=1 && \
    echo "##### Creating some folders #####" && \
    mkdir -p /var/webmin/ && \
    mkdir -p /srv/ && \
    echo "##### Linking Webmin Logs to Docker" && \
    ln -s /dev/stdout /var/webmin/miniserv.log && \
    ln -s /dev/stderr /var/webmin/miniserv.error && \
    echo "##### Installing Webmin #####" && \
    /opt/webmin/setup.sh && \
    echo "##### Fixing Permissions for entrypoint.sh #####" && \
    chmod +x entrypoint.sh && \
    echo "##### Clean Up #####" && \
    apt autoremove --purge && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt

VOLUME /mnt /data

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord","-c","/supervisord.conf"]
