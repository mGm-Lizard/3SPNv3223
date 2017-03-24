#!/bin/bash

while :
do
	echo "Running serverlink.php...";
	nohup /usr/bin/php -c . -f serverlink.php -- "208.146.35.56" 29945 >> serverlink.log 2>&1
	#nohup /usr/bin/php -c . -f serverlink.php -- "208.146.35.56" 29945 >> serverlink.log 2>&1
	sleep 1

done

fi
