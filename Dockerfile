FROM ruby:2.7.2-alpine as builder

ENV LANG C.UTF-8

RUN apk update && apk upgrade && apk add --no-cache npm mysql-dev mysql-client libxml2 libxslt openssh-client && \
    npm config set unsafe-perm true && npm install -g yarn
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo Asia/Tokyo > /etc/timezone && \
    rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ARG RAILS_ENV
ARG DATABASE_HOST
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG DATABASE_PORT
ARG SECRET_KEY_BASE

ENV RAILS_ENV=${RAILS_ENV}
ENV DATABASE_HOST=${DATABASE_HOST}
ENV DATABASE_USERNAME=${DATABASE_USERNAME}
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}
ENV DATABASE_PORT=${DATABASE_PORT}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# install rails
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN apk add --no-cache --virtual .ruby-builddeps alpine-sdk linux-headers libxml2-dev libxslt-dev imagemagick-dev sqlite-dev \
 && bundle -j4 \
 && apk del .ruby-builddeps

FROM ruby:2.7.2-alpine

ENV LANG C.UTF-8

RUN apk update && apk upgrade && apk add --no-cache npm mysql-dev mysql-client libxml2 libxslt openssh-client && \
    npm config set unsafe-perm true && npm install -g yarn
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo Asia/Tokyo > /etc/timezone && \
    rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle

ARG RAILS_ENV
ARG DATABASE_HOST
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG DATABASE_PORT
ARG DATABASE_POOL
ARG SECRET_KEY_BASE
ARG JWT_KEY
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_S3_KEY_ID
ARG AWS_S3_SECRET_KEY
ARG AWS_S3_STORAGE_BUCKET
ARG SENTRY_DSN

ENV RAILS_ENV=${RAILS_ENV}
ENV DATABASE_HOST=${DATABASE_HOST}
ENV DATABASE_USERNAME=${DATABASE_USERNAME}
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}
ENV DATABASE_PORT=${DATABASE_PORT}
ENV DATABASE_POOL=${DATABASE_POOL}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV JWT_KEY=${JWT_KEY}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_S3_KEY_ID=${AWS_S3_KEY_ID}
ENV AWS_S3_SECRET_KEY=${AWS_S3_SECRET_KEY}
ENV AWS_S3_STORAGE_BUCKET=${AWS_S3_STORAGE_BUCKET}
ENV SENTRY_DSN=${SENTRY_DSN}

ADD . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000", "-e", "${RAILS_ENV}"]
