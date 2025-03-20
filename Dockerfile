# Utilisation de l'image de base fournie par Home Assistant
ARG BUILD_FROM
FROM $BUILD_FROM

# Définir la langue
ENV LANG C.UTF-8

# Installation des dépendances nécessaires pour n8n (Node.js, npm, etc.)
RUN apk add --no-cache \
    nodejs \
    npm \
    && npm install -g n8n

# Exposition du port utilisé par n8n
EXPOSE 5678

# Répertoire de travail
WORKDIR /data

# Commande pour démarrer n8n
CMD ["n8n", "start"]
