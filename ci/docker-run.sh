#!/bin/sh -e
#
# build and run project docker container
#

CMDPATH=$(cd $(dirname $0) && pwd)
BASEDIR=${CMDPATH%/*}
PROJECT=update-tool

echo "==> create docker image"
cd $BASEDIR/ci
docker build \
  --build-arg UID=$(id -u) --build-arg GID=$(id -g) \
  --tag $PROJECT .

echo "==> run $PROJECT build container"
docker run --rm -it \
  -v $BASEDIR:/base -w /base $PROJECT $@
