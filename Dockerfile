FROM jenkinsci/slave:alpine

###########################
# Installing Packages
###########################


USER root
RUN apk add --no-cache \
ca-certificates \
curl \
curl-dev \
openssl \
mongodb=3.4.4-r0 \
nodejs=6.10.3-r1 \
python \
go && \
apk add maven --update-cache --repository http://dl-3.alpinelinux.org/alpine/v3.7/community/  --allow-untrusted

#RUN apk add --no-cache tar bash
#
#ARG MAVEN_VERSION=3.5.0
#ARG USER_HOME_DIR="/root"
#ARG SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
#ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
#
#RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
#  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#  && rm -f /tmp/apache-maven.tar.gz \
#  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


######################################################
# Installing Docker
######################################################

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 17.04.0-ce
ENV DOCKER_SHA256 c52cff62c4368a978b52e3d03819054d87bcd00d15514934ce2e0e09b99dd100

RUN set -x \
  && curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
&& tar -xzvf docker.tgz \
&& mv docker/* /usr/local/bin/ \
&& rmdir docker \
&& rm docker.tgz \
&& docker -v

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl


######################################################
# Installing GIT-LFS Support
######################################################
RUN apk --no-cache add openssl git curl \
    && curl -sLO https://github.com/github/git-lfs/releases/download/v2.3.4/git-lfs-linux-amd64-2.3.4.tar.gz \
    && tar zxvf git-lfs-linux-amd64-2.3.4.tar.gz \
    && mv git-lfs-2.3.4/git-lfs /usr/bin/ \
    && rm -rf git-lfs-2.3.4 \
    && rm -rf git-lfs-linux-amd64-2.3.4.tar.gz


COPY jenkins-slave /usr/local/bin/jenkins-slave

#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/jenkins-slave

#ENTRYPOINT docker-entrypoint.sh; jenkins-slave
ENTRYPOINT jenkins-slave
