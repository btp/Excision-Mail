#!/bin/sh

if [ "$(id -u)" -ne 0 ] ; then
    echo "You need to bootstrap the system as root or do the steps manually"
    exit 1
fi

cat << EOF
We are going to first prepare the OpenBSD install to support Excision
The following files are going to be changed:

  /etc/installurl:
  The default package url is going to be changed to https://cdn.openbsd.org/pub/OpenBSD
  
  /etc/doas.conf:
  We will permit all member of :wheel to doas without password, change this afterwards

  The installation also adds the excision-passwd user who is allowed to run the
      excision change-passwd 
  command without needing a password. It is important that you keep this line in the 
  doas.conf even if you change other permissions.
EOF

echo "We will back them up"
[ -f /etc/doas.conf ] && cp -v /etc/doas.conf "/etc/doas.conf.bak.$(date +%F_%R)"
[ -f /etc/installurl ] && cp -v /etc/installurl "/etc/installurl.bak.$(date +%F_%R)"

echo "Now we change them to the standard configuration and add the needed ansible package"
echo 'permit nopass :wheel' > /etc/doas.conf
echo 'https://cdn.openbsd.org/pub/OpenBSD' > /etc/installurl

pkg_add ansible gnupg--%gnupg2
# this symlink is needed as unfortunately 
# a lot of programs are not up to date
ln -sfh /usr/local/bin/gpg2 /usr/local/bin/gpg
