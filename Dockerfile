FROM node:22-bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nodejs \
    node-typescript \
    jq \
    docker-compose \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install balena-cli
ARG BALENA_CLI_VERSION=21.1.9
RUN curl -sSL https://github.com/balena-io/balena-cli/releases/download/v$BALENA_CLI_VERSION/balena-cli-v$BALENA_CLI_VERSION-linux-x64-standalone.zip > balena-cli.zip && \
  unzip balena-cli.zip && \
  mv balena-cli/* /usr/local/bin && \
  rm -rf balena-cli.zip balena-cli

WORKDIR /usr/src/app

COPY ./src ./src
COPY ./tsconfig.json ./
COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm ci --no-fund --no-update-notifier && \
    tsc

COPY ./start.sh ./

CMD ["/bin/sh", "/usr/src/app/start.sh"]