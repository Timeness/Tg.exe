defmodule TelegramBot do
  use Application

  def start(_type, _args) do
    children = [
      TelegramBot.Bot
    ]

    opts = [strategy: :one_for_one, name: TelegramBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
