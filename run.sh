#!/usr/bin/with-contenv bashio
set -e                                                  # exit on error

bashio::log.info "N8N addon starting..."

WEBHOOK_URL=$(bashio::config 'webhook_url')
ENCRYPTION_KEY=$(bashio::config 'encryption_key')

bashio::log.info "webhook_url  : $WEBHOOK_URL"

export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export WEBHOOK_URL="$WEBHOOK_URL"
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export N8N_CONFIG_DIR=/data

# Si une encryption_key est spécifiée, l'utiliser
if [ -n "$ENCRYPTION_KEY" ] && [ "$ENCRYPTION_KEY" != "null" ]
  export N8N_ENCRYPTION_KEY="$ENCRYPTION_KEY"
  bashio::log.info "Utilisation de la clé de chiffrement spécifiée dans les options : $ENCRYPTION_KEY"
else  
  bashio::log.info "Aucune clé de chiffrement valide spécifiée (vide ou 'null'), n8n va la générer."
fi

n8n start &
N8N_PID=$!

# Attendre que /data/config soit créé (timeout de 30 secondes)
bashio::log.info "waiting for n8n to generate the encryption key..."
TIMEOUT=60
COUNT=0
while [ ! -f /data/config ] && [ $COUNT -lt $TIMEOUT ]; do
  sleep 1
  COUNT=$((COUNT + 1))
  bashio::log.debug "Attente de la création de /data/config... ($COUNT/$TIMEOUT secondes)"
done
bashio::log.debug "done!"

# Vérifier si encryption_key est vide et si le fichier config existe
if [ -z "$ENCRYPTION_KEY" ] || [ "$ENCRYPTION_KEY" = "null" ]
  if [ -f /data/config ]; then
    GENERATED_KEY=$(jq -r '.encryptionKey // empty' /data/config)
    if [ -n "$GENERATED_KEY" ]; then
      bashio::config 'encryption_key' "$GENERATED_KEY"
      bashio::log.info "Encryption key générée par n8n et exportée dans la config de l'addon : $GENERATED_KEY"
    else
      bashio::log.warning "Fichier /data/config trouvé, mais aucune clé de chiffrement (encryptionKey) n'est présente."
    fi
  else
    bashio::log.warning "Timeout atteint ($TIMEOUT secondes) ou échec : /data/config n'a pas été créé par n8n."
  fi
else
  bashio::log.debug "Clé de chiffrement déjà spécifiée, pas d'exportation nécessaire."
fi

# Attendre que n8n termine
wait $N8N_PID
