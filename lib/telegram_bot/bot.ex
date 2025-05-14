defmodule TelegramBot.Bot do
  @moduledoc """
  Telegram bot initialization and polling setup.
  """

  use Telegex.Polling

  alias Telegex

  def start_polling do
    bot_token = Application.get_env(:telegram_bot, :bot_token)
    case Telegex.set_webhook(bot_token, "") do
      {:ok, _} ->
        Telegex.start_polling(bot_token)
        {:ok, :polling_started}
      {:error, error} ->
        {:error, error}
    end
  end

  def handle_update(update) do
    TelegramBot.CommandHandler.handle(update)
  end
end
