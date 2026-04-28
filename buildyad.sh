#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libwebkit2gtk-4.1-dev libgtk-3-dev libglib2.0-dev libgtksourceview-3.0-dev libgspell-1-dev autotools-dev intltool pkg-config debhelper git

cd /
git clone https://github.com/v1cont/yad.git yad_build
cd yad_build

cat << ADD | cat - debian/changelog | tee debian/changelog
yad (14.2.0-0.1) stable; urgency=medium

  * remove intltool dependency (use pure gettext)
  * fix zooming in html dialog
  * fix extra arguments handling in html dialog
  * fix yad settings script
  * fix typo in man page
  * update translations
  * code cleanup

 -- Peter Gervai <grin@grin.hu>  Mon, 27 Apr 2026 13:52:02 +0200

ADD

sed -i 's/14.100/14.200/g' configure.ac

dpkg-buildpackage --no-sign

cp ../yad_14.2.0-0.1_amd64.deb /yad/
chown -R $UUID:$GGID /yad/

echo "Build done !!!"
