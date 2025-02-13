FROM debian:bookworm

EXPOSE 80

RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    docker-compose \
    curl \
    unzip

RUN npm install -g --no-fund --no-update-notifier \
    typescript

# Install balena-cli
ENV BALENA_CLI_VERSION 19.16.0
RUN curl -sSL https://github.com/balena-io/balena-cli/releases/download/v$BALENA_CLI_VERSION/balena-cli-v$BALENA_CLI_VERSION-linux-x64-standalone.zip > balena-cli.zip && \
  unzip balena-cli.zip && \
  mv balena-cli/* /usr/local/bin && \
  rm -rf balena-cli.zip balena-cli

WORKDIR /usr/src/app

COPY . .

RUN npm install --no-fund --no-update-notifier && \
    tsc

CMD ["/bin/sh", "/usr/src/app/start.sh"]