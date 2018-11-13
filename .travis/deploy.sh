#!/bin/sh
curl --url 'https://api.esoui.com/addons/update' \
  --header "x-api-token: ${ESOUI_API_KEY}" \
  --form id=$1 \
  --form version=$2 \
  --form archive=Yes \
  --form compatible=$3 \
  --form updatefile=@$4