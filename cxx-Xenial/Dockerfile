FROM ubuntu:xenial AS build

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y git g++ g++-aarch64-linux-gnu g++-arm-linux-gnueabihf g++-powerpc-linux-gnu g++-powerpc64le-linux-gnu make && \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y lib32stdc++-5-dev lib32gcc-5-dev libc6-dev-i386 libx32stdc++-5-dev libx32gcc-5-dev libc6-dev-x32 && \
	ln -s x86_64-linux-gnu /usr/include/i386-linux-gnu && \
	ln -s x86_64-linux-gnu /usr/include/x86_64-linux-gnux32 && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf autopoint bison curl gettext libtool pkg-config && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Build libuuid for all architectures
RUN curl -sL "https://github.com/karelzak/util-linux/archive/refs/tags/v2.36.1.tar.gz" | tar xz && cd util-linux-* && ./autogen.sh && mkdir builddir && cd builddir && \
	../configure --disable-all-programs --enable-libuuid && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /lib/x86_64-linux-gnu/ && rm -rf * && \
	CC="gcc -m32" ../configure --disable-all-programs --enable-libuuid --host i386-linux-gnu && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/lib32/ && rm -rf * && \
	CC="gcc -mx32" ../configure --disable-all-programs --enable-libuuid --host x86_64-linux-gnux32 && make -j && strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/libx32/ && rm -rf * && \
	CC=aarch64-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host aarch64-linux-gnu && make -j && aarch64-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/aarch64-linux-gnu/lib/ && rm -rf * && \
	CC=arm-linux-gnueabihf-gcc ../configure --disable-all-programs --enable-libuuid --host arm-linux-gnueabihf && make -j && arm-linux-gnueabihf-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/arm-linux-gnueabihf/lib/ && rm -rf * && \
	CC=powerpc-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host powerpc-linux-gnu && make -j && powerpc-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/powerpc-linux-gnu/lib/ && rm -rf * && \
	CC=powerpc64le-linux-gnu-gcc ../configure --disable-all-programs --enable-libuuid --host powerpc64le-linux-gnu && make -j && powerpc64le-linux-gnu-strip .libs/libuuid.so && mv .libs/libuuid.so* /usr/powerpc64le-linux-gnu/lib/ && \
	cd ../.. && rm -rf util-linux-*

# Cleanup
RUN strip /lib*32/*.so* /usr/lib*/*.so* /usr/x86_64-linux-gnu/*/lib/*.so* /usr/lib/gcc*/*/*/cc1* /usr/lib/gcc*/*/*/collect* /usr/lib/gcc*/*/*/lto* /usr/lib/gcc*/*/*/*.so* || echo Ignoring invalid files 1>&2
RUN rm -rf /usr/lib*/gconv

# Prepare deploy directory
RUN mkdir -p /deploy/lib/x86_64-linux-gnu /deploy/usr/lib/x86_64-linux-gnu && \
	find /lib /usr/lib '(' -name 'ld-*' -o -name 'libanl*' -o -name 'libBrokenLocale*' -o -name 'libc[.-]*' -o -name 'libcidn*' -o -name 'libcrypt[.-]*' -o -name 'libdl*' -o -name 'libfreebl*' -o -name 'libgcc_s*' -o -name 'libm[.-]*' -o -name 'libmvec*' -o -name 'libnsl*' -o -name 'libnss*' -o -name 'libpthread*' -o -name 'libresolv*' -o -name 'librt[.-]*' -o -name 'libstdc++*' -o -name 'libthread_db*' -o -name 'libutil*' -o -name 'libuuid*' -o -name 'libz*' -o -name '*.o' -o -name '*.a' -o \
		-name 'libbfd*' -o -name 'libcloog*' -o -name 'libgmp*' -o -name 'libgomp*' -o -name 'libisl*' -o -name 'libmemusage*' -o -name 'libmpc*' -o -name 'libmpfr*' -o -name 'libopcodes*' -o -name 'libpcprofile*' ')' -exec cp -al {} /deploy{} \; && \
	cp -al /lib64 /lib32 /libx32 /deploy/ && \
	cp -al /usr/lib/gcc /usr/lib/gcc-cross /usr/lib/gold-ld /deploy/usr/lib/

RUN mkdir -p /deploy/usr/bin && \
	find /usr/bin '(' -name '*-addr2line' -o -name '*-ar' -o -name '*-as' -o -name '*-c++filt' -o -name '*-cpp*' -o -name '*-elfedit' -o -name '*-g++*' -o -name '*-gcc*' -o -name '*-gcov*' -o -name '*-gprof' -o -name '*-ld' -o -name '*-ld.*' -o -name '*-nm' -o -name '*-objcopy' -o -name '*-objdump' -o -name '*-ranlib' -o -name '*-readelf' -o -name '*-size' -o -name '*-strings' -o -name '*-strip' -o \
		-name 'addr2line' -o -name 'ar' -o -name 'as' -o -name 'c++filt' -o -name 'cpp*' -o -name 'elfedit' -o -name 'g++*' -o -name 'gcc*' -o -name 'gcov*' -o -name 'gold' -o -name 'gprof' -o -name 'ld' -o -name 'ld.*' -o -name 'nm' -o -name 'objcopy' -o -name 'objdump' -o -name 'ranlib' -o -name 'readelf' -o -name 'size' -o -name 'strings' -o -name 'strip' ')' -exec cp -al {} /deploy{} \;

RUN cp -al /usr/include /usr/lib32 /usr/libx32 /usr/aarch64-linux-gnu /usr/arm-linux-gnueabihf /usr/powerpc64le-linux-gnu /usr/powerpc-linux-gnu /deploy/usr/

# Deploy
FROM scratch AS deploy

COPY --from=build /deploy/ /

# Test
RUN [ "/usr/bin/g++", "--version" ]
RUN [ "/usr/bin/aarch64-linux-gnu-g++", "--version" ]

ENTRYPOINT [ "/lib64/ld-linux-x86-64.so.2" ]
CMD [ "/usr/bin/g++", "--version" ]
