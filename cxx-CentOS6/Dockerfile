FROM centos:6 AS build

RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Use vault repos
COPY CentOS-Base.repo /etc/yum.repos.d/
RUN yum install -y centos-release-scl centos-release-scl-rh && \
	rm -rf /var/cache/yum
COPY *.repo /etc/yum.repos.d/

# Install Build Tools
RUN yum install -y gcc-c++ devtoolset-7-gcc-c++ glibc-devel libstdc++-devel libuuid-devel glibc-devel.i686 libgcc.i686 libstdc++-devel.i686 libuuid-devel.i686 && \
	rm -rf /var/cache/yum
# Note: to link with -m32 for devtoolset-7 we should also be installing devtoolset-7-libstdc++-devel.i686, but it doesn't exist.

# Cleanup
RUN strip /usr/bin/* /lib*/*.so* /usr/lib*/*.so* /usr/libexec/gcc/x86_64-redhat-linux/*/* /opt/rh/devtoolset-7/root/usr/bin/* /opt/rh/devtoolset-7/root/usr/lib*/*.so* /opt/rh/devtoolset-7/root/usr/libexec/gcc/x86_64-redhat-linux/*/* || echo Ignoring invalid files 1>&2

RUN mkdir -p /deploy/lib /deploy/lib64 /deploy/usr/lib64 /deploy/usr/lib /deploy/usr/libexec /deploy/opt/rh/devtoolset-7/root/usr/lib64 /deploy/opt/rh/devtoolset-7/root/usr/lib /deploy/opt/rh/devtoolset-7/root/usr/libexec /deploy/opt/rh/devtoolset-7/root/etc && \
	find /lib64 /usr/lib64 /usr/lib '(' -name 'ld-*' -o -name 'libanl*' -o -name 'libBrokenLocale*' -o -name 'libc[.-]*' -o -name 'libcidn*' -o -name 'libcrypt[.-]*' -o -name 'libdl*' -o -name 'libfreebl*' -o -name 'libgcc_s*' -o -name 'libm[.-]*' -o -name 'libnsl*' -o -name 'libnss*' -o -name 'libpthread*' -o -name 'libresolv*' -o -name 'librt[.-]*' -o -name 'libstdc++*' -o -name 'libthread_db*' -o -name 'libutil*' -o -name 'libuuid*' -o -name 'libz*' -o -name '*.o' -o -name '*.a' ')' -exec cp -al {} /deploy{} \; && \
	cp -al /usr/lib64/libbfd* /usr/lib64/libgmp.* /usr/lib64/libmemusage* /usr/lib64/libmpfr* /usr/lib64/libopcodes* /usr/lib64/libpcprofile* /deploy/usr/lib64/ && \
	cp -al /lib/ld* /lib/lib* /deploy/lib/ && \
	cp -al /usr/lib/gcc /deploy/usr/lib/ && \
	cp -al /usr/libexec/gcc /deploy/usr/libexec/ && \
	cp -al /usr/include /deploy/usr/ && \
	cp -al /opt/rh/devtoolset-7/root/usr/lib64/*.so /deploy/opt/rh/devtoolset-7/root/usr/lib64/ && \
	cp -al /opt/rh/devtoolset-7/root/usr/lib/gcc /deploy/opt/rh/devtoolset-7/root/usr/lib/ && \
	cp -al /opt/rh/devtoolset-7/root/usr/libexec/gcc /deploy/opt/rh/devtoolset-7/root/usr/libexec/ && \
	cp -al /opt/rh/devtoolset-7/root/etc/alternatives /deploy/opt/rh/devtoolset-7/root/etc/ && \
	cp -al /opt/rh/devtoolset-7/root/usr/include /deploy/opt/rh/devtoolset-7/root/usr/

RUN mkdir -p /deploy/usr/bin /deploy/opt/rh/devtoolset-7/root/usr/bin && \
	find /usr/bin /opt/rh/devtoolset-7/root/usr/bin '(' -name 'addr2line' -o -name 'ar' -o -name 'as' -o -name 'c++filt' -o -name 'cpp*' -o -name 'elfedit' -o -name 'g++*' -o -name 'gcc*' -o -name 'gcov*' -o -name 'gprof' -o -name 'ld' -o -name 'ld.*' -o -name 'nm' -o -name 'objcopy' -o -name 'objdump' -o -name 'ranlib' -o -name 'readelf' -o -name 'size' -o -name 'strings' -o -name 'strip' ')' -exec cp -al {} /deploy{} \;

# Deploy
FROM scratch AS deploy

COPY --from=build /deploy/ /

# Test
RUN [ "/usr/bin/g++", "--version" ]
RUN [ "/opt/rh/devtoolset-7/root/usr/bin/g++", "--version" ]

ENTRYPOINT [ "/lib64/ld-linux-x86-64.so.2" ]
CMD [ "/usr/bin/g++", "--version" ]
