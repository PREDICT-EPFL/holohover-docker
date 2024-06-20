kill $(ps -ef |grep ros| grep dmpc | awk '{print $2}')
