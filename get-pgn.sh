export GAME_ID=$1
#echo "GAME_ID $GAME_ID"
curl 'https://www.chesskid.com/api/v1/games/'$GAME_ID'/pgn?category=fast' \
  -H 'authority: www.chesskid.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H 'cookie: _gcl_au=1.1.1025210826.1701459864; _ga=GA1.2.1753057811.1701459864; _ga_C23C0QM7XL=GS1.1.1701459864.1.1.1701459910.14.0.0; remuser=LeftPowerfulLogic; cal=MTFlZTkwODIyM2YwOTU5ZTg5MzhiOWEzZmQ2YTZlMDkuUUFaSGJSTldaemRrQUM2QzI0Q0tRY2VBbDZEbE1CeW1LSGdDNFMzWWhrR1JnTm9TSXhDVVVCZTJIVVIwVS9ndzVaTmpBSXpyT0d6aGZSS3oxQkRkR1dEZFBubDVEK3FZSTViZmRuMktmam89; __Host-READ_GDPR_POLICY=1; device_pixel_ratio=1.7999999523162842; PHPSESSID=93db4799947108fe4059dab28a7e78a0; GCLB=CMLJzImOmeXsGg; __cf_bm=._0S3RPeCxd4fYTxlZ_aw3uSsrjQonB5PaGxd45uciU-1703100487-1-AYaLppI9UYO+EcVQVC9A0/DjUt1HBwIUAhGrsqVsMP1WyfOr+RD/FPy+3qNKpWpPoQOX2cMpJbqBOihhNE2xPcI=; amp_89e2a8=XjqQtM-vN2WV75Atn_Naj9.MTFlYjkyNWUzNDgzNzRmMDkyZDY1ZTA0M2UwMjAwNDA=..1hi48i9dp.1hi4c0q3q.56.6c.bi' \
  -H 'referer: https://www.chesskid.com/analysis/game/fast/'$GAME_ID \
  -H 'sec-ch-ua: "Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  --compressed

# cat pages/1.json | grep '"id": "' | awk 'BEGIN {i=1} { if (i==1) {print $0 ; i = 0 } else {i=1}}' | sed 's/"//g' | sed 's/\,//g' | awk '{print $2}'