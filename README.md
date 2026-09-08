# Fahad Telegram Options AI v6 — Railway deployment

Deployment repository for the SPY/SPX options PAPER Telegram bot.

This repository contains no Telegram token, chat ID, broker credential, private config, SQLite database, or model weights. Railway secrets must be configured as service variables.

Required Railway variables:
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_OWNER_CHAT_ID`

Attach a persistent volume at `/data`.

The first smoke test keeps `OPTIONS_MODELS_ENABLED=false`. After deployment, use Telegram commands `/optionsstatus`, `/optionson`, and `/optionpnl`.

This version is PAPER simulation only; it does not place real option orders.
