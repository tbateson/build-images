#!/bin/bash -e

PUSH=

for ARG; do
  shift

  case $ARG in
      (--push) PUSH=true ;;
         (--*) echo Ignoring unrecognized option: $ARG 1>&2 ;;
           (*) set -- "$@" "$ARG" ;;
  esac
done

if [ $# -gt 0 ]; then
  echo Expected arguments: [--push] 1>&2
  exit 1
fi

docker build cxx --tag 76eddge/build-images:cxx-Xenial --target deploy
docker build cxx-Trusty --tag 76eddge/build-images:cxx-Trusty --target deploy
# CentOS 6 is EOL, so this image will not change and doesn't need to be rebuilt
docker build cxx-CentOS6 --tag 76eddge/build-images:cxx-CentOS6 --target deploy

if [ ! -z "$PUSH" ]; then docker push -a 76eddge/build-images; fi
