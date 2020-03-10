#!/bin/sh

domain=$1
key_file="/etc/mail/dkim/ansimail.$domain.key"
pub_file="/etc/mail/dkim/ansimail.$domain.pub"

mkdir -p /etc/mail/dkim

if [ ! -e $key_file ]; then 
	openssl genrsa -out "/etc/mail/dkim/ansimail.$domain.key" 2048
fi

openssl rsa -in $key_file -pubout -out $pub_file

chown root:_rspamd $key_file
chmod 640 $key_file

chown root:wheel $pub_file
chmod 644 $pub_file

