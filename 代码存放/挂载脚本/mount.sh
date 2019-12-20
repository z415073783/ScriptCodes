#!/bin/bash
SOURCEPATH=$( cd "$( dirname $0 )" && pwd )
echo $SOURCEPATH
cd $SOURCEPATH
sudo mkdir /Volumes/package
sudo mount_smbfs //guest:@192.168.6.202/phone-src /Volumes/package
