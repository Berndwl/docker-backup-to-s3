FROM ubuntu:18.04
MAINTAINER Bernd <admin@berndw.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

RUN apt-get update && apt-get install -y docker-ce

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD put.sh /put.sh
RUN chmod +x /put.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
