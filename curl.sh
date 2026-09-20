#!/bin/bash
# Forwarder
# set NFS_DIR first

NFS_DIR="/path/to/nfs"
ES_URL="https://<es-host>:9200/logs-solaris-default/_doc"
ES_USER="<es-username>"
ES_PASS="<es-password>"

# search file start at solaris_stat in NFS folder
shopt -s nullglob
for file in "$NFS_DIR"/solaris_stat_*.json; do
    
    # Kirim ke Elasticsearch
    HTTP_RESPONSE=$(curl -s -k -o /dev/null -w "%{http_code}" -X POST "$ES_URL" \
      -u "${ES_USER}:${ES_PASS}" \
      -H "Content-Type: application/json" \
      -d @"$file")

    if [ "$HTTP_RESPONSE" -eq 201 ]; then
        # if .json are succesfully send to elasticsearch, remove the files.
        rm -f "$file"
    else
        # throw error if not succesfull.
        echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) - ERROR: Failed to send $file. HTTP $HTTP_RESPONSE"
    fi
done
