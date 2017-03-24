#!/bin/sh

USERNAME=`whoami | awk '{print $1}'`
SCRIPT_PID=`ps -U $USERNAME u | grep "run_serverlink.sh" | grep -v "grep" | awk '{ print $2; exit; }'`
PROCESS_PID=`ps -U $USERNAME u | grep "serverlink.php" | grep -v "grep" | awk '{ print $2; exit; }'`

echo "Killing run_serverlink.sh process with PID $SCRIPT_PID"
kill $SCRIPT_PID

echo "Killing php host process with PID $PROCESS_PID"
kill $PROCESS_PID
