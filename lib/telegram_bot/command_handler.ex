defmodule TelegramBot.CommandHandler do
  @moduledoc """
  Handles Telegram bot commands.
  """

  alias Telegex.Type.{Message, User}
  alias Telegex

  def handle(%{message: %Message{text: "!start" <> _} = message} = _update) do
    Telegex.send_message(message.chat.id, "Welcome to the bot! Use !help to see available commands.")
  end

  def handle(%{message: %Message{text: "!help" <> _} = message} = _update) do
    help_text = """
    Available commands:
    !start - Start the bot
    !help - Show this help message
    !id - Get your ID and chat ID (or replied user's ID if replying)
    !kick {user_id} or reply to a user - Kick a user (or both if user_id and reply are provided)
    """
    Telegex.send_message(message.chat.id, help_text)
  end

  def handle(%{message: %Message{text: "!id" <> _, from: from, chat: chat, reply_to_message: nil} = message} = _update) do
    text = "Your ID: #{from.id}\nChat ID: #{chat.id}"
    Telegex.send_message(message.chat.id, text)
  end

  def handle(%{message: %Message{text: "!id" <> _, reply_to_message: %{from: replied_user}} = message} = _update) do
    text = "Replied User ID: #{replied_user.id}"
    Telegex.send_message(message.chat.id, text)
  end

  def handle(%{message: %Message{text: "!kick" <> args, from: from, chat: chat, reply_to_message: nil} = message} = _update) do
    case String.trim(args) |> Integer.parse() do
      {user_id, _} ->
        kick_user(chat.id, user_id, from.id, message.chat.id)
      :error ->
        Telegex.send_message(message.chat.id, "Please provide a valid user ID or reply to a user.")
    end
  end

  def handle(%{message: %Message{text: "!kick" <> args, from: from, chat: chat, reply_to_message: %{from: replied_user}} = message} = _update) do
    # Kick replied user
    kick_user(chat.id, replied_user.id, from.id, message.chat.id)

    # If user_id is provided in args, kick that user too
    case String.trim(args) |> Integer.parse() do
      {user_id, _} ->
        kick_user(chat.id, user_id, from.id, message.chat.id)
      :error ->
        :ok
    end
  end

  def handle(_update), do: :ok

  defp kick_user(chat_id, user_id, from_id, message_chat_id) do
    # Check if the user is an admin
    case Telegex.get_chat_member(chat_id, from_id) do
      {:ok, %{status: status}} when status in ["administrator", "creator"] ->
        case Telegex.kick_chat_member(chat_id, user_id) do
          {:ok, _} ->
            Telegex.send_message(message_chat_id, "User #{user_id} has been kicked.")
          {:error, error} ->
            Telegex.send_message(message_chat_id, "Failed to kick user: #{inspect(error)}")
        end
      {:ok, _} ->
        Telegex.send_message(message_chat_id, "You need to be an admin to kick users.")
      {:error, error} ->
        Telegex.send_message(message_chat_id, "Error checking admin status: #{inspect(error)}")
    end
  end
end
