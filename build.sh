#!/bin/sh

# docker buildx build . --file Dockerfile --tag horseshoe/horseshoe --tag horseshoe/horseshoe:${GITHUB_REF/refs\/tags\//} --platform linux/amd64,linux/arm/v7,linux/arm64 --build-arg DEPLOY=local-jar --build-arg JAR_FILE=build/libs/horseshoe-*.jar --target deploy --push
docker buildx build cxx --tag 76eddge/build-images/cxx "$@"
