echo "module.exports = [" > results/pgns-raw.js
cat results/ids.txt | xargs -I {} sh -c './get-pgn.sh {} ; echo ","' >> results/pgns-raw.js
echo "];" >> results/pgns-raw.js