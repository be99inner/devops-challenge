#!/bin/bash

# Upload all images from the img/ folder to the API
echo "Starting upload of images from img/ folder..."

for file in img/*; do
    # Check if it's an image file (skip .DS_Store and other non-images)
    if [[ $file == *.jpg || $file == *.jpeg || $file == *.png || $file == *.webp ]]; then
        echo "Uploading $file..."
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -F "file=@$file" http://localhost:3000/upload)
        if [ "$response" -ne 200 ]; then
            echo "Failed to upload $file"
        else
            echo "Uploaded $file."
        fi
    fi
done

echo "All images uploaded."