FROM ruby:2.3.0
MAINTAINER dtaniwaki

RUN apt-get update -qq
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs git
RUN npm install -g phantomjs@2.1.1
RUN gem install bundler

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

COPY . /app/
