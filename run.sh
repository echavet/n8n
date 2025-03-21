#!/usr/bin/with-contenv bashio
# tail -f /dev/null
# exec /usr/bin/n8n start
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
npx n8n start --host=0.0.0.0 --webhook-url=https://n8n.pool-io.com -c /data
