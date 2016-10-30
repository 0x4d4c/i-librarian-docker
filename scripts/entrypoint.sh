#!/bin/bash -eu

generate-config.sh

mkdir -p "${ILIBRARIAN_LIBRARY_PATH}/library"
chown -R ${APACHE_RUN_GROUP}:${APACHE_RUN_GROUP} ${ILIBRARIAN_LIBRARY_PATH}

rel_path=${ILIBRARIAN_RELATIVE_URL_ROOT:-/librarian}
sed -i "s;.*Alias.*\s\+\(.*\);Alias ${rel_path} \1;" /etc/i-librarian/apache.conf

if [ "$1" = "i-librarian" ]; then
	exec apache2 -DFOREGROUND
else
	exec $@
fi
