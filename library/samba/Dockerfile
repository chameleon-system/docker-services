FROM debian:jessie
MAINTAINER Maximilian Heinrich <maximilian.heinrich@esono.de>
# Image based on dperson/samba / David Personette <dperson@dperson.com>

# Creating www-data user with id 33
RUN useradd -u 33 -g 33 www-data

# Install samba
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends samba \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    useradd smbuser -M && \
    sed -i 's|^\(   log file = \).*|\1/dev/stdout|' /etc/samba/smb.conf && \
    sed -i 's|^\(   unix password sync = \).*|\1no|' /etc/samba/smb.conf && \
    sed -i '/Share Definitions/,$d' /etc/samba/smb.conf && \
    echo '   security = user' >>/etc/samba/smb.conf && \
    echo '   directory mask = 0775' >>/etc/samba/smb.conf && \
    echo '   force create mode = 0664' >>/etc/samba/smb.conf && \
    echo '   force directory mode = 0775' >>/etc/samba/smb.conf && \
    echo '   force user = www-data' >>/etc/samba/smb.conf && \
    echo '   force group = www-data' >>/etc/samba/smb.conf && \
    echo '   load printers = no' >>/etc/samba/smb.conf && \
    echo '   printing = bsd' >>/etc/samba/smb.conf && \
    echo '   printcap name = /dev/null' >>/etc/samba/smb.conf && \
    echo '   disable spoolss = yes' >>/etc/samba/smb.conf && \
    echo '' >>/etc/samba/smb.conf
COPY samba.sh /usr/bin/

VOLUME ["/etc/samba"]

EXPOSE 137 139 445

ENTRYPOINT ["samba.sh"]
