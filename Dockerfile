# our image is centos default image with systemd
FROM ubuntu:xenial

MAINTAINER "Fabien Antoine" <fabien.antoine@m4x.org>

# this is the version what we're building
ENV TABLEAU_VERSION="10-5-0" \
    LANG=fr_FR.UTF-8

COPY tableau-server-${TABLEAU_VERSION}_amd64.deb .
COPY vertica-client-9.0.0-1.x86_64.tar.gz .

# Install core bits and their deps:w
RUN apt-get upgrade -y && \
    apt-get install systemd ip &&\
    dpkg -i --force-all tableau-server-${TABLEAU_VERSION}_amd64.deb && \
    apt-get install -y -f

COPY config/* /opt/tableau/docker_build/

RUN mkdir -p /etc/systemd/system/ && \
    cd /opt/tableau/tableau_server/packages/scripts.${TABLEAU_VERSION}/ && \    
    cp /opt/tableau/docker_build/tableau_server_install.service /etc/systemd/system/ && \
    systemctl enable tableau_server_install

# Expose TSM and Gateway ports
EXPOSE 80 8850

CMD /sbin/init
