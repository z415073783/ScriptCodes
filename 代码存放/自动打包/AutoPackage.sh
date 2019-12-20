#!/bin/bash

FIRNAME="fir"
PGYNAME="pgy"


#选择上传平台 fir pgy
UPLOADINGTYPE=$PGYNAME
#编译类型 Debug,Release
buildConfig=Release
#是否要拉取最新代码
isCheckGitData=false


#上传fir使用的token
FIR_TOKEN=36207dfac52ff6be1766099301638182
#上传pgy使用的key
PGY_USER_KEY=0d8a855b8068628d55503304ac113c16
PGY_API_KEY=994b098bab5ddb641d0ec24bccb228cf

#工程名
SCHEMENAME=Odin-YMS
#bundle id
BUNDLEID="com.yealink.VCMobile"

#路径
DATE=$(date +%Y%m%d%H%M)
SOURCEPATH=$( cd "$( dirname $0 )" && pwd )
IPAPATH=$SOURCEPATH/AUTOBuildIPA/$BRANCHNAME/$DATE
IPANAME=$SCHEMENAME.ipa   





if [ "$isCheckGitData" = true ]; then
	echo "拉取最新代码"
	#分支
	BRANCHNAME=master

	#git update
	git checkout $BRANCHNAME
	if [[ $? -ne 0 ]]; then
		#statements
		exit 1
	fi
	git pull
	#pot update --verbose --no-repo-update
	if [[ $? -ne 0 ]]; then
		#statements
		exit 1
	fi
	#delete trash files
	if [[ -e $IPAPATH/* ]]; then
		#statements
		mv $IPAPATH/* ~/.Trash
		if [[ $? -ne 0 ]]; then
			#statements
			echo "error: Delete trash files failed!!"
		fi
	fi
fi

#build
xcodebuild -workspace $SOURCEPATH/$SCHEMENAME/$SCHEMENAME.xcworkspace -scheme $SCHEMENAME -configuration $buildConfig clean -archivePath $IPAPATH/$SCHEMENAME.xcarchive archive

xcodebuild -exportArchive -exportOptionsPlist $IPAPATH/$SCHEMENAME.xcarchive/info.plist -archivePath $IPAPATH/$SCHEMENAME.xcarchive -exportPath $IPAPATH/


if [ "$UPLOADINGTYPE" = "$FIRNAME" ]; then
	#上传fir
	echo "login fir account"
	fir login $FIR_TOKEN
	#开始上传到fir.im
	echo "begin uploading .ipa file to fir.im"
	fir p $IPAPATH/$IPANAME
	changelog='cat $SOURCEPATH/Readme'
	curl -X PUT --data "changelog=$changelog" http://fir.im/api/v2/app/${BUNDLEID}?token=$FIR_TOKEN
fi

if [ "$UPLOADINGTYPE" = "$PGYNAME" ]; then
	#statements
	echo "begin uploading to pgyer"
	curl -F "file=@${IPAPATH}/${IPANAME}" \
	-F "uKey=$PGY_USER_KEY" \
	-F "_api_key=$PGY_API_KEY" \
	https://qiniu-storage.pgyer.com/apiv1/app/upload \
	--max-time 1200
fi

echo "uploaded!"















