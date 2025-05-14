defmodule TelegramBot.Bot do
  use Task
  require Logger

  def start_link(_), do: Task.start_link(__MODULE__, :poll, [])

  def poll do
    Logger.info("Bot started polling...")
    loop(0)
  end

  defp loop(offset) do
    case Nadia.get_updates(offset: offset, timeout: 30) do
      {:ok, updates} ->
        Enum.each(updates, &handle_update/1)
        new_offset =
          updates
          |> Enum.map(& &1.update_id)
          |> Enum.max(fn -> offset end)
          |> Kernel.+(1)

        loop(new_offset)

      {:error, reason} ->
        Logger.error("Polling error: #{inspect(reason)}")
        :timer.sleep(1000)
        loop(offset)
    end
  end

  defp handle_update(%{message: message}) do
    text = message.text || ""
    chat_id = message.chat.id

    if String.starts_with?(text, "!") do
      case String.split(text) do
        ["!start"] ->
          Nadia.send_message(chat_id, "Welcome to the Elixir Telegram Bot!")

        ["!help"] ->
          Nadia.send_message(chat_id, """
          Available commands:
          !start - Start bot
          !help - Show commands
          !id - Show user/chat ID
          !kick <user_id> - Kick user (or reply to kick)
          """)

        ["!id"] ->
          msg =
            if message.reply_to_message do
              reply_user = message.reply_to_message.from
              "Replied User ID: #{reply_user.id}\nYour ID: #{message.from.id}\nChat ID: #{chat_id}"
            else
              "Your ID: #{message.from.id}\nChat ID: #{chat_id}"
            end

          Nadia.send_message(chat_id, msg)

        ["!kick", user_id_str] ->
          with {:ok, user_id} <- Integer.parse(user_id_str),
               :ok <- try_kick(chat_id, user_id) do
            Nadia.send_message(chat_id, "User #{user_id} kicked.")
          else
            _ -> Nadia.send_message(chat_id, "Invalid user_id or unable to kick.")
          end

        ["!kick"] ->
          if message.reply_to_message do
            user_id = message.reply_to_message.from.id
            from_id = message.from.id

            try_kick(chat_id, user_id)
            try_kick(chat_id, from_id)

            Nadia.send_message(chat_id, "Kicked both the user and you!")
          else
            Nadia.send_message(chat_id, "Usage: !kick <user_id> or reply to a message.")
          end

        _ ->
          Nadia.send_message(chat_id, "Unknown command.")
      end
    end
  end

  defp handle_update(_), do: :ok

  defp try_kick(chat_id, user_id) do
    case Nadia.kick_chat_member(chat_id, user_id) do
      :ok -> :ok
      error -> Logger.error("Kick failed: #{inspect(error)}")
    end
  end
end
