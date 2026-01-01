#!/bin/bash

# List images via API
echo "Listing images from API..."
response=$(curl -s -w "%{http_code}" -X 'GET' \
  'http://localhost:3000/files' \
  -H 'accept: application/json')
http_code=${response: -3}
body=${response%???}

if [ "$http_code" -ne 200 ]; then
    echo "Failed to list images. HTTP $http_code"
else
    echo "Images listed successfully:"
    echo "$body"
fi
