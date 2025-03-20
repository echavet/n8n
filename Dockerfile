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
# Définit le chemin de stockage de n8n (équivalent à /home/node/.n8n)
ENV N8N_CONFIG_DIR=/data

# Commande pour démarrer n8n
CMD ["n8n", "start"]
