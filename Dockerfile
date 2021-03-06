FROM node:wheezy

ADD . /src

WORKDIR /src

### BEGIN BOOT-CLJ ###

ENV DEBIAN_FRONTEND noninteractive

# Oracle Java 8

RUN apt-get update \
    && apt-get install -y curl wget openssl ca-certificates \
    && cd /tmp \
    && wget -qO jdk8.tar.gz \
       --header "Cookie: oraclelicense=accept-securebackup-cookie" \
       http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz \
    && tar xzf jdk8.tar.gz -C /opt \
    && mv /opt/jdk* /opt/java \
    && rm /tmp/jdk8.tar.gz \
    && update-alternatives --install /usr/bin/java java /opt/java/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/java/bin/javac 100

ENV JAVA_HOME /opt/java

# Boot

RUN wget -O /usr/bin/boot https://github.com/boot-clj/boot/releases/download/2.0.0/boot.sh \
    && chmod +x /usr/bin/boot

ENV BOOT_VERSION 2.1.0
ENV BOOT_AS_ROOT yes
ENV BOOT_JVM_OPTIONS -Xmx2g

# download & install deps, cache REPL and web deps
RUN /usr/bin/boot web -s doesnt/exist repl -e '(System/exit 0)'
RUN rm -rf target

### END BOOT-CLJ ###

RUN npm install

EXPOSE 8601

ENTRYPOINT npm start
