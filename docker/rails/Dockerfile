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
        yarn \
        imagemagick && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev

COPY ./docker/rails/docker-entrypoint.sh /usr/local/bin/
RUN chmod 744 /usr/local/bin/docker-entrypoint.sh

ENV READY_RAILS_DIR=/ready_rails
WORKDIR $READY_RAILS_DIR

COPY ./docker/rails/Gemfile .
COPY ./docker/rails/application.rb .
COPY ./docker/rails/database.yml .
COPY ./docker/rails/puma.rb .

WORKDIR /app
EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
