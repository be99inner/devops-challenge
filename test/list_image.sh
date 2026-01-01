#!/bin/bash
# list application via http://localhost:3000/api/list
# Usage: ./list.sh
curl -X 'GET' \
  'http://localhost:3000/files' \
  -H 'accept: application/json'
