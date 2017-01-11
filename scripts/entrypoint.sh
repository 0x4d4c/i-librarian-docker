#!/bin/bash -eu

generate-config.sh

mkdir -p "${ILIBRARIAN_LIBRARY_PATH}/library"
chown -R ${APACHE_RUN_GROUP}:${APACHE_RUN_GROUP} ${ILIBRARIAN_LIBRARY_PATH}

rel_path=${ILIBRARIAN_RELATIVE_URL_ROOT:-/librarian}
sed -i "s;.*Alias.*\s\+\(.*\);Alias ${rel_path} \1;" /etc/i-librarian/apache.conf

ILIBRARIAN_UPLOAD_MAX_SIZE=${ILIBRARIAN_UPLOAD_MAX_SIZE:-50M}
sed -i "s/upload_max_filesize.*/upload_max_filesize = ${ILIBRARIAN_UPLOAD_MAX_SIZE}/" /etc/php/7.0/apache2/php.ini
sed -i "s/post_max_size.*/post_max_size = ${ILIBRARIAN_UPLOAD_MAX_SIZE}/" /etc/php/7.0/apache2/php.ini

if [ "$1" = "i-librarian" ]; then
	exec apache2 -DFOREGROUND
else
	exec $@
fi
