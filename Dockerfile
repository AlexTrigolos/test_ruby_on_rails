FROM ruby:3.0.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /test_app_rails
RUN gem install bundler -v 2.2.33
WORKDIR /test_app_rails
ENV BUNDLER_VERSION 2.2.33
ADD Gemfile /test_app_rails/Gemfile
ADD Gemfile.lock /test_app_rails/Gemfile.lock
RUN bundle install
ADD . /test_app_rails