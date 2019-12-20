#/bin/bash

if [[ "$1" = "-h" ]] || [[ $# = 0 ]]; then
#statements
echo "功能类提交: 【Feat】 简写:fea 描述"
echo "仅更新资源文件的提交: 【Res】 简写:res 描述"
echo "仅更新工具/脚本/pod的提交: 【Chore】 简写:cho 描述"
echo "重构: 【Refactor】 简写:ref 影响(修改的影响范围)\n 例: ref 描述 影响(修改的影响范围)"
echo "增加测试用例的提交: 【Test】简写:tes 描述"
echo "性能提升的提交: 【Perf】简写:per 描述"
echo "代码缩进、风格调整的提交: 【Format】简写:for 描述"
echo "自测bug修正提交: 【Fix】简写:bug 描述"
echo "带bug链接的bug修正提交: 【Fix-id】简写:bugID 描述 id号 bug链接 原因(bug产生原因) 方案(修复方案) 影响(修改的影响范围)"

echo "分支名放最后"
exit
# echo "带bug链接的bug修正提交: 【Fix-id1,id2,id3...】简写:bugIdList 描述 number(id数量) id1 id2 id3 ... bug链接1 bug链接2 bug链接3 ... 原因(bug产生原因) 方案(修复方案) 影响(修改的影响范围)"
fi

Key=$1
NewBranchName=""
Description=""

if [[ "$Key" = "fea" ]]; then
#statements
Description="【Feat】$2"
NewBranchName=$3
fi
if [[ "$Key" = "res" ]]; then
#statements
Description="【Res】$2"
NewBranchName=$3
fi
if [[ "$Key" = "cho" ]]; then
#statements
Description="【Chore】$2"
NewBranchName=$3
fi
if [[ "$Key" = "ref" ]]; then
#statements
Description="【Refactor】$2
影响:$3"
NewBranchName=$4
fi
if [[ "$Key" = "tes" ]]; then
#statements
Description="【Test】$2"
NewBranchName=$3
fi
if [[ "$Key" = "per" ]]; then
#statements
Description="【Perf】$2"
NewBranchName=$3
fi
if [[ "$Key" = "for" ]]; then
#statements
Description="【Format】$2"
NewBranchName=$3
fi
if [[ "$Key" = "bug" ]]; then
#statements
Description="【Fix】$2"
NewBranchName=$3
fi
if [[ "$Key" = "bugID" ]]; then
#statements
BugId=$3
BugUrl=$4
Cause=$5
Change=$6
Affect=$7
Description="【Fix-${BugId}】$2
$BugUrl
原因:$Cause
方案:$Change
影响:$Affect"
NewBranchName=$8
fi



# if [[ "$Key"="bugIdList" ]]; then
#statements
# Number=$3
# Description="【Fix-"

# for (( i = 0; i < $Number; i++ )); do
#     #statements

#     ((Index=$i+4))

#     echo "Index=$Index"
#     Description="$Description$$Index"
#     MaxLimit=$Number-1
#     if [[ i!=$MaxLimit ]]; then
#         #statements
#         Description="$Description,"
#     fi
# done
# fi
echo $Description

Time=`date +%Y-%m-%d_%H_%M_%s`
#上传分支名
BranchName="zenglm/$Time"
echo "BranchName = ${BranchName}"
# CommitContent="提交代码注释"

# #缓存
git stash save ${BranchName}

# #拉取最新master并切换到上传分支
if [[ "$NewBranchName" = "" ]]; then
#statements
NewBranchName="master"
fi

git checkout ${NewBranchName}
git pull
git checkout -b ${BranchName}

# #重新应用缓存
git stash apply

git add -A
#git commit -a
git commit -m $Description

git push origin ${BranchName}

