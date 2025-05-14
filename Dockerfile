FROM hexpm/elixir:1.14.5-erlang-25.3-alpine

RUN apk add --no-cache build-base git

WORKDIR /app

COPY . .

# Replace Hex/rebar install with GitHub-based install
RUN mix archive.install github hexpm/hex --branch latest --force && \
    mix archive.install github hexpm/rebar3 --branch main --force && \
    mix deps.get && \
    MIX_ENV=prod mix compile

CMD ["mix", "run", "--no-halt"]
