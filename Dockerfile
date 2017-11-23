#
# Copyright 2017 Apereo Foundation (AF) Licensed under the
# Educational Community License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may
# obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

#
# Forked and adapted from https://github.com/blacktop/docker-elasticsearch-alpine/tree/master/1.7
#

#
# Step 1: Build the image
# $ docker build -f Dockerfile -t oae-elasticsearch:latest .
# Step 2: Run image
# $ docker run -it --name=elasticsearch --net=host oae-elasticsearch:latest
#

FROM alpine:3.4
LABEL Name=OAE-Elasticsearch
LABEL Author=ApereoFoundation 
LABEL Email=oae@apereo.org

ENV ELASTIC 1.7.5

RUN apk add --no-cache openjdk8-jre tini su-exec
RUN apk add --no-cache -t build-deps wget ca-certificates \
  && cd /tmp \
  && wget -O elasticsearch-$ELASTIC.tar.gz https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-$ELASTIC.tar.gz \
  && tar -xzf elasticsearch-$ELASTIC.tar.gz \
  && mv elasticsearch-$ELASTIC /usr/share/elasticsearch \
  && adduser -DH -s /sbin/nologin elasticsearch \
  && echo "Creating Elasticsearch Paths..." \
  && for path in \
  /usr/share/elasticsearch/data \
  /usr/share/elasticsearch/logs \
  /usr/share/elasticsearch/config \
  /usr/share/elasticsearch/config/scripts \
  /usr/share/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  done \
  && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch \
  && rm -rf /tmp/* \
  && apk del --purge build-deps

# COPY config/elastic /usr/share/elasticsearch/config
# COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
RUN apk add --update --no-cache bash && \
  chmod +x /elastic-entrypoint.sh
ENTRYPOINT ["/bin/bash", "/elastic-entrypoint.sh"]

ENV PATH /usr/share/elasticsearch/bin:$PATH
VOLUME ["/usr/share/elasticsearch/data"]
EXPOSE 9200 9300

CMD ["elasticsearch"]