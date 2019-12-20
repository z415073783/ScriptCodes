//
//  GitCommit.swift
//  zlm_commit
//
//  Created by zlm on 2018/12/29.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation




class GitCommit {
    class func commit() {
        let data = ProcessInfo.processInfo.getDictionary()
        guard let type = CommitType(rawValue: data["t"] ?? ""), let descript = data["d"] else {
            exit(ErrorCode.paramsError.rawValue)
        }

        let affect: String? = data["a"]
        let reason: String? = data["r"]
        let scheme: String? = data["s"]
        let url: String? = data["u"]
        let branch: String = CacheData.getBranch()
        var urlID: String?

        if let _url = url {
            let result = _url.regularExpressionFind(pattern: "BugID=[0-9]*|MOBILE-[0-9]*")
            for item in result {
                let subStr = (_url as NSString).substring(with: item.range) as String
                urlID = subStr.regularExpressionReplace(pattern: "[^[0-9]]*", with: "")
            }
        }



        var commitStr = ""
        let typeStr = type.getType()
        //拼接
        if let _urlID = urlID {
            if let range = typeStr.regularExpressionFind(pattern: "【[A-Za-z]*").first?.range {
                var subStr = (typeStr as NSString).substring(with: range)
                subStr += ("-" + _urlID + "】")
                commitStr = subStr
            }
        } else {
            commitStr += typeStr
        }
        commitStr += """
        \(descript)
        \(url ?? "")
        \(reason == nil ? "" : "原因: \(reason ?? "")")
        \(scheme == nil ? "" : "方案: \(scheme ?? "")")
        \(affect == nil ? "" : "影响: \(affect ?? "")")
        """
        commitStr = commitStr.regularExpressionReplace(pattern: "\\n\\n", with: "\n") ?? commitStr

        YLLOG.info("commitStr = \n\(commitStr)")

        //获取时间
        let time = showNormalDate(timeInterval: Date().timeIntervalSince1970)

        //新增分支名
        let newBranchName = "zenglm/\(time)"
        CacheData.shared.newBranch = newBranchName
        YLLOG.info("新增分支为: \(newBranchName)")
        YLLOG.info("储藏代码: \(newBranchName)")
        var scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["stash", "save", newBranchName], showOutData: true))
        if scriptResult.status == false {
            exit(2)
        }
        YLLOG.info("拉取远程代码到本地分支")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["checkout", branch], showOutData: true))
        if scriptResult.status == false {
            exit(3)
        }
        YLLOG.info("pull")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["pull"], showOutData: true))
        if scriptResult.status == false {
            exit(4)
        }
        YLLOG.info("checkout新分支")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["checkout", "-b", newBranchName], showOutData: true))
        if scriptResult.status == false {
            exit(5)
        }
        YLLOG.info("重新应用缓存")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["stash", "apply"], showOutData: true))
        if scriptResult.status == false {
            exit(6)
        }
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["add", "-A"], showOutData: true))
        if scriptResult.status == false {
            exit(7)
        }
        YLLOG.info("提交变更")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["commit", "-m", commitStr], showOutData: true))
        if scriptResult.status == false {
            exit(8)
        }
        YLLOG.info("推送变更")
        scriptResult = YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", newBranchName], showOutData: true))
        if scriptResult.status == false {
            exit(8)
        }

        YLLOG.info("Git提交成功")

    }


}
