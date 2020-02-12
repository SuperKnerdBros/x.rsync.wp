# x.rsync.wp

Script designed to be ran as CRONJOB to synchronize wp's uploads folder between instances
    
    $ .sh [options]
      -d DOMAIN name of folder
      -i IP Address to pull files from

### Install 
    $ git clone https://github.com/SuperKnerdBros/x.rsync.wp.git ~/bin/x.rsync.wp/
    $ sudo crontab -e
    
    # RSYNC WP UPLOADS EVERY MIN
    * * * * *  /home/ubuntu/bin/x.rsync.wp.uploads/.sh -d example.com -i 172.31.6.58  >> /home/ubuntu/x.cron.log 2>&1
    # CLEAN CRON LOG EVERY 2 DAYS @ MIDNIGHT
    0 0 */2 * * rm /home/ubuntu/x.cron.log; touch /home/ubnutu/x.cron.log;
