#!/bin/bash
mkdir -p rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/dependencies.d
touch rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/dependencies.d/base
echo "oneshot" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/type
echo "/etc/s6-overlay/s6-rc.d/init-n8n-key/run" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/up
echo "#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: n8n
# Initializes n8n encryption key if not specified
# ==============================================================================

declare webhook_url
declare encryption_key
declare generated_key

bashio::log.info \"Initializing n8n encryption key...\"

webhook_url=\$(bashio::config 'webhook_url')
encryption_key=\$(bashio::config 'encryption_key')

bashio::log.info \"webhook_url: \${webhook_url}\"

if bashio::config.has_value 'encryption_key'; then
  bashio::log.info \"Clé de chiffrement valide trouvée dans les options: \${encryption_key}\"
else
  bashio::log.info \"Aucune clé de chiffrement valide spécifiée, génération en cours...\"
  n8n start &
  declare -i n8n_pid=\$!
  declare -i timeout=60
  declare -i count=0
  while [ ! -f /root/.n8n/config ] && [ \"\${count}\" -lt \"\${timeout}\" ]; do
    sleep 1
    count=\$((count + 1))
    bashio::log.debug \"Attente de /root/.n8n/config... (\${count}/\${timeout} secondes)\"
  done
  if [ -f /root/.n8n/config ]; then
    generated_key=\$(jq -r '.encryptionKey // empty' /root/.n8n/config)
    if bashio::var.has_value \"\${generated_key}\"; then
      bashio::config 'encryption_key' \"\${generated_key}\"
      bashio::log.info \"Clé générée et exportée dans la config de l'addon: \${generated_key}\"
    else
      bashio::log.warning \"Fichier /root/.n8n/config trouvé, mais aucune clé présente.\"
    fi
  else
    bashio::log.warning \"Timeout atteint (\${timeout} secondes) ou échec: /root/.n8n/config non créé.\"
  fi
  kill \"\${n8n_pid}\"
  wait \"\${n8n_pid}\" 2>/dev/null || true
fi" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/run
chmod +x rootfs/etc/s6-overlay/s6-rc.d/init-n8n-key/run

mkdir -p rootfs/etc/s6-overlay/s6-rc.d/n8n/dependencies.d
touch rootfs/etc/s6-overlay/s6-rc.d/n8n/dependencies.d/init-n8n-key
echo "longrun" > rootfs/etc/s6-overlay/s6-rc.d/n8n/type
echo "/etc/s6-overlay/s6-rc.d/n8n/run" > rootfs/etc/s6-overlay/s6-rc.d/n8n/up
echo "#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: n8n
# Runs the n8n service
# ==============================================================================

declare webhook_url
declare encryption_key

bashio::log.info \"Starting n8n service...\"

webhook_url=\$(bashio::config 'webhook_url')
encryption_key=\$(bashio::config 'encryption_key')

bashio::log.info \"webhook_url: \${webhook_url}\"

export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_WEBHOOK_URL=\"\${webhook_url}\"
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export N8N_RUNNERS_ENABLED=true

if bashio::config.has_value 'encryption_key'; then
  export N8N_ENCRYPTION_KEY=\"\${encryption_key}\"
  bashio::log.info \"Utilisation de la clé de chiffrement: \${encryption_key}\"
else
  bashio::log.error \"Aucune clé de chiffrement disponible après initialisation!\"
  bashio::exit.nok \"n8n nécessite une clé de chiffrement pour démarrer.\"
fi

exec n8n start" > rootfs/etc/s6-overlay/s6-rc.d/n8n/run
chmod +x rootfs/etc/s6-overlay/s6-rc.d/n8n/run

mkdir -p rootfs/etc/s6-overlay/s6-rc.d/user/contents.d
touch rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/init-n8n-key
touch rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/n8n