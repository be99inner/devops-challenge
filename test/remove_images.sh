#!/bin/bash

# Remove all images from the API using filenames as keys
echo "Starting removal of images from API..."

for file in img/*; do
    # Check if it's an image file (skip .DS_Store and other non-images)
    if [[ $file == *.jpg || $file == *.jpeg || $file == *.png || $file == *.webp ]]; then
        filename=$(basename "$file")
        echo "Removing $filename..."
        response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:3000/files/$filename)
        if [ "$response" -ne 200 ]; then
            echo "Failed to remove $filename"
        else
            echo "Removed $filename."
        fi
    fi
done

echo "All images removal attempted."