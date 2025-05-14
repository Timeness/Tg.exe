# Telegram Bot

A Telegram bot built with Elixir and Telegex.

## Commands
- `!start`: Starts the bot.
- `!help`: Shows available commands.
- `!id`: Returns your ID and chat ID, or the replied user's ID if replying.
- `!kick {user_id}` or reply to a user: Kicks the specified user(s).

## Setup
1. Create a Telegram bot using BotFather and get the bot token.
2. Set the `BOT_TOKEN` environment variable.
3. Run `mix deps.get` to install dependencies.
4. Run `mix run --no-halt` to start the bot.

## Deployment on Railway
1. Push the code to a GitHub repository.
2. Create a new project on Railway.
3. Link the GitHub repository.
4. Set the `BOT_TOKEN` environment variable in Railway's variables section.
5. Deploy the application.

## License
MIT
