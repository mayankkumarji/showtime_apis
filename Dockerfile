FROM ruby:2.5.0

RUN adduser --home /home/showtime  --disabled-password --shell /bin/bash showtime
# set the app directory var
ENV APP_HOME /app
WORKDIR $APP_HOME

ENV BUNDLER_VERSION=2.2.16
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ENV=production
ENV RAILS_ROOT=/app

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install essentials
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    curl \
    libpq-dev \
    git \
    ca-certificates \
    nodejs \
    yarn=1.22.5-1 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Install ruby dependencies
COPY Gemfile Gemfile.lock $APP_HOME/

RUN gem install bundler -v 2.2.16

ENV BUNDLER_WITHOUT development test

RUN bundle install

COPY . $APP_HOME/

RUN chown -R showtime $APP_HOME $GEM_HOME

USER showtime

CMD puma -C config/puma.rb