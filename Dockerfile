FROM ruby:2.3.7
LABEL maintainer="Luís Melo <lhsm@cin.ufpe.br>"

WORKDIR /usr/src/app
VOLUME /usr/src/app/dbf

RUN apt-get update && apt-get install nodejs -y
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

RUN ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa

RUN rake db:migrate
CMD rails s -b 0.0.0.0