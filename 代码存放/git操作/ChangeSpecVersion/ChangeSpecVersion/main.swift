//
//  main.swift
//  ChangeSpecVersion
//
//  Created by zlm on 2018/8/9.
//  Copyright © 2018年 Yealink. All rights reserved.
//

import Foundation

var path = ""
var fileName = ""
let arguments = ProcessInfo.processInfo.arguments
if arguments.count < 2 {
    YLLOG.error("未传入正确的参数")
    exit(0)
}
let tag = arguments[1]
do {
    //获取.podspec文件路径
    let result = try FileManager.default.contentsOfDirectory(atPath: kShellPath)
    for item in result {
        if item.hasSuffix(".podspec") {
            path = kShellPath + "/" + item
            fileName = item
        }
    }
    if path.count == 0 {
        exit(0)
    }

    let str = try String(contentsOfFile: path)
    let regular = "s.version\\s{0,}=\\s{0,}\".*\""
    let newStr = str.regularExpressionReplace(pattern: regular, with: "s.version      = \"\(tag)\"")
    YLLOG.info("str = \(newStr ?? "")")
    try newStr?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
} catch {
    YLLOG.error("error = \(error)")
}


YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["add", "."], scriptRunPath: kShellPath, showOutData: true))
YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["commit", "-m", "【Chore】添加\(tag)"], scriptRunPath: kShellPath, showOutData: true))
YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["tag", "-a", tag, "-m", "【Chore】添加\(tag)"], scriptRunPath: kShellPath, showOutData: true))
YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "--tags", "master"], scriptRunPath: kShellPath, showOutData: true))
//YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "--tags"], scriptRunPath: kShellPath, showOutData: true))



let result = YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["spec", "lint", "--sources=ssh://git@appgit.yealink.com:10022/ios-dev/YLCocoaPods.git,https://github.com/CocoaPods/Specs.git", "--allow-warnings", "--verbose"], scriptRunPath: kShellPath, showOutData: true))
if result.status == false {
    exit(0)
}
YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["repo", "push", "YLCocoaPods", fileName, "--allow-warnings"], scriptRunPath: kShellPath, showOutData: true))








