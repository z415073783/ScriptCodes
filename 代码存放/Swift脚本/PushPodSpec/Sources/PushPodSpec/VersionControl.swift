//
//  VersionControl.swift
//  PushPodSpec
//
//  Created by zlm on 2019/9/17.
//

import Foundation
import MMScriptFramework
class VersionControl {
    class func getLastTag(gitUrl: String, branch: String, projectRootPath: String) -> String? {
        
        //git fetch --tags 拉取分支上最新的tag
        var result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["fetch", "--tags"], scriptRunPath: projectRootPath))
        if (result.status == false) {
            MMLOG.error("拉取tag失败")
            return nil
        }
        //git tag -l -n  打印所有tag列表
        result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["tag"], scriptRunPath: projectRootPath, showOutData: true))
        MMLOG.info("打印所有tag列表 = \(result)")
//        var tag = result.output ?? ""
        
        var tagData: [String] = []
        result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["rev-list", "--tags", "--max-count=1"], scriptRunPath: projectRootPath, showOutData: true))
        if let output = result.output, let tagDes = output.split("\n").last {
            result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["describe", "--tags", tagDes], scriptRunPath: projectRootPath, showOutData: true))
            var lastVersion = result.output ?? "1.0.0"
            lastVersion = lastVersion.split("\n").first ?? lastVersion
            tagData = lastVersion.split(".")
        }
        
        if tagData.count == 0 {
            MMLOG.error("版本号识别错误")
            exit(17)
        }
        
        MMLOG.info("打印最新tagData = \(tagData)")
        var tag = ""
        for i in 0 ..< tagData.count {
            if i == tagData.count - 1 {
                tag += String(((Int(tagData[i]) ?? 0) + 1))
            } else {
                tag += tagData[i]
            }
            
            if i < tagData.count - 1 {
                tag += "."
            }
        }
        MMLOG.info("自增后 = \(tag)")

        
        return tag
    }
    
}
