#!/usr/bin/with-contenv bashio
# tail -f /dev/null
# exec /usr/bin/n8n start

export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export WEBHOOK_URL=https://n8n.pool-io.com
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export N8N_CONFIG_DIR=/data

npx n8n start
