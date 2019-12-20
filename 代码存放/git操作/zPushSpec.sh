#/bin/hash
if [[ "$1" = "-h" ]]; then
	#statements
	echo "运行该脚本前请先修改.podspec文件中的对应版本号"
	git tag --list
	echo "sh pushSpec.sh 需要提交的版本号"
	exit
fi

TAG=$1
git add .
git tag -a $TAG -m "添加{$TAG}"
git push origin --tags
pod repo push YLCocoaPods YLRouter.podspec --allow-warnings



