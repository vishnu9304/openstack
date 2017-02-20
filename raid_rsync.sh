#!/bin/bash


# If the lockfile exists, exit
if [ -e "/tmp/.tom_raid_lock" ]; then
 echo -e >> /var/log/backup.log
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][FAIL] Cannot start backup when /tmp/.tom_raid_lock exists" >> /var/log/backup.log
else
 # Create a lockfile
 touch /tmp/.tom_raid_lock
 echo -e >> /var/log/backup.log
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][INFO] Backup for `hostname` started" >> /var/log/backup.log

 # Starting backups
 # Starting backup of /boot
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][INFO] Starting /boot backup" >> /var/log/backup.log
 rsync -aAX --delete  /boot /boot_backup
 STATUS=`echo $?`
 if [ "$STATUS" == "0" ]; then
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][SUCCESS] /boot backed up!" >> /var/log/backup.log
 else
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][FAIL] /Uh oh, /boot did not back up" >> /var/log/backup.log
 fi

 # Starting backup of /
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][INFO] Starting / backup" >> /var/log/backup.log
 rsync -aAXv --delete  --exclude={"/root_backup","/boot_backup","/home_backup","/var/log/","/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/","/srv/","/lost+found","/home/"} / /root_backup
 STATUS=`echo $?`

 if [ "$STATUS" == "0" ]; then
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][SUCCESS] / backed up!" >> /var/log/backup.log
 else
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][FAIL] Uh oh, / did not back up" >> /var/log/backup.log
 fi

 # Starting backup of /home
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][INFO] Starting /home backup" >> /var/log/backup.log
 rsync -aAX --delete /home /home_backup

 if [ "$STATUS" == "0" ]; then
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][SUCCESS] /home backed up!" >> /var/log/backup.log
 else
  echo "[`date | awk {'print $2$3" " $4" " $6'}`][FAIL] Uh oh, /home did not backup" >> /var/log/backup.log
 fi

 # Finished
 echo "[`date | awk {'print $2$3" " $4" " $6'}`][INFO] Backup for `hostname` completed" >> /var/log/backup.log
 rm /tmp/.tom_raid_lock
fi
