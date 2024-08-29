#!/bin/bash

# Update package index
sudo apt-get update

# Install the latest Java version
sudo apt-get install -y default-jdk

# Check if Java is installed at all
if ! command -v java &> /dev/null; then
    echo "Java is not installed."
    exit 1
fi

# Get the installed Java version
java_version=$(java -version 2>&1 | awk -F[\"\"] '/version/ {print $2}')
java_major_version=$(echo "$java_version" | awk -F[.] '{print $1}')

# Check if an older Java version (lower than 11) is installed
if [[ "$java_major_version" -lt 11 ]]; then
    echo "An older version of Java is installed: $java_version"
    exit 1
fi

# Check if Java version 11 or higher is installed
if [[ "$java_major_version" -ge 11 ]]; then
    echo "Java installation was successful. Installed version: $java_version"
else
    echo "Failed to install the correct Java version."
    exit 1
fi
