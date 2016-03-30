FROM ruby:2.3.0
MAINTAINER dtaniwaki

RUN apt-get update -qq
RUN apt-get install -y nodejs git
RUN gem install bundler

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

COPY . /app/
