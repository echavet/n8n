ARG BUILD_FROM
FROM $BUILD_FROM

# Installation des dépendances
RUN apk add --no-cache \
    nodejs \
    npm \
    jq

# Installer n8n globalement
RUN npm install -g n8n

# Exposition du port
EXPOSE 5678

# Répertoire de travail
WORKDIR /data
ENV N8N_CONFIG_DIR=/data
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
#CMD ["tail", "-f", "/dev/null"]
#CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]
