import Config

config :telegram_bot,
  bot_token: System.get_env("BOT_TOKEN") || raise "BOT_TOKEN is not set"
