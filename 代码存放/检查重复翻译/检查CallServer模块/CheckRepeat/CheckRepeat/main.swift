//
//  main.swift
//  CheckRepeat
//
//  Created by zlm on 2017/12/4.
//  Copyright © 2017年 zlm. All rights reserved.
//

import Foundation

print("Hello, World!")

let fileList = FileControl.getSubPaths(path: "/Users/zlm/Desktop/脚本/检查重复翻译/CallServer") //目标文件夹
let fileName = "YLSDKLanguage" //Language类
var languageSwiftPath = "\(fileName).swift"  //需要忽略的文件名
var rootPath = "/Users/zlm/Desktop/脚本/检查重复翻译" //翻译文件目录
var languagePlistPath = "\(rootPath)/YLSDKLanguage.plist" //翻译文件路径


var languageList: [String] = [] //结果列表
for item in fileList {
    if item.hasSuffix(".plist") || item.hasSuffix(".bundle") {
        continue
    }
    if item.hasSuffix(languageSwiftPath) {
        languageSwiftPath = item
        continue
    }

    do {
        let data = try String(contentsOfFile: item)
        let resultList = data.regularExpressionData(pattern: String("\(fileName)\\.[a-zA-Z]{1,}"))
        for result in resultList {
            let resultStr = (data as NSString).substring(with: result.range)
            if resultStr.hasSuffix(".plist") || resultStr.hasSuffix(".bundle") || resultStr == "\(fileName).swift" {
                continue
            }
//            print("result = \(resultStr)")
            languageList.append(resultStr)
        }

    }catch {

    }
}

//languageSwiftPath //文件对照路径
let data = try String(contentsOfFile: languageSwiftPath)
//print("data = \(data)")
//languageList
var keyList: [String] = [] //实际key值列表
for item in languageList {
    let list = item.components(separatedBy: ".")
    if list.count < 2 {
        continue
    }
    let key = list[1]
    let selectStr = "public static var \(key): String = .*\\n?"
    let regularList = data.regularExpressionData(pattern: selectStr)
    for result in regularList {
        let resultStr = (data as NSString).substring(with: result.range)


        let componentList = resultStr.components(separatedBy: "\"")
        var finalStr = ""
        for i in 1 ..< (componentList.count - 1) {
            if i > 1 {
                finalStr += "\""
            }
            finalStr += componentList[i]
        }
        keyList.append(finalStr)
    }
}

//print("result = \(keyList)")

var languagePlist = NSDictionary(contentsOfFile: languagePlistPath)
var languageData = languagePlist?.value(forKey: "Language") as! [String: [String: String]]
var writeList: [String: [String: String]] = [:]
for item in keyList {
    if let result = languageData[item] {
        writeList[item] = result
    }
}
var finalData: [String: [String: [String: String]]] = [:]
finalData["Language"] = writeList
let isSuccess = (finalData as NSDictionary).write(toFile: "\(rootPath)/newLanguage.plist", atomically: true)
print("isSuccess = \(isSuccess)")
print("--end--")




//do {
//    let str = try String(contentsOfFile: "/Users/zlm/Desktop/脚本/Odin-YMS/Odin-YMS/Configure/AppDelegate.swift")
//    print("str = \(str)")
//}catch {
//
//}

