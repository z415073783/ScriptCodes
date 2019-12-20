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
if (arguments.count == 1 || arguments.last == "-h") {
    YLLOG.info("参数为需要提交的版本号")
     YLScript.runScript(model: ScriptModel(path: kBashPath, arguments: ["addTag.sh", "-h"], showOutData: true))


    exit(0)
}
let tag = arguments[1]



//let podsPecPath = arguments[1]
do {
    let list = try FileManager.default.contentsOfDirectory(atPath: "./")
    for item in list {
        if item.hasSuffix(".podspec") {
            path = "./" + item
            fileName = item
        }
    }

    if fileName.count == 0 {
        YLLOG.error("未获取到.podspec文件")
        exit(1)
    }
    //获取.podspec文件路径
//    let result = try FileManager.default.contentsOfDirectory(atPath: kShellPath)
//    for item in result {
//        if item.hasSuffix(".podspec") {
//            path = kShellPath + "/" + item
//            fileName = item
//        }
//    }
//    if path.count == 0 {
//        exit(0)
//    }
//    fileName = name

    let str = try String(contentsOfFile: path)
    let regular = "s.version\\s{0,}=\\s{0,}\".*\""
    let newStr = str.regularExpressionReplace(pattern: regular, with: "s.version      = \"\(tag)\"")
    YLLOG.info("str = \(newStr ?? "")")
    try newStr?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)

    //提交代码
//    YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["add", "."], showOutData: true))
//    YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["commit", "-m", "【Chore】添加\(tag)"], showOutData: true))
    //提交tag
    YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["tag", "-a", tag, "-m", "【Chore】添加\(tag)"], showOutData: true))
    YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "--tags", "master"], showOutData: true))
    //YLScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "--tags"], scriptRunPath: kShellPath, showOutData: true))

//    let result = YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["spec", "lint", "--sources=ssh://git@appgit.yealink.com:10022/ios-dev/YLCocoaPods.git,https://github.com/CocoaPods/Specs.git", "--allow-warnings", "--verbose"], showOutData: true))
//    if result.status == false {
//        exit(2)
//    }
    YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["repo", "push", "YLCocoaPods", fileName, "--sources=ssh://git@appgit.yealink.com:10022/ios-dev/YLCocoaPods.git,https://github.com/CocoaPods/Specs.git", "--allow-warnings", "--verbose"], showOutData: true))





} catch {
    YLLOG.error("error = \(error)")
}







