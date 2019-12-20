//
//  main.swift
//  LanguageTranslate
//
//  Created by zlm on 2018/7/10.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation

print("Hello, World!")

let helpStr =
"""
需要传入以下两个参数:
    languagePlist    YLLanguage.plist路径
    languageSwift    YLLanguage.swift路径
"""
ProcessInfo.processInfo.isHelp(helpStr: helpStr)

let paramsDic = ProcessInfo.processInfo.getDictionary()
guard let languagePlist = paramsDic["languagePlist"], let YLLanguagePath = paramsDic["languageSwift"] else {
    YLLOG.error("未传入指定参数!")
    exit(1)
}
//测试
//let languagePlist = "/Users/zlm/Documents/VCM_UI_IOS原始代码/Odin-YMS/Odin-YMS/Resource/Language/YLLanguage.plist"
//let YLLanguagePath = "/Users/zlm/Documents/VCM_UI_IOS原始代码/Odin-YMS/Odin-YMS/Resource/Language/YLLanguage.swift"

guard let model = FileControl.getProjectPath(plistPath: languagePlist) else {
    YLLOG.error("未能找到.xcworkspace工程文件所在目录")
    exit(2)
}
let projectPath = model.path
//let languagePlist = kShellPath + "/../Odin-UC/Resource/Language" + "/YLLanguage.plist"
//let YLLanguagePath = kShellPath + "/../Odin-UC/Resource/Language/YLLanguage.swift"

//读取翻译数据
func readLanguageData() -> [String: [String: [String: String]]] {
    guard let Dic: [String: [String: [String: String]]] = NSDictionary(contentsOfFile: languagePlist) as? [String: [String: [String: String]]] else {
        YLLOG.error("翻译数据格式转换失败")
        return [:]
    }
    return Dic
}

//获取所有swift路径
func traverse(path: String) -> [String] {
    var subList: [String] = []
    do {
        let list = try FileManager.default.contentsOfDirectory(atPath: path)
        for item in list {
            let subPath = path + "/" + item
            if item == "Pods" { //过滤Pods文件夹
                continue
            }
            var isDirectory: ObjCBool = ObjCBool(false)
            if FileManager.default.fileExists(atPath: subPath, isDirectory: &isDirectory) {
                if isDirectory.boolValue == true {
                    subList += traverse(path: subPath)
                } else {
                    if item.hasSuffix(".swift") , item != "YLLanguage.swift", item != "LanguageManager.swift" {
                        subList.append(subPath)
                    }
                }
            }
        }
        return subList
    } catch {
        YLLOG.error("error = \(error)")
    }
    return subList
}

func BeginTranslate() {

    var languageData = readLanguageData()

    //发现中文并转成对应key
    func findkey(param: String) -> String? {
        guard let data = languageData["Language"] else {
            YLLOG.info("Language数据获取失败")
            return nil
        }
        for (key, value) in data {
            if param == key {
                return key
            }
            if let chinese = value["zh-Hans"] {
                if chinese == param {
                    return key
                }
            }
        }
        return nil
    }

    let fileList = traverse(path: projectPath)
    YLLOG.info("fileList.count = \(fileList.count)")

    var replaceDic: [String: [String: String]] = [:]
    var noDataDic: [String: [String: String]] = [:]

    //遍历出所有localized
    func getLocalizedPosition() {
        //    var languagePositionList: [NSTextCheckingResult]
        do {
            //获取YLLanguage.swift
            let languageSwift = try String(contentsOfFile: YLLanguagePath, encoding: String.Encoding.utf8)
            // YLLanguage每个变量数据
            let languageResultList = languageSwift.regularExpressionFind(pattern: "public static.*?\\)")


            for item in fileList {
                let fileData = try String(contentsOfFile: item, encoding: String.Encoding.utf8)
                let saveData = NSMutableString(string: fileData)
                let resultList = fileData.regularExpressionFind(pattern: "localized\\(.*?\\)")
                //倒序处理
                for result in resultList.reversed() {
                    let range = result.range
                    let fileStr = NSMutableString(string: fileData)
                    var newStr: String?
                    let subStr = fileStr.substring(with: range) as String
                    if (subStr as NSString).contains("The network is not available") {
                        YLLOG.info("包含 The network is not available")
                    }
                        //                    , subStr?.hasPrefix("localized(key: \"")
                    newStr = subStr.regularExpressionReplace(pattern: "localized\\(\\s{0,}\"", with: "")
//                    newStr = newStr?.regularExpressionReplace(pattern: "\"\\)$", with: "")
                    newStr = newStr?.regularExpressionReplace(pattern: "\"\\s{0,}\\)$", with: "")
                    //需要查找的字符串
                    YLLOG.info("newStr = \(newStr ?? "")")

                    //先查找中文字符
                    if let _newStr = newStr {
                        let key = findkey(param: _newStr)

                        if let _key = key {
                            //存在对应的key
                            newStr = _key
                            var isExist = false
                            //根据newStr获取到对应的变量
                            for languageResult in languageResultList {
                                let languageStr = NSMutableString(string: languageSwift)
                                if let keyData = languageStr.substring(with: languageResult.range) as? NSString, let valueStr = newStr {
                                    let languageRange = keyData.range(of: "\"\(valueStr)\"")
                                    if languageRange.length > 0 {
                                        var targetValue: String? = keyData.replacingOccurrences(of: "public static var ", with: "")
                                        targetValue = targetValue?.regularExpressionReplace(pattern: ": String =.*", with: "")

                                        //                                    目标变量替换localized方法
                                        if let _targetValue = targetValue {
                                            saveData.replaceCharacters(in: range, with: "YLLanguage." + _targetValue)
                                            //替换
                                            if replaceDic[item] == nil {
                                                replaceDic[item] = [:]
                                            }
                                            isExist = true
                                            replaceDic[item]![_newStr] = targetValue
                                        } else {
                                            YLLOG.error("targetValue获取失败")
                                        }
                                    }
                                } else {
                                    YLLOG.error("获取数据失败 languageStr = \(languageStr), newStr = \(newStr)")
                                }
                            }
                            if isExist == false {
                                //未找到对应的key
                                //TODO:
                                YLLOG.info("未找到对应的key: \(_newStr)")
                                noDataDic[_newStr] = ["en": "", "es": "", "zh-Hans": _newStr, "zh-Hant": ""]
                            }

                        } else {
                            //                        不存在
                            YLLOG.info("plist文件中不存在该字符串: \(newStr)")
                            //TODO:
                            noDataDic[_newStr] = ["en": "", "es": "", "zh-Hans": _newStr, "zh-Hant": ""]
                        }

                        if !(_newStr as NSString).hasPrefix("localized(") {
                            let str = _newStr.regularExpressionReplace(pattern: "\\\\", with: "\\") ?? _newStr
//                            过滤\符号

                            //                        过滤localized
                            //保存到language.plist
                            var isExist = false
                            for (itemKey, _) in languageData["Language"] ?? [:] {
                                if itemKey == str {
                                    isExist = true
                                }
                            }
                            if isExist == false {
                                languageData["Language"]?[str] = ["en": "", "es": "", "zh-Hans": str, "zh-Hant": ""]
                            }
                        }
                    }
                }
                //保存数据
                let saveStr = saveData as String
                try saveStr.write(toFile: item, atomically: true, encoding: String.Encoding.utf8)
            }
        } catch {
            YLLOG.error("error = \(error)")
        }
    }
    getLocalizedPosition()

    let array = NSDictionary(dictionary: noDataDic)
    let dic = NSDictionary(dictionary: replaceDic)
    let savePath = (languagePlist.getPath() ?? kShellPath) + "/changeLanguage"
    YLLOG.info("修改列表保存路径: = \(savePath)")
    do {
        if !FileManager.default.fileExists(atPath: savePath){
            try FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: true, attributes: nil)
        }
        array.write(toFile: savePath + "/needAddValue.plist", atomically: true)
        dic.write(toFile: savePath + "/changeRecord.plist", atomically: true)
    } catch {
        YLLOG.error("error = \(error)")
    }
    (languageData as NSDictionary).write(toFile: languagePlist, atomically: true)

}

//调用翻译
YLLOG.info("运行翻译脚本")
BeginTranslate()


//将plist写入swift 查找并调用MainPlistToSwift.command  kPythonPath
//
if let plistRootPath = languagePlist.getPath() {
//    let list = FileControl.getFilePath(rootPath: plistRootPath, selectFile: "MainPlistToSwift.command", isSuffix: false, onlyOne: true)
    let pythonScriptList = FileControl.getFilePath(rootPath: plistRootPath, selectFile: "swift_language.py", isSuffix: false, onlyOne: true)
    if let pythonScript = pythonScriptList.first {
        //找到脚本  let first = list.first,
//        YLScript.runScript(model: ScriptModel(path: kEnvPath, arguments: [first.fullPath()], scriptRunPath: plistRootPath))
        YLLOG.info("调用swift_language.py脚本")
        YLScript.runScript(model: ScriptModel(path: kPython3Path, arguments: [pythonScript.fullPath(), "--2swift", "-l", plistRootPath, "-p", languagePlist, "-s", YLLanguagePath], scriptRunPath: plistRootPath))

        //再次运行
        YLLOG.info("再次运行翻译脚本")
        BeginTranslate()
    }
}












