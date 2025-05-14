defmodule TelegramBot.Application do
  @moduledoc """
  Application module to start the Telegram bot.
  """

  use Application

  def start(_type, _args) do
    children = [
      {Task, fn -> TelegramBot.Bot.start_polling() end}
    ]

    opts = [strategy: :one_for_one, name: TelegramBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
