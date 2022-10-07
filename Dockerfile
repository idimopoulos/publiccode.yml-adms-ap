FROM ubuntu:latest

RUN apt-get update --yes && apt-get upgrade --yes

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-18-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-18-openjdk-amd64/
RUN export JAVA_HOME

RUN apt-get install --yes make git curl wget jq golang-go
RUN cpan install URI
RUN go install github.com/italia/publiccode-parser-go/v3/pcvalidate@latest

ENV YQ_VERSION=v4.28.1
ENV YQ_BINARY=yq_linux_amd64
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz -O - |\
  tar xz && mv ${YQ_BINARY} /usr/bin/yq

COPY . /build
RUN cd /build && make dependencies
