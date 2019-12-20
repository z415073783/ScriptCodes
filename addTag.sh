#/bin/hash
if [[ "$1" = "-h" ]]; then
	echo "参数为需要增加的tag"
	git describe --tags `git rev-list --tags --max-count=3`
	exit
fi

TAG=$1
git tag -a $TAG -m "添加{$TAG}"
git push origin --tags


