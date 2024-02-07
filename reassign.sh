#!/bin/sh

# provide EMAIL, URL, and TOKEN before running
 
EMAIL=""
URL=""
TOKEN=""

if [ -z "$EMAIL" ]; then
    echo "error: no email provided"
    exit 1
fi

if [ -z "$URL" ]; then
    echo "error: no organisation URL provided"
    exit 1
fi

if [ -z "$TOKEN" ]; then
    echo "error: no API token provided"
    exit 1
fi
 
if [ -z "$1" ]; then
    echo "error: provide ticket ID as argument"
    exit 1
fi
 
TICKET=$1
 
username=$(curl --request GET --url "$URL/rest/api/latest/myself" --user "$EMAIL:$TOKEN" --header "Accept: application/json" | jq -r ".displayName")
items=$(curl --request GET --url "$URL/rest/api/3/issue/$TICKET/changelog" --user "$EMAIL:$TOKEN" --header "Accept: application/json")
 
last_item=$(echo "$items" | jq --arg username "$username" '.values | map(select(.items[]? | .field == "assignee" and .toString == $username)) | last')
 
assignor_name=$(echo "$last_item" | jq -r .author.displayName)
assignor_id=$(echo "$last_item" | jq -r .author.accountId)
 
curl --request PUT \
  --url "$URL/rest/api/3/issue/$TICKET/assignee" \
  --user "$EMAIL:$TOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{ \"accountId\": \"$assignor_id\" }"
 
echo "ticket assigned to $assignor_name"
