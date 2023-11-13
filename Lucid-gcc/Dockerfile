FROM ubuntu:lucid AS deploy

RUN sed -i -e 's/archive./old-releases./g' /etc/apt/sources.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y g++ && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
