# !/usr/bin/env bash
# prevents camera to autoload
#
systemctl --user stop gvfs-gphoto2-volume-monitor
SERVICE="darktable"
if pgrep -x "$SERVICE" >/dev/null
then
    echo "$SERVICE is already running"
else
	/usr/bin/darktable
    #echo "$SERVICE stopped"
    # uncomment to start nginx if stopped
fi

