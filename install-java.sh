#!/bin/bash

apt update
apt install -y default-jre

java_version=$(java -version 2>&1 > /dev/null  | grep "java version\|openjdk version" | awk '{print substr($3,2,2)}')

if [ "$java_version" == "" ]
then
    echo Installing Java has failed. No java version found	
elif [ "$java_version" == "1." ]
then
    echo An old version of Java installation found
elif [ "$java_version" -ge 11 ]
then
    echo Java version 11 or greater installed successfully
fi

