#!/usr/bin/env bash

set -eu
shopt -s failglob

MEMBERS="$(
    sudo -u postgres psql lgbtq-discord postgres -tAqXc \
        'SELECT total, online FROM member_counts ORDER BY id DESC LIMIT 1' \
        2> /dev/null)"
TOTAL_MEMBERS="$(echo "$MEMBERS" | cut -f1 '-d|')"
ONLINE_MEMBERS="$(echo "$MEMBERS" | cut -f2 '-d|')"

if [[ $TOTAL_MEMBERS =~ ^[[:space:]]*$ || $ONLINE_MEMBERS =~ ^[[:space:]]*$ ]]; then
    echo "Failed to get members counts."
    exit 1
fi

sed -E -i \
    -e "s|(<span id=\"TOTAL\">)[0-9]+(</span>)|\\1$TOTAL_MEMBERS\\2|g" \
    -e "s|(<span id=\"ONLINE\">)[0-9]+(</span>)|\\1$ONLINE_MEMBERS\\2|g" \
    "/var/www/lgbtqprogrammers.com/html/index.htm"
