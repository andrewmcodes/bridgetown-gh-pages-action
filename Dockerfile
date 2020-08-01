ARG INPUT_RUBY_VERSION
FROM ruby:$INPUT_RUBY_VERSION-alpine

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update; \
  apt-get install -y --no-install-recommends build-base git nodejs yarn

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
