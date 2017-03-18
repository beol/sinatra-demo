FROM ubuntu:16.04
MAINTAINER Leo Laksmana <beol@laksmana.com>

RUN apt-get update \
    && \
    apt-get -yq install curl \
    && \
    apt-get clean
  
RUN mkdir -p /usr/java
WORKDIR /usr/java
RUN curl -sS \
         --cookie 'oraclelicense=accept-securebackup-cookie' \
         -L \
         http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz \
    | tar xzf - \
    && \
    ln -s jdk1.8.0_121 latest \
    && \
    ln -s latest default \
    && \
    update-alternatives --install /usr/bin/java java /usr/java/default/jre/bin/java 1 \
    && \
    java -Xshare:dump
ENV JAVA_HOME /usr/java/default

WORKDIR /opt
RUN curl -sS -L https://s3.amazonaws.com/jruby.org/downloads/9.1.2.0/jruby-bin-9.1.2.0.tar.gz \
    | tar xzf - \
    && \
    update-alternatives --install /usr/bin/jruby jruby /opt/jruby-9.1.2.0/bin/jruby 1
ENV PATH /opt/jruby-9.1.2.0/bin:$PATH

RUN mkdir -p jruby-9.1.2.0/etc \
    && \
    { \
      echo "install: --no-document"; \
      echo "update: --no-document"; \
    } >> jruby-9.1.2.0/etc/gemrc

RUN gem install bundler
ENV BUNDLE_SILENCE_ROOT_WARNING=1
RUN mkdir -p /usr/src/app
COPY . /usr/src/app/

WORKDIR /usr/src/app
RUN bundle install --binstubs --deployment --local

ENV RACK_ENV production
EXPOSE 9292
VOLUME /usr/src/app/logs
CMD ["jruby", "-G", "-S", "bin/rackup"]
