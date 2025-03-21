mkdir -p rootfs/etc/s6-overlay/s6-rc.d/debug-shell/dependencies.d
touch rootfs/etc/s6-overlay/s6-rc.d/debug-shell/dependencies.d/init-n8n-key
echo "longrun" > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/type
echo "/etc/s6-overlay/s6-rc.d/debug-shell/run" > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/up
echo "#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: n8n
# Temporary debug shell to keep container alive
# ==============================================================================

bashio::log.info \"Debug shell started. Container will stay alive for interactive debugging.\"
bashio::log.info \"Use 'docker exec -it <container> bash' to access the shell.\"

# Garder le conteneur actif avec un shell
exec /bin/bash -i" > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/run
chmod +x rootfs/etc/s6-overlay/s6-rc.d/debug-shell/run

touch rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/debug-shell