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
RUN strip /lib*/*.so* /usr/lib*/*.so* /usr/libexec/gcc/x86_64-redhat-linux/*/* /opt/rh/devtoolset-7/root/usr/libexec/gcc/x86_64-redhat-linux/*/* /usr/bin/* /opt/rh/devtoolset-7/root/usr/bin/* || echo Ignoring invalid formats 1>&2
RUN rm -rf /opt/rh/devtoolset-7/root/usr/bin/[ix]* /opt/rh/devtoolset-7/root/usr/bin/c++ /opt/rh/devtoolset-7/root/usr/bin/c[!+]*

RUN mkdir -p /deploy/lib64 && cp -a /lib64/ld* /lib64/libanl* /lib64/libBrokenLocale* /lib64/libc[.-]* /lib64/libcidn* /lib64/libcrypt* /lib64/libdl* /lib64/libfreebl* /lib64/libgcc_s* /lib64/libm[.-]* /lib64/libnsl* /lib64/libnss* /lib64/libpthread* /lib64/libresolv* /lib64/librt* /lib64/libthread_db* /lib64/libutil* /lib64/libuuid* /lib64/libz* /deploy/lib64/
RUN mkdir -p /deploy/usr/lib64 && cp -a /usr/lib64/libbfd* /usr/lib64/libc[.-]* /usr/lib64/libgmp.* /usr/lib64/libmemusage* /usr/lib64/libmpfr* /usr/lib64/libopcodes* /usr/lib64/libpcprofile* /usr/lib64/libstdc++* /usr/lib64/libuuid* /usr/lib64/*.a /usr/lib64/*.o /deploy/usr/lib64/
RUN find /usr/lib64 -lname '../../lib64/*' -exec cp -a {} /deploy/usr/lib64/ \;
RUN mkdir -p /deploy/usr/lib && cp -a /usr/lib/lib* /usr/lib/*.a /usr/lib/*.o /usr/lib/gcc /deploy/usr/lib/


FROM scratch AS deploy

COPY --from=build /deploy/lib64/ /lib64/
COPY --from=build /lib/ld* /lib/lib* /lib/

COPY --from=build /usr/bin/addr2line /usr/bin/ar /usr/bin/as /usr/bin/c++filt /usr/bin/g++ /usr/bin/gcc* /usr/bin/gcov* /usr/bin/ld* /usr/bin/nm /usr/bin/obj* /usr/bin/ranlib /usr/bin/readelf /usr/bin/size /usr/bin/strings /usr/bin/strip /usr/bin/
COPY --from=build /deploy/usr/lib64/ /usr/lib64/
COPY --from=build /deploy/usr/lib/ /usr/lib/
COPY --from=build /usr/libexec/gcc/ /usr/libexec/gcc/
COPY --from=build /usr/include/ /usr/include/

COPY --from=build /opt/rh/devtoolset-7/root/usr/bin/ /opt/rh/devtoolset-7/root/usr/bin/
COPY --from=build /opt/rh/devtoolset-7/root/usr/lib64/*.so /opt/rh/devtoolset-7/root/usr/lib64/
COPY --from=build /opt/rh/devtoolset-7/root/usr/lib/gcc/ /opt/rh/devtoolset-7/root/usr/lib/gcc/
COPY --from=build /opt/rh/devtoolset-7/root/usr/libexec/gcc/ /opt/rh/devtoolset-7/root/usr/libexec/gcc/
COPY --from=build /opt/rh/devtoolset-7/root/etc/alternatives/ /opt/rh/devtoolset-7/root/etc/alternatives/
COPY --from=build /opt/rh/devtoolset-7/root/usr/include/ /opt/rh/devtoolset-7/root/usr/include/

# Test
RUN [ "/usr/bin/g++", "--version" ]
RUN [ "/opt/rh/devtoolset-7/root/usr/bin/g++", "--version" ]

ENTRYPOINT [ "/lib64/ld-linux-x86-64.so.2" ]
CMD [ "/usr/bin/g++", "--version" ]
