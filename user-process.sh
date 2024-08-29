#!/bin/bash

read -p "Would you like to sort the processes by cpu(c) or memory(m)?" sortby

read -p "How many processes would you like to display?" process_num
if [ "$sortby" == "c" ]
then 
	echo "sorted by cpu"
	ps aux --sort -%cpu | head -n $process_num
elif [ "$sortby" == "m" ]
then
	echo "sorted by memory"
	ps aux --sort -rss | head -n $process_num
else
	echo 'wrong input! enter m for memory or c for cpu'
fi

