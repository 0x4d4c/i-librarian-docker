FROM ubuntu:16.04
MAINTAINER Martin Lambertz <martin@0x4d4c.xyz>

ENV ILIBRARIAN_VERSION=4.6_all_xenial \
    ILIBRARIAN_LIBRARY_PATH=/data

VOLUME ${ILIBRARIAN_LIBRARY_PATH}
EXPOSE 80

RUN apt-get -qy update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qy install wget && \
    wget -q https://i-librarian.net/downloads/i-librarian_${ILIBRARIAN_VERSION}.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get -qy install \
        ./i-librarian_${ILIBRARIAN_VERSION}.deb \
        php-ldap && \
    rm -f i-librarian_${ILIBRARIAN_VERSION}.deb && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /dev/stdout /var/log/apache2/access.log && \
    ln -snf /dev/stderror /var/log/apache2/error.log && \
    ln -snf /dev/stdout /var/log/apache2/other_vhosts_access.log && \
    ln -snf /dev/stderror /var/log/apache2/other_vhosts_error.log

ENV APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data

COPY scripts/ /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["i-librarian"]
