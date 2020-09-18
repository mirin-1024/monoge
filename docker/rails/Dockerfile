FROM ruby:2.7.1-alpine3.12
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
        yarn && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install -j4

COPY . /app

RUN mkdir -p tmp/sockets
