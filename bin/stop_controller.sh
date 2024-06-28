kill -9 $(ps -ef |grep ros| grep dmpc | awk '{print $2}')
kill -9 $(ps -ef |grep ros| grep navigat | awk '{print $2}')
kill -9 $(ps -ef |grep ros| grep lqr | awk '{print $2}')
kill $(ps -ef |grep ros| grep record | awk '{print $2}')
