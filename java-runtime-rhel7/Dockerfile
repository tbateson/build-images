FROM registry.access.redhat.com/ubi7/ubi:7.9 as deploy
RUN yum install -y gcc java-1.8.0-openjdk apr python-devel postgresql-libs postgresql-devel

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN rm get-pip.py

RUN pip install psycopg2