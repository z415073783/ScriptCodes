//
//  ComparePlist.swift
//  ProjectCheckRepeat
//
//  Created by zlm on 2017/12/4.
//  Copyright © 2017年 zlm. All rights reserved.
// 比较两个plist文件重复翻译

import Foundation
func compare() {
    let localPath = Bundle.main.bundlePath
    let mainLanguagePlistPath =  "\(localPath)/YLLanguage.plist"//主要plist
    let secondLanguagePlistPath = "\(localPath)/SDKLanguage.plist"//次要plist
    var mainLanguagePlist: [String: [String: [String: String]]] = NSMutableDictionary(contentsOfFile: mainLanguagePlistPath) as! [String: [String: [String: String]]]
    var secondLanguagePlist: [String: [String: [String: String]]] = NSMutableDictionary(contentsOfFile: secondLanguagePlistPath) as! [String: [String: [String: String]]]

    for (mainKey, mainValue) in mainLanguagePlist["Language"]! {
        for (secondKey, secondValue) in secondLanguagePlist["Language"]! {
            if "SDK\(mainKey)" == secondKey {
                if mainValue["en"] == secondValue["en"] {
                    mainLanguagePlist["Language"]![mainKey] = nil
                    print("repead Data = \(mainKey)")
                }
            }
        }
    }
    (mainLanguagePlist as NSDictionary).write(toFile: mainLanguagePlistPath, atomically: true)
}
