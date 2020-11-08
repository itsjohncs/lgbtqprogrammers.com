#!/usr/bin/env bash

set -xeu
shopt -s failglob

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rsync -v -r --delete "$SCRIPT_DIR/src/" tortoise:/var/www/lgbtqprogrammers.com/html/
rsync -v "$SCRIPT_DIR/update-counts.sh" tortoise:/opt/update-discord-counts.sh
ssh tortoise "/opt/update-discord-counts.sh"
