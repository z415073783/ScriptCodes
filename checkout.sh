#/bin/bash
BranchName="master"
if [[ "$1" = "-h" ]]; then
	#statements
	echo "参数为分支名字,如不带参数则默认切换到master分支"
	exit
fi

if [[ "$1" != "" ]]; then
	#statements
	BranchName=$1
	echo "切换到分支:${BranchName}"
fi
echo ${BranchName}
git stash save "cacheData"
git clean -xdf 
git checkout ${BranchName}
git fetch --all
git pull --all