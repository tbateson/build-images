FROM ubuntu:jammy AS deploy

# Add focal repo so that gcc/g++ 7 can be available
RUN echo 'deb http://archive.ubuntu.com/ubuntu focal main universe' >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y build-essential cmake unzip curl wget tar sqlite

# Use gcc/g++ 7
RUN apt-get install -y gcc-7 g++-7
RUN ln -sf /usr/bin/gcc-7 /usr/bin/gcc
RUN ln -sf /usr/bin/g++-7 /usr/bin/g++

# Compile Boost 1.80
WORKDIR /
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz
RUN tar -xzf boost_1_80_0.tar.gz
WORKDIR /boost_1_80_0
RUN ./bootstrap.sh
RUN ./b2 -j8 install
WORKDIR /
RUN rm -rf boost_1_80_0
