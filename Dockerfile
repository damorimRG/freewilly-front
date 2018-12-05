FROM ruby:2.3.7
LABEL maintainer="Luís Melo <lhsm@cin.ufpe.br>"

WORKDIR /usr/src/app
RUN apt-get update && apt-get install nodejs -y
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

CMD rails s -b 0.0.0.0