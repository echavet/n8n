#!/usr/bin/with-contenv bashio
# tail -f /dev/null
# exec /usr/bin/n8n start
npx n8n --host 0.0.0.0 --webhook-url=https://n8n.pool-io.com
