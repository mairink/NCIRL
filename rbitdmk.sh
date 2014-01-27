
#!/bin/bash
# Mairin Kavanagh NCIRL

cd /tmp
# in the tmp directory create a sandbox directory and give it a random name.
SANDBOX=sandbox_$RANDOM
mkdir $SANDBOX
cd $SANDBOX

# Set error counter to zero
ERRORCHECK=0

# make a directory called webpackage and create files to put in it.
# Make test webpackage
mkdir webpackage
touch webpackage/index.htm
touch webpackage/form.htm
touch webpackage/script1.plx
touch webpackage/script2.plx
#
# Make the process directories
mkdir build
mkdir integrate
mkdir test
mkdir deploy
#
# Make webpackage and move webpackage
#

#tar / zip up webpackage calling it webpackage_preBuild.tgz 
tar -zcvf webpackage_preBuild.tgz webpackage

# Check if MD5sum of this file has changed
MD5SUM=$(md5sum webpackage_preBuild.tgz | cut -f 1 -d' ')
PREVMD5SUM=$(cat /tmp/md5sum)
FILECHANGE=0
# if MD5sum has changed proceed. If no change, do nothing and exit.
if [[ "$MD5SUM" != "$PREVMD5SUM" ]]
then
        FILECHANGE=1
        echo $MD5SUM not equal to $PREVMD5SUM
else
        FILECHANGE=0
        echo $MD5SUM equal to $PREVMD5SUM
fi
echo $MD5SUM > /tmp/md5sum
if [ $FILECHANGE -eq 0 ]
then
        echo no change in files, doing nothing and exiting
        exit
fi
# Proceding to move the webpackage to the Build directory.
# BUILD
mv webpackage_preBuild.tgz build
rm -rf webpackage
cd build
#unzip the tar folder moved in from the preBuild
tar -zxvf webpackage_preBuild.tgz
#
#tar / zip up webpackage calling it webpackage_preIntegrate.tgz 
tar -zcvf webpackage_preIntegrate.tgz webpackage
ERRORCHECK=0
# INTEGRATE
mv webpackage_preIntegrate.tgz ../integrate
rm -rf webpackage
cd ../integrate
#
tar -zxvf webpackage_preIntegrate.tgz
###

tar -zcvf webpackage_preTest.tgz webpackage
# Set error counter to zero
ERRORCHECK=0
# TEST
mv webpackage_preTest.tgz ../test
rm -rf webpackage
cd ../test
#
tar -zxvf webpackage_preTest.tgz
###
#tar / zip up webpackage calling it webpackage_preIntegrate.tgz 
tar -zcvf webpackage_preDeploy.tgz webpackage
# Set error counter to zero
ERRORCHECK=0
# DEPLOY
# if error free tar / zip up webpackage calling it webpackage_preDeploy.tgz 
if [ $ERRORCHECK -eq 0 ]
then
        mv webpackage_preDeploy.tgz ../deploy
        rm -rf webpackage
        cd ../deploy
					#unzip the tar folder moved in from the preDeploy
        tar -zxvf webpackage_preDeploy.tgz
fi
# The webpackage is now in the DEPLOY folder - where it is ready for use in production following final signoff. 