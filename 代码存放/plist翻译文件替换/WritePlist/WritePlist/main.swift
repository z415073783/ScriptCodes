//
//  main.swift
//  WritePlist
//
//  Created by zlm on 2018/8/17.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
import SwiftShellFramework
let help = """
-----------------------------------
需要传入资源文件路径和新的language文件路径
例:writePlist -resource=/User/language.plist -new=/User/newLanguage.plist 
-----------------------------------
"""
let arguments = ProcessInfo.processInfo.getDictionary()
YLLOG.info("arguments = \(arguments)")
if ( arguments.count == 0 || arguments["h"] != nil ) {
    YLLOG.log(help)
    exit(0)
}
YLLOG.info("---1")
guard let newLanguagePath = arguments["new"], let languagePath = arguments["resource"] else {
    YLLOG.error("参数传入错误\n\(help)")
    exit(1)
}

YLLOG.info("---2")

//let newLanguagePath = "/Users/zlm/Desktop/脚本/plist翻译文件替换/WritePlist/WritePlist/NewYLLanguage.plist"
//let languagePath = "/Users/zlm/Desktop/脚本/plist翻译文件替换/WritePlist/WritePlist/YLLanguage.plist"


guard let newLanguageData = NSDictionary(contentsOfFile: newLanguagePath), var resourceData = NSMutableDictionary(contentsOfFile: languagePath) as? [String: [String: [String: String]]] else {
    YLLOG.error("文件数据转NSDictionary失败")
    exit(1)
}
YLLOG.info("---3")
//备份原有数据
var isFinish = (resourceData as NSDictionary).write(toFile: languagePath + "backup", atomically: true)
if isFinish == false {
    YLLOG.error("数据备份失败")
    exit(2)
}
YLLOG.info("---4")

guard let newData = newLanguageData.value(forKey: "Language") as? [String: [String: String]] else {
    YLLOG.error("newLanguagePath文件数据错误")
    exit(3)
}
YLLOG.info("---5")
guard var resource = resourceData["Language"] else {
    exit(4)
}
YLLOG.info("---6")
var changeList: [String: [String: [String: String]]] = [:]
//
var checkList: [String: [String: [String: String]]] = [:]
YLLOG.info("---7")
for (key, newValue) in newData {
    if let resValue = resource[key] {
        //如果要替换的翻译在resource中有key,则检查每一项是否有变化,有变化则替换,并生成变更列表
        var changeItem: [String: [String: String]] = [:]
        for (lanKey, lanItem) in resValue {
            if let newLanItem = newValue[lanKey] {
                if newLanItem != lanItem {
                    //检查特殊符号@数量是否一致
                    let result = lanItem.regularExpressionFind(pattern: "\\@")
                    if result.count > 0 {
                        let newResult = newLanItem.regularExpressionFind(pattern: "\\@")
                        if newResult.count != result.count {
                            //@数量不一致,需要检查是否翻译有误
                            if checkList[key] != nil {
                                checkList[key]?[lanKey] = ["原始数据": lanItem, "修改后": newLanItem]
                            } else {
                                var checkItem: [String: [String: String]] = [:]
                                checkItem[lanKey] = ["原始数据": lanItem, "修改后": newLanItem]
                                checkList[key] = checkItem
                            }

//                            continue
                        }
                    }

                    //如果和原来的值不一样,则更换为新值
                    resourceData["Language"]![key]![lanKey] = newLanItem
//                    resValue[lanKey] = newLanItem
                    //保存修改列表
                    changeItem[lanKey] = ["原始数据": lanItem, "修改后": newLanItem]
                }
            }
        }
        if changeItem.count > 0 {
            changeList[key] = changeItem
        }
    }
}


YLLOG.info("---8")
YLLOG.info("变更数据 changeList = \(changeList)")
YLLOG.info("检查格式 checkList = \(checkList)")
if changeList.count == 0 {
    YLLOG.info("未做任何变更")
    exit(0)
}
//保存新数据
if FileManager.default.fileExists(atPath: languagePath) {
    do {
        try FileManager.default.removeItem(atPath: languagePath)
    }catch {
        YLLOG.error("删除文件失败")
    }
}

isFinish = (resourceData as NSDictionary).write(toFile: languagePath, atomically: true)
if isFinish == false {
    YLLOG.error("数据保存失败")
    exit(5)
}

guard let path = newLanguagePath.getPath() else {
    exit(6)
}
isFinish = (changeList as NSDictionary).write(toFile: path + "/changePlist.plist", atomically: true)
if isFinish == false {
    YLLOG.error("修改数据保存失败1")
    exit(7)
}
if checkList.count > 0 {
    isFinish = (checkList as NSDictionary).write(toFile: path + "/checkList.plist", atomically: true)
    if isFinish == false {
        YLLOG.error("修改数据保存失败2")
        exit(7)
    }
}

exit(0)


