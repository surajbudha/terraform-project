#!/usr/bin/bash
amazon-linux-extras install 'redis4.0' -y
if [ $? -eq 0 ]
	echo "redis4.0 Install successfull" > /var/log/postinstall.log
else
	echo "redis4.0 Install Failed" > /var/log/postinstall.log
fi

yum install php php-pear -y
if [ $? -eq 0 ]
	echo "PHP and PHP Pear Install successfull" >> /var/log/postinstall.log
else
	echo "PHP and PHP Pear Install Failed" >> /var/log/postinstall.log
fi

pecl channel-update pecl.php.net
if [ $? -eq 0 ]
	echo "PECL Update successfull" >> /var/log/postinstall.log
else
	echo "PECL Update Failed" >> /var/log/postinstall.log
fi

pecl install igbinary igbinary-devel redis
if [ $? -eq 0 ]
	echo "igbinary igbinary-devel redis Install successfull" >> /var/log/postinstall.log
else
	echo "igbinary igbinary-devel redis Install Failed" >> /var/log/postinstall.log
fi

cp -rpv  /etc/redis.conf  /etc/redis.conf_bkup_`date +%F`
echo "Taken backup of redis.conf" >> /var/log/postinstall.log
