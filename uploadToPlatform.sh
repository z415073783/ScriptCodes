#/bin/bash
#上传到蒲公英平台
if [[ "$1" = "-h" ]]; then
	#statements
	echo "-------------------------------------------
	以键值对的形式加入参数,
	例: sh uploadToPlatform -ipaPath /user/app.ipa -UserKey 蒲公英的UserKey -appKey 蒲公英的ApiKey
	参数说明: 
	-ipaPath     安装包路径 
	-userKey     pgyerUserKey
	-apiKey		 pgyerApiKey
-------------------------------------------"
	exit
fi


Key=""
PreStr="-"
for value in $@; do
	#statements
	# echo $value
	if [[ "$Key" = "$PreStr"* ]]; then
		#statements
		
		if [[ "$Key" = "-ipaPath" ]]; then
			#statements
			IPAPath="$value"
		fi

		if [[ "$Key" = "-userKey" ]]; then
			#statements
			UserKey="$value"
		fi

		if [[ "$Key" = "-apiKey" ]]; then
			#statements
			ApiKey="$value"
		fi

		Key=""
	fi

	if [[ "$value" = "$PreStr"* ]]; then
		#statements
		Key=$value
	fi
done

echo $IPAPath $UserKey $apikey

# curl -F file=@$IPAPath -F uKey=$UserKey -F _api_key=$ApiKey https://qiniu-storage.pgyer.com/apiv1/app/upload -v
echo "---------------------开始上传数据---------------------"
curl -F "file=@${IPAPath}" \
	-F "uKey=$UserKey" \
	-F "_api_key=$ApiKey" \
	https://qiniu-storage.pgyer.com/apiv1/app/upload \
	--show-error -v \
	--max-time 1200

echo "传输结束"










