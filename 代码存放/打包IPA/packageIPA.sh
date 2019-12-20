#!/bin/bash

SOURCEPATH=$( cd "$( dirname $0 )" && pwd )
PROJECTNAME="package"
cd $SOURCEPATH
-- var=`date "+%Y-%m-%d %H:%M:%S"`
#打包步骤
mkdir Payload
mv $PROJECTNAME.app Payload/
zip -ry $PROJECTNAME.ipa Payload




