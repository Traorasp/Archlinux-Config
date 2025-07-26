#!/usr/bin/env bash

echo "AHHHHHHHHHHH"
if ! pgrep -x "wofi" > /dev/null; then
	wofi --show drun &
else
	pkill -x "wofi"
fi
