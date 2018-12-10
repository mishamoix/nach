#!/usr/bin/env bash

curl -o Chan/Resources/GoogleService-Info.plist -X GET \
  ''"$FIREBASE_URL"'' \
  -H 'Accept-Encoding: gzip;q=1.0, compress;q=0.5' \
  -H 'Accept-Language: en;q=1.0, ru-RU;q=0.9' \
  -H 'Cache-Control: no-cache'

echo ''"$FIREBASE_URL"''
echo "Downloaded GoogleService-Info.plist"
ls -l Chan/Resources/