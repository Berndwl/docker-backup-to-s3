FROM mongo:4.2
MAINTAINER Bernd <admin@berndw.com>

#Install Python, pip and cron
RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

#Install S3CMD
RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD put.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
