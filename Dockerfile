FROM ruby:2.3.0
MAINTAINER dtaniwaki

RUN apt-get update -qq
RUN apt-get install -y nodejs

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

RUN mkdir config
COPY config/settings.docker.yml config/settings.local.yml
