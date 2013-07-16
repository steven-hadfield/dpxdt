#!/bin/bash

source common.sh

ARCHIVE_NAME=dpxdt_deployment
TEMP_DIR=/tmp/$ARCHIVE_NAME
OUTPUT_ARCHIVE=/tmp/$ARCHIVE_NAME.tar.gz
INSTALL_PATH=/usr/local/share

rm -Rf $TEMP_DIR
cp -R -L deployment/worker $TEMP_DIR
find $TEMP_DIR -name '*.pyc' -or -name '.*' | xargs rm
cp $PHANTOMJS_DEPLOY_BINARY $TEMP_DIR
tar zcf $OUTPUT_ARCHIVE -C /tmp $ARCHIVE_NAME

echo "scp $OUTPUT_ARCHIVE foo@bar:/tmp"
echo
echo "# Modify /etc/apt/sources.list and add 'contrib' and 'non-free' repos"
echo "# You'll need this for the MS fonts package. Then as root:"
echo "apt-get update"
echo
echo "# On the host machine as root:"
echo "apt-get install imagemagick less libfreetype6 libfontconfig runit tmpreaper ttf-mscorefonts-installer"
echo
echo "cp /tmp/$ARCHIVE_NAME.tar.gz $INSTALL_PATH"
echo "cd $INSTALL_PATH"
echo "tar zxf $ARCHIVE_NAME.tar.gz"
echo "cp -R $ARCHIVE_NAME/runit /etc/service/dpxdt_worker"
echo
echo "# Modify dpxdt_worker/flags.cfg with your API keys"
echo "# Modify /etc/tmpreader.conf to enable /tmp file cleanups"
echo "# Rebuild the font cache with:"
echo "fc-cache -fv"
echo
echo "sv start dpxdt_worker"
