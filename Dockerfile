ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Installation des dépendances
RUN apk add --no-cache \
    nodejs \
    npm \
    && npm install -g n8n

# Exposition du port
EXPOSE 5678

# Répertoire de travail pour les données de n8n
WORKDIR /data
ENV N8N_CONFIG_DIR=/data

# Copier le script d'entrée
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Utiliser le script comme point d'entrée
CMD ["/run.sh"]
