#!/bin/sh

#  ClearBranchAndStash.sh
#  AutoPackageScript
#
#  Created by zlm on 2018/7/30.
#  Copyright © 2018年 zlm. All rights reserved.

git branch | grep -v "master" | xargs git branch -D
git stash clear
git checkout master
