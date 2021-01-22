FROM ruby:2.7.1-alpine3.12

ENV ROOT="/monoge"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${ROOT}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        linux-headers \
        make \
        nodejs \
        mysql-client \
        mysql-dev \
        tzdata \
        yarn \
        imagemagick && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev

COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle install -j4
RUN apk del build-packs

COPY . ${ROOT}

RUN mkdir -p tmp/sockets

EXPOSE 3000
