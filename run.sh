#!/usr/bin/with-contenv bashio

WEBHOOK_URL=$(bashio::config 'webhook_url')
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export WEBHOOK_URL="$WEBHOOK_URL"
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export N8N_CONFIG_DIR=/data

# Lancer n8n
n8n start
#npx n8n start
