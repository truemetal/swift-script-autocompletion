#!/bin/sh

SANDBOX_NAME=swift-script-autocompletion;

cd /tmp
rm -rf "$SANDBOX_NAME"
mkdir "$SANDBOX_NAME"
cd "$SANDBOX_NAME"
curl -LO https://github.com/truemetal/swift-script-autocompletion/archive/master.zip
tar -xf master.zip --strip-components=1
./install.sh
rm -rf "/tmp/$SANDBOX_NAME"