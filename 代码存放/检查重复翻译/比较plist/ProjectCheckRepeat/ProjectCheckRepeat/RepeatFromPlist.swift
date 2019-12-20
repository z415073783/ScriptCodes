//
//  RepeatFromPlist.swift
//  ProjectCheckRepeat
//
//  Created by zlm on 2017/12/4.
//  Copyright © 2017年 zlm. All rights reserved.
//

import Foundation
func repeatPlistData() {
    let localPath = Bundle.main.bundlePath
    let mainLanguagePlistPath =  "\(localPath)/YLLanguage.plist"//主要plist
    var mainLanguagePlist: [String: [String: [String: String]]] = NSMutableDictionary(contentsOfFile: mainLanguagePlistPath) as! [String: [String: [String: String]]]
    var checkData: [String: [String: String]] = [:]
    var repeatData: [String: [String: String]] = [:]
    for (mainKey, mainValue) in mainLanguagePlist["Language"]! {
        guard let value = mainValue["en"] else {
            return
        }
        if checkData[value] == nil {
            checkData[value] = mainValue
        }else {
            repeatData[mainKey] = mainValue
            print("mainKey = \(mainKey)")
        }


    }
//    print("checkData = \(checkData)")
//    print("repeatData = \(repeatData)")



}
