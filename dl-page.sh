export PAGE_NO=$1
echo "Loading page $PAGE_NO ..."
curl -X GET 'https://www.chesskid.com/api/v1/games/finished?page='$PAGE_NO \
  -H 'authority: www.chesskid.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H 'cookie: _gcl_au=1.1.1025210826.1701459864; _ga=GA1.2.1753057811.1701459864; _ga_C23C0QM7XL=GS1.1.1701459864.1.1.1701459910.14.0.0; remuser=LeftPowerfulLogic; cal=MTFlZTkwODIyM2YwOTU5ZTg5MzhiOWEzZmQ2YTZlMDkuUUFaSGJSTldaemRrQUM2QzI0Q0tRY2VBbDZEbE1CeW1LSGdDNFMzWWhrR1JnTm9TSXhDVVVCZTJIVVIwVS9ndzVaTmpBSXpyT0d6aGZSS3oxQkRkR1dEZFBubDVEK3FZSTViZmRuMktmam89; __Host-READ_GDPR_POLICY=1; device_pixel_ratio=1.7999999523162842; PHPSESSID=93db4799947108fe4059dab28a7e78a0; GCLB=CMLJzImOmeXsGg; __cf_bm=LkLEiUdVnrolWQQB_NEzU3hvVkscp1BT3GJJbbLl6cY-1703099572-1-AXb7gL9oyWH5y69aetoZWJEjeElOyKx6PTn0+RgPxz8W3oNNPZYCRwhqWBh0nPPx0C7LF/p3wmLdLbGJuB5OvOo=; amp_89e2a8=XjqQtM-vN2WV75Atn_Naj9.MTFlYjkyNWUzNDgzNzRmMDkyZDY1ZTA0M2UwMjAwNDA=..1hi48i9dp.1hi4aglot.56.6b.bh' \
  -H 'referer: https://www.chesskid.com/play/game-archive' \
  -H 'sec-ch-ua: "Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' > pages/$PAGE_NO.json
node json-tool pages/$PAGE_NO.json
#for i in {1..100} ; do ./dl-page.sh $i ; done