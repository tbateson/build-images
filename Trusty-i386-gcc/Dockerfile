FROM i386/ubuntu:trusty AS deploy

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y g++ && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
