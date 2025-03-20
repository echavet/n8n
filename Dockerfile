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

# Répertoire de travail
WORKDIR /data
ENV N8N_CONFIG_DIR=/data

# Créer le répertoire pour s6-overlay et copier le script run
RUN mkdir -p /etc/services.d/n8n
COPY run.sh /etc/services.d/n8n/run
RUN chmod +x /etc/services.d/n8n/run

#CMD ["tail", "-f", "/dev/null"]
CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]
