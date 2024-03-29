# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM rethinkdb:2.3.6
MAINTAINER Stefaan Vermassen <stefaanvermassen@gmail.com>

COPY ./files/apt-transport-https_1.0.9.8.4_amd64.deb .
COPY ./files/libcurl3-gnutls_7.38.0-4+deb8u11_amd64.deb .
RUN dpkg -i libcurl3-gnutls_7.38.0-4+deb8u11_amd64.deb
RUN dpkg -i apt-transport-https_1.0.9.8.4_amd64.deb
RUN apt-get update && \
    apt-get install -yq curl && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

ADD http://stedolan.github.io/jq/download/linux64/jq /usr/bin/jq
RUN chmod +x /usr/bin/jq

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

COPY ./files/run.sh /
COPY ./rethinkdb-probe /rethinkdb-probe
RUN chmod 777 /run.sh
RUN chmod 777 /rethinkdb-probe
RUN ls /

ENTRYPOINT ["/usr/local/bin/dumb-init", "/run.sh"]
