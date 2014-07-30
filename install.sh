#!/bin/sh
#
# Go installation script
#
# This script will install Go and configure the current directory
# as a workspace
#
# Author : Yanick Rochon <yanick.rochon@gmail.com>
#
# @version 2014-07 - initial install for Go 1.3


# Which version of Go to install
VERSION="1.3"

# OS should be 'linux'
OS=`uname`

# Arch
if [ `uname -i` = "x86_64" ]
then
  ARCH="amd64"
else
  ARCH="386"
fi

ARCHIVE_NAME="go$VERSION.$OS-$ARCH.tar.gz"
INSTALL_PATH="/usr/local"
BIN_PATH="$INSTALL_PATH/go/bin"

GO_PATH=$PWD
GO_BIN="$GO_PATH/bin"
GO_PKG="$GO_PATH/pkg"
GO_SRC="$GO_PATH/src"


if ! [ -f $BIN_PATH/go ]
then

  echo "Downloading Go $VERSION..."
  wget -c --progress=bar:force http://golang.org/dl/$ARCHIVE_NAME

  echo "Installing..."
  sudo tar -C /usr/local -xzf $ARCHIVE_NAME

  # register binary path
  if ! grep -Fq "$BIN_PATH" /etc/profile
  then
    echo "Registering path..."
    echo "\nexport PATH=\$PATH:$BIN_PATH" | sudo tee --append /etc/profile > /dev/null
    source /etc/profile
  fi

  rm $ARCHIVE_NAME
fi

# create our project structure
mkdir -p $GO_BIN
mkdir -p $GO_PKG
mkdir -p $GO_SRC

# register local path
if ! grep -Fq "GOPATH=" $HOME/.profile
then
  echo "\nexport GOPATH=$GO_PATH\nexport PATH=\$PATH:$GO_BIN" >> $HOME/.profile
  source "$HOME/.profile"
fi

echo