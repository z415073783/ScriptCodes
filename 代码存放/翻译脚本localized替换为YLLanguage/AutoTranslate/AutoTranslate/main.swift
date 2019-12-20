//
//  main.swift
//  AutoTranslate
//
//  Created by zlm on 2019/1/17.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation

print("------自动翻译脚本------")

let helpStr =
"""
需要传入以下两个参数:
languagePlist    YLLanguage.plist路径
"""
ProcessInfo.processInfo.isHelp(helpStr: helpStr)

let paramsDic = ProcessInfo.processInfo.getDictionary()
guard let languagePlist = paramsDic["languagePlist"] else {
    YLLOG.error("未传入指定参数!")
    exit(1)
}
//let languagePlist = "/Users/zlm/Documents/Share/logs/YLLanguage.plist"
//读取翻译数据
func readLanguageData() -> [String: [String: [String: String]]] {
    guard let Dic: [String: [String: [String: String]]] = NSDictionary(contentsOfFile: languagePlist) as? [String: [String: [String: String]]] else {
        YLLOG.error("翻译数据格式转换失败")
        return [:]
    }
    return Dic
}
var data = readLanguageData()
YLLOG.info("data = \(data)")

guard let languageData = data["Language"] else {
    exit(2)
}

for (key, value) in languageData {
    guard let zh = value["zh-Hans"] else {
        YLLOG.error("未找到中文翻译! key = \(key)")
        continue
    }
    //如果有特殊字符,则不做翻译
    let result = zh.regularExpressionFind(pattern: "%")
    if result.count > 0 {
        YLLOG.info("------------待翻译文本zh = \(zh) 包含%符号--------------")
        continue
    }

    let esValue = value["es"]
    if esValue == nil || esValue?.count == 0 {
        if let jsonStr = BaiduTranslateManager.getEnglishTranslate(src: zh, to: .西班牙语), let es = BaiduTranslateManager.getTranslateResult(jsonStr: jsonStr) {
            data["Language"]?[key]?["es"] = es
        }
    }
    let zhtValue = value["zh-Hant"]
    if zhtValue == nil || zhtValue?.count == 0 {
        if let jsonStr = BaiduTranslateManager.getEnglishTranslate(src: zh, to: .繁体中文), let zht = BaiduTranslateManager.getTranslateResult(jsonStr: jsonStr) {
            data["Language"]?[key]?["zh-Hant"] = zht
        }
    }
    let enValue = value["en"]
    if enValue == nil || enValue?.count == 0 {
        if let jsonStr = BaiduTranslateManager.getEnglishTranslate(src: zh, to: .英语), let en = BaiduTranslateManager.getTranslateResult(jsonStr: jsonStr) {
            data["Language"]?[key]?["en"] = en
        }
    }
}

NSDictionary(dictionary: data).write(toFile: languagePlist, atomically: true)

