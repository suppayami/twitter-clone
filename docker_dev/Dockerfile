FROM elixir:1.9-alpine

RUN mkdir /code
WORKDIR /code

RUN apk add --update git build-base openssl-dev bash postgresql-client

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.11 --force

