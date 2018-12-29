FROM alpine:3.8
# IMAGE MAINTAINER
LABEL maintainer="Jeferson Pereira", \
      mail="pereira.jeferson@outlook.com", \
      version="1.1"

# ENV VARIABLES
ENV DB_USER="" \
    DB_PASSWORD="" \
    DB_NAME="" \
    DB_HOST="" \
    ELIXIR_VERSION="1.6.5" \
    LANG="C.UTF-8" \
    PATH=$PATH:/bin/elixir/bin

# ERLANG

RUN apk update && \
  apk --no-cache --virtual add erlang \
  erlang-runtime-tools \
  erlang-asn1 \
  erlang-crypto \
  erlang-dev \
  erlang-erl-interface \
  erlang-eunit \
  erlang-inets \
  erlang-parsetools \
  erlang-public-key \
  erlang-sasl \
  erlang-ssl \
  erlang-syntax-tools \
  erlang-tools && \
  rm -rf /var/cache/apk/*

# ELIXIR + PHOENIX + REAL_WORLD APP
COPY ./app /app
WORKDIR /app

RUN apk --no-cache --virtual add wget make gcc musl-dev postgresql-client \
 && wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip \
 && mkdir -p /bin/elixir/ \
 && unzip Precompiled.zip -d /bin/elixir/ \
 && export PATH="${PATH}:/bin/elixir/bin" \
 && chmod -R 755 /bin/elixir/ \
 && rm -rf Precompiled.zip \
 && apk del wget make gcc musl-dev \
 && yes | mix archive.install \
    https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez \
 && mix do local.hex --force, \
    local.rebar --force, \
    deps.get, \
    deps.compile \
 && rm -rf /var/cache/apk/* \
 && chmod +x "/app/entrypoint.sh"

# ENTRYPOINT
ENTRYPOINT ["/app/entrypoint.sh"]
