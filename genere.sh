mkdir -p rootfs/etc/s6-overlay/s6-rc.d/init-n8n/dependencies.d
touch rootfs/etc/s6-overlay/s6-rc.d/init-n8n/dependencies.d/base
echo "oneshot" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/type
echo "/etc/s6-overlay/s6-rc.d/init-n8n/run" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/up
echo "#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: n8n
# Initializes n8n configuration options
# ==============================================================================

declare webhook_url
declare encryption_key

chmod +x \"\$0\"

bashio::log.info \"Initializing n8n configuration...\"

webhook_url=\$(bashio::config 'webhook_url')
encryption_key=\$(bashio::config 'encryption_key')

bashio::log.info \"webhook_url: \${webhook_url}\"

echo \"N8N_HOST=0.0.0.0\" > /data/n8n_env
echo \"N8N_PORT=5678\" >> /data/n8n_env
echo \"N8N_WEBHOOK_URL=\${webhook_url}\" >> /data/n8n_env
echo \"N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true\" >> /data/n8n_env
echo \"N8N_RUNNERS_ENABLED=true\" >> /data/n8n_env

if bashio::config.has_value 'encryption_key'; then
  echo \"N8N_ENCRYPTION_KEY=\${encryption_key}\" >> /data/n8n_env
  bashio::log.info \"Clé de chiffrement ajoutée: \${encryption_key}\"
else
  bashio::log.info \"Aucune clé de chiffrement spécifiée, n8n la générera.\"
fi

exit 0" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/run
chmod +x rootfs/etc/s6-overlay/s6-rc.d/init-n8n/run
touch rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/init-n8n