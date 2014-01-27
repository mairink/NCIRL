#!/usr/bin/bash
# Mairin Kavanagh NCIRL  Full Clean Deploy script

# Make a sandbox directory, randomise its name and print that name back to screen

SANDBOX=sandbox_$RANDOM
echo Using sandbox $SANDBOX
#
# Stop services so as to orderly wind down so that apache2 and
# mysql can be wiped and reinstalled from scratch.

/etc/init.d/apache2 stop
/etc/init.d/mysql stop
#
apt-get update
#
#  uninstall apache2, then reinstall
#
apt-get -q -y remove apache2
apt-get -q -y install apache2
#
#  uninstall mysql, then reinstall
#

apt-get -q -y remove mysql-server mysql-client
echo mysql-server mysql-server/root_password password password | debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | debconf-set-selections
apt-get -q -y install mysql-server mysql-client
#
# Make a sandbox within the /tmp directory
cd /tmp
mkdir $SANDBOX
cd $SANDBOX/
#
# Take a copy of the contents of github which should contain the released files to be deployed.
#
git clone https://github.com/FSlyne/NCIRL.git

#Move into the directory of the cloned files and copy to the required locations.
cd NCIRL/
#
cp Apache/www/* /var/www/
cp Apache/cgi-bin/* /usr/lib/cgi-bin/

# Set the required read access to the contents of the directories /usr/lib/cgi-bin/*
chmod a+x /usr/lib/cgi-bin/*
#
# Start services
/etc/init.d/apache2 start
/etc/init.d/mysql start

#
#  Append code to add content by creating a database called 'dbtest' and populating it with some data.
#  Before doing this drop any existing table with that name.
#
cat <<FINISH | mysql -uroot -ppassword
drop database if exists dbtest;
CREATE DATABASE dbtest;
GRANT ALL PRIVILEGES ON dbtest.* TO dbtestuser@localhost IDENTIFIED BY 'dbpassword';
use dbtest;
drop table if exists custdetails;
create table if not exists custdetails (
name         VARCHAR(30)   NOT NULL DEFAULT '',
address         VARCHAR(30)   NOT NULL DEFAULT ''
);
insert into custdetails (name,address) values ('Maire Kavanagh','NCIRL Mayor Street'); select * from custdetails;
FINISH
#
#  Remove the sandbox created in the /tmp directory
#
cd /tmp
rm -rf $SANDBOX

