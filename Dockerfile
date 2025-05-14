FROM elixir:1.14
WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY mix.exs mix.lock ./

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

COPY . .

RUN mix compile
ENV MIX_ENV=prod
EXPOSE 4000

CMD ["mix", "run", "--no-halt"]
