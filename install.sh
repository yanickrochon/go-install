#!/bin/bash
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
OS=`uname | tr '[:upper:]' '[:lower:]'`

# Arch
if [ `uname -i` = "x86_64" ]
then
  ARCH="amd64"
else
  ARCH="386"
fi

GO_REPO="http://golang.org/dl/"

ARCHIVE_NAME="go$VERSION.$OS-$ARCH.tar.gz"
INSTALL_PATH="/usr/local"
BIN_PATH="$INSTALL_PATH/go/bin"

GO_PATH=$PWD
GO_BIN="$GO_PATH/bin"
GO_PKG="$GO_PATH/pkg"
GO_SRC="$GO_PATH/src"

## taken from http://stackoverflow.com/questions/4686464/howto-show-wget-progress-bar-only/4687912?noredirect=1#comment38937490_4687912
## ... bottom line is that read cause an error "Illegal option -d"
progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read  -d  '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

if ! [ -f $BIN_PATH/go ]
then

  echo "Downloading Go $VERSION..."
  wget -c --progress=bar:force $GO_REPO$ARCHIVE_NAME 2>&1 | progressfilt
  #wget -c --progress=bar:force $GO_REPO$ARCHIVE_NAME

  echo "Installing..."
  sudo tar -C /usr/local -xzf $ARCHIVE_NAME

  rm $ARCHIVE_NAME
fi

# register binary path
if ! grep -Fq "$BIN_PATH" /etc/profile
then
  printf "\n" \
         "if [ -d \"$BIN_PATH\" ]; then\n" \
         "    PATH=\"\$PATH:$BIN_PATH\"\n" \
         "fi" \
         | sudo tee --append /etc/profile > /dev/null
fi

# create our project structure
mkdir -p $GO_BIN
mkdir -p $GO_PKG
mkdir -p $GO_SRC

# register local path
if ! grep -Fq "GOPATH=" $HOME/.profile
then
  printf "\n" \
         "if [ -n \"$GO_PATH\" ]; then\n" \
         "    export GOPATH=\"$GO_PATH\"\n" \
         "fi\n" \
         "if [[ $PATH != *$GO_BIN* ]; then\n" \
         "    export PATH=\"\$PATH:$GO_BIN\"\n" \
         "fi" >> $HOME/.profile
fi

source /etc/profile
source $HOME/.profile

echo