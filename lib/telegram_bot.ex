defmodule TelegramBot do
  @moduledoc """
  Main module for the Telegram bot.
  """

  use Telegex.Polling

  def handle_update(update) do
    TelegramBot.CommandHandler.handle(update)
  end
end
