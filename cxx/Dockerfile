FROM ubuntu:trusty

RUN locale-gen en_US en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
	DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:git-core/ppa && \
	DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:openjdk-r/ppa && \
	DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:deadsnakes/ppa && \
	DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y git g++ g++-aarch64-linux-gnu g++-arm-linux-gnueabihf g++-powerpc-linux-gnu g++-powerpc64le-linux-gnu make openjdk-11-jdk-headless perl python3.7 && \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y lib32stdc++-4.8-dev lib32gcc-4.8-dev libc6-dev-i386 libx32stdc++-4.8-dev libx32gcc-4.8-dev libc6-dev-x32 && \
	ln -s x86_64-linux-gnu /usr/include/i386-linux-gnu && \
	ln -s x86_64-linux-gnu /usr/include/x86_64-linux-gnux32 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Build libuuid for all architectures
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf autopoint bison curl gettext libtool pkg-config && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG UTIL_LINUX_GZ_URI=https://github.com/karelzak/util-linux/archive/refs/tags/v2.36.1.tar.gz
RUN curl -sL "$UTIL_LINUX_GZ_URI" | tar xz && cd util-linux-* && ./autogen.sh && mkdir builddir && cd builddir && \
	../configure --disable-all-programs --enable-libuuid && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /lib/x86_64-linux-gnu/ && rm -rf * && \
	CC="gcc -m32" ../configure --disable-all-programs --enable-libuuid --host i386-linux-gnu && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/lib32/ && rm -rf * && \
	CC="gcc -mx32" ../configure --disable-all-programs --enable-libuuid --host x86_64-linux-gnux32 && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/libx32/ && rm -rf * && \
	CC=aarch64-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host aarch64-linux-gnu && make -j && aarch64-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/aarch64-linux-gnu/lib/ && rm -rf * && \
	CC=arm-linux-gnueabihf-gcc ../configure --disable-all-programs --enable-libuuid --host arm-linux-gnueabihf && make -j && arm-linux-gnueabihf-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/arm-linux-gnueabihf/lib/ && rm -rf * && \
	CC=powerpc-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host powerpc-linux-gnu && make -j && powerpc-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/powerpc-linux-gnu/lib/ && rm -rf * && \
	CC=powerpc64le-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host powerpc64le-linux-gnu && make -j && powerpc64le-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/powerpc64le-linux-gnu/lib/ && \
	cd ../.. && rm -rf util-linux-*

# Install Build Tools
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y curl libssl-dev unzip && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y bison flex git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Fix Java Certs
RUN /usr/bin/printf '\xfe\xed\xfe\xed\x00\x00\x00\x02\x00\x00\x00\x00\xe2\x68\x6e\x45\xfb\x43\xdf\xa4\xd9\x92\xdd\x41\xce\xb6\xb2\x1c\x63\x30\xd7\x92' > /etc/ssl/certs/java/cacerts && \
	/var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN mkdir -p /root/tools
WORKDIR /root/tools

ARG QEMU_XZ_URI=https://download.qemu.org/qemu-4.1.1.tar.xz
RUN curl -sL "$QEMU_XZ_URI" | tar xJ && cd qemu-*/ && ./configure --python=/usr/bin/python3.7 && sed -i '/^\[GCC /d' config-host.mak && make -j8 install && cd .. && rm -rf qemu-*/

ARG ANT_GZ_URI=http://www.gtlib.gatech.edu/pub/apache/ant/binaries/apache-ant-1.10.9-bin.tar.gz
RUN curl -sL "$ANT_GZ_URI" | tar xz && ln -sf $(pwd)/apache-ant-*/bin/ant /usr/bin/

ARG CMAKE_GZ_URI=https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz
RUN curl -sL "$CMAKE_GZ_URI" | tar xz && cd cmake-*/ && ./bootstrap --parallel=8 -- -DCMAKE_BUILD_TYPE=RELEASE && make -j8 && make install && cd .. && rm -rf cmake-*/

ARG NINJA_GZ_URI=https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz
RUN curl -sL "$NINJA_GZ_URI" | tar xz && sed -i 's/ -fdiagnostics-color//' ninja-*/CMakeLists.txt && cmake -DCMAKE_BUILD_TYPE=Release -B ninja-build ninja-* && cmake --build ninja-build -j --target ninja && cp ninja-build/ninja /usr/bin/ && rm -rf ninja-*

ARG GRADLE_ZIP_URI=https://services.gradle.org/distributions/gradle-6.7.1-bin.zip
RUN curl -sL "$GRADLE_ZIP_URI" --output gradle.zip && unzip -q gradle.zip && rm -f gradle.zip && ln -sf $(pwd)/gradle-*/bin/gradle /usr/bin/

RUN echo '#!/bin/sh -e' > /usr/bin/gcc-x86 && echo 'gcc -m32 "$@"' >> /usr/bin/gcc-x86 && chmod +x /usr/bin/gcc-x86
RUN echo '#!/bin/sh -e' > /usr/bin/g++-x86 && echo 'g++ -std=c++11 -m32 "$@"' >> /usr/bin/g++-x86 && chmod +x /usr/bin/g++-x86

RUN echo '#!/bin/sh -e' > /usr/bin/gcc-x32 && echo 'gcc -mx32 "$@"' >> /usr/bin/gcc-x32 && chmod +x /usr/bin/gcc-x32
RUN echo '#!/bin/sh -e' > /usr/bin/g++-x32 && echo 'g++ -std=c++11 -mx32 "$@"' >> /usr/bin/g++-x32 && chmod +x /usr/bin/g++-x32

WORKDIR /root

# Initialize gradle
RUN mkdir -p ~/.gradle && echo 'org.gradle.cache.cleanup=false' >> ~/.gradle/gradle.properties && mkdir -p gradle-init && cd gradle-init && \
	gradle --no-daemon init --type java-application --dsl groovy --test-framework junit-jupiter --project-name gradle-init --package gradle.init && \
	sed -ri -e "s/id 'application'/id 'application'\n\tid 'jacoco'/" -e "s/(junit-jupiter)-\\S+:5[.][.0-9]+/\\1:5.+/" -e "s/dependencies [{]/dependencies {\n\ttestImplementation 'junit:junit:4.+'\n\ttestImplementation 'org.mockito:mockito-core:3.+'/" app/build.gradle && \
	gradle --no-daemon clean build jacocoTestReport && \
	cd .. && rm -rf gradle-init

# Run QEMU
# LD_LIBRARY_PATH=/usr/aarch64-linux-gnu/lib qemu-aarch64 /usr/aarch64-linux-gnu/lib/ld-linux-aarch64.so.1 ~/test.aarch64
