#!/bin/bash

#Set up Crontab for this script to monitor the process or app continously
#Eg. crontab -e
# * * * * * /<path_to_script>/application_monitor.sh > /dev/null 2>&1

#Setting up log file for monitoring script, Save all the details
LOG=path_to_log/logfile
#Recipient MAIL ID to send an email notification. Installed mailutils to send notification
MAIL_RECIP="your_email@your_domain.com"

#Process or App name which needs to monitored. Assuming the process to NGINX
PROC_NAME="nginx"
#Command to start the process or application
PROC_CMD="/etc/init.d/$PROC_NAME start"
#Path to application log
PROC_LOG="path/to/applog"

if (( $(ps -ef | grep -v grep | grep $PROC_NAME | wc -l) > 0 ))
then
	DATE=$(date)
	echo "${DATE}: ${PROC_NAME} is already active and running" >> $LOG
else
	DATE=$(date)
	STOP_TIME=$(tail -n1 $PROC_LOG)
    echo "${DATE}: ${PROC_NAME} was not found" >> $LOG
    echo "${DATE}: Restarting the ${PROC_NAME} with ${PROC_CMD} ..." >> $LOG
    /etc/init.d/$PROC_NAME start
	if (( $(ps -ef | grep -v grep | grep $PROC_NAME | wc -l) > 0 ))
	then
		STATUS="RUNNING"
	else
		STATUS="NOT RUNNING"
	fi
	mail -s "LINUX PROCESS ALERT: Process ${PROC_NAME} was crashed at ${STOP_TIME}. ${PROC_NAME} was started with ${PROC_CMD} at ${DATE}. Current Status of the process is ${STATUS}" $MAIL_RECIP < /dev/null
fi
