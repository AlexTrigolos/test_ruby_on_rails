FROM ruby:3.0.4
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn
RUN mkdir /test_app_rails
WORKDIR /test_app_rails
COPY Gemfile /test_app_rails/Gemfile
COPY Gemfile.lock /test_app_rails/Gemfile.lock
COPY package.json /test_app_rails/package.json
COPY yarn.lock /test_app_rails/yarn.lock
RUN gem install bundler -v '2.2.33'
RUN bundle install
RUN yarn install --check-files
COPY . /test_app_rails
EXPOSE 3000