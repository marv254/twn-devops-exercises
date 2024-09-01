#!/bin/bash

NEW_USER=topg

# Create the 'myapp' user if it doesn't exist
if id "$NEW_USER" &>/dev/null; then
  echo "User '$NEW_USER' already exists."
else
  echo "Creating user 'myapp'..."
  sudo useradd -m -s /bin/bash $NEW_USER
  if [ $? -ne 0 ]; then
    echo "Failed to create user '$NEW_USER'"
    exit 1
  fi
fi

LOG_DIR=/home/$NEW_USER/node_log
# Check if the log directory exists
if [ ! -d "$LOG_DIR" ]; then
  echo "Log directory '$LOG_DIR' does not exist. Creating it..."
  sudo mkdir -p "$LOG_DIR"
  sudo chown -R $NEW_USER:$NEW_USER $LOG_DIR
  sudo chmod -R 755 $LOG_DIR
  if [ $? -ne 0 ]; then
    echo "Failed to create log directory '$LOG_DIR'"
    exit 1
  fi 
else
  echo "Log directory '$LOG_DIR' already exists."
fi

 
# Update package list and install Node.js & npm
sudo apt update -y && sudo apt install -y nodejs npm
if [ $? -ne 0 ]; then
  echo "Failed to install Node.js and npm"
  exit 1
fi

# Display installed versions
nodejs_version=$(node --version)
npm_version=$(npm --version)
echo "Running Node.js version $nodejs_version"
echo "Running npm version $npm_version"

# Download the application artifact
sudo runuser -l $NEW_USER -c "wget -O node-app.tgz https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz"
if [ $? -ne 0 ]; then
  echo "Failed to download the application artifact"
  exit 1
fi

# Extract the application
sudo runuser -l $NEW_USER -c "tar -xvzf node-app.tgz"
if [ $? -ne 0 ]; then
  echo "Failed to extract the application artifact"
  exit 1
fi

sudo runuser -l $NEW_USER -c "
export APP_ENV=dev &&
export DB_USER=myuser &&
export DB_PWD=mysecret &&
export LOG_DIR=$LOG_DIR &&
cd package &&

npm install &&
node server.js &"

#Wait for app to start up
sleep 5

# Check if the log file exists and print a message
#  if [ -f "$LOG_DIR/app.log" ]; then
#    echo "Logs are being written to '$LOG_DIR/app.log'"
#  else
#    echo "Log file '$LOG_DIR/app.log' was not found."
#  fi
#print out the log
sudo cat $LOG_DIR/app.log



