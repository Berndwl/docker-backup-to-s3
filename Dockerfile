FROM ubuntu:18.04
MAINTAINER Bernd <admin@berndw.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD put.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
