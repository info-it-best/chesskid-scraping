export JSON_FILE=$1
cat $JSON_FILE | grep '"id": "' | awk 'BEGIN {i=1} { if (i==1) {print $0 ; i = 0 } else {i=1}}' | sed 's/"//g' | sed 's/\,//g' | awk '{print $2}' >> results/ids.txt

#for i in {1..25} ; do ./get-ids.sh pages/$i.json ; done

# cat results/ids.txt | xargs -I {} sh -c './get-pgn.sh {} ; echo ","' >> results/pgns-raw.txt