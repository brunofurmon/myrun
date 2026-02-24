ARG RUBY_VERSION=3.4.8
FROM ruby:$RUBY_VERSION-slim

# System dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libyaml-dev \
      nodejs \
      git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# App code
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]