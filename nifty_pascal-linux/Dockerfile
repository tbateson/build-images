FROM alpine AS deploy

# Install build dependencies
RUN apk add --no-cache afl++ chromium clang clang-analyzer cmake curl doxygen file fontconfig gdb g++ git git-lfs linux-headers make msttcorefonts-installer nodejs patch perl py3-jinja2 py3-lxml py3-setuptools python3 samurai sed util-linux-dev xz && \
	ln -sf python3 /usr/bin/python

# Install npm, gradle, JDK from latest-stable for security fixes
RUN apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/latest-stable/community npm gradle openjdk17-jdk

# Install Powershell and its dependencies (see https://learn.microsoft.com/en-us/powershell/scripting/install/install-alpine)
RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl lttng-ust && \
	mkdir -p /opt/microsoft/powershell/7 && \
	curl -sL https://github.com/PowerShell/PowerShell/releases/download/v7.3.0/powershell-7.3.0-linux-alpine-x64.tar.gz | tar zx -C /opt/microsoft/powershell/7 && \
	chmod +x /opt/microsoft/powershell/7/pwsh && \
	ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Install erlang
RUN apk add --no-cache erlang

# Install cross compilers
RUN for Arch in aarch64-linux-musl arm-linux-musleabihf i686-linux-musl powerpc64le-linux-musl x86_64-linux-musl x86_64-linux-muslx32; do \
	mkdir -p "/opt/$Arch" && \
	curl -sL "https://github.com/76-eddge/musl-cross/releases/download/v0.9.16/$Arch.tar.xz" | tar xJ -C "/opt/$Arch"; \
	done; \
	find /opt/*/*/include/c++ -name c++config.h | xargs sed -i -re 's/^(\s*#\s*define\s+_GLIBCXX_HAVE_ATTRIBUTE_VISIBILITY).*/\1 0/'

# Perform tasks as basic user
RUN adduser --disabled-password jenkins
USER jenkins
WORKDIR /home/jenkins

# Install fonts for user
RUN mkdir -p ~/.fonts && curl -s -L http://plasmasturm.org/dl/vistafonts-installer | sed -e 's/{,b,i,z}/*/g' | sh && \
	curl -s -L https://github.com/mrbvrz/segoe-ui-linux/raw/master/install.sh | sed -e 's/\scontinueFont$/ fontinstall/' | sh

# Initialize npm
COPY --chown=jenkins package.json ./
RUN npm install && \
	npm audit

# Initialize gradle
COPY --chown=jenkins build.gradle ./gradle-init/build.gradle
RUN cd gradle-init && \
	gradle -i --no-daemon resolveDependencies --rerun-tasks --refresh-dependencies && \
	cd .. && \
	rm -rf gradle-init

# Initialize PowerShell
SHELL ["/usr/bin/pwsh", "-Command"]
RUN New-Item -ItemType File -Path $Profile -Force; \
	Add-Content $Profile '$env:PUPPETEER_EXECUTABLE_PATH = "/usr/bin/chromium-browser"'
