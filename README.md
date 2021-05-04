# application_monitor
Monitors Linux Application

Create a cronjob to monitor the apps continously
- crontab -e
- '* * * * * /<path_to_script>/application_monitor.sh > /dev/null 2>&1'
