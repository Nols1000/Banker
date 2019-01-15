#!/bin/sh
curl --url 'https://api.esoui.com/addons/update' \
  --header "x-api-token: ${ESOUI_API_KEY}" \
  --form "id=362" \
  --form "version=$1" \
  --form "archive=Yes" \
  --form "compatible=$2" \
  --form "updatefile=@$3" \
  --form "description=$(.travis/blackfriday -common-extensions -format=vb-code Readme.md)" \
  --form "changelog=$(.travis/blackfriday -common-extensions -format=vb-code Changelog.md)"