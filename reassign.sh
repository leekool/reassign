#!/bin/sh

# provide EMAIL, URL, and TOKEN before running
# run by executing script with ticket as argument
# e.g ./reassign.sh ISSUE-1

EMAIL=""
URL=""
TOKEN=""
 
error=0

if [ -z "$EMAIL" ]; then
    echo "error: no email provided"
    error=1
fi

if [ -z "$URL" ]; then
    echo "error: no organisation URL provided"
    error=1
fi

if [ -z "$TOKEN" ]; then
    echo "error: no API token provided"
    error=1
fi
 
if [ -z "$1" ]; then
    echo "error: provide ticket ID as argument"
    error=1
fi

if [ $error -gt 0 ]; then
    exit 1
fi
 
TICKET=$1
 
display_name=$(curl --request GET --url "$URL/rest/api/latest/myself" --user "$EMAIL:$TOKEN" --header "Accept: application/json" | jq -r ".displayName")
changelog=$(curl --request GET --url "$URL/rest/api/3/issue/$TICKET/changelog" --user "$EMAIL:$TOKEN" --header "Accept: application/json")
 
last_assign=$(echo "$changelog" | jq --arg display_name "$display_name" '.values | map(select(.items[]? | .field == "assignee" and .toString == $display_name)) | last')
 
assignor_name=$(echo "$last_assign" | jq -r .author.displayName)
assignor_id=$(echo "$last_assign" | jq -r .author.accountId)
 
curl --request PUT \
  --url "$URL/rest/api/3/issue/$TICKET/assignee" \
  --user "$EMAIL:$TOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{ \"accountId\": \"$assignor_id\" }"
 
echo "ticket assigned to $assignor_name"
