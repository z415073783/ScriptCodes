//
//  main.swift
//  VCPropertySetup
//
//  Created by zlm on 2019/1/23.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation

YLLOG.info("--------VCPropertySetup--------")

//ProcessInfo.processInfo.isHelp(helpStr: """
//    propertyPath      property文件路径
//    projectPath       项目根路径
//""")
//
//let data = ProcessInfo.processInfo.getDictionary()
////读取property文件
////找到项目根路径
//guard let propertyPath = data["propertyPath"], let projectPath = data["projectPath"] else {
//    exit(1)
//}

let projectPath = "/Users/zlm/Documents/VCM_UI_IOS原始代码/Odin-YMS"
let propertyPath = "/Users/zlm/Library/Developer/Xcode/DerivedData/VCPropertySetup-bztbupumfezwjjfmdhhshcqwvxep/Build/Products/Debug/Oem需求/Property.plist"


let dic = NSDictionary(contentsOfFile: propertyPath)
if let iniDic: [String: String] = dic?.value(forKey: "ini") as? [String : String] {
    ReplaceIni.setup(data: iniDic, projectPath: projectPath)
}

if let infoDic: [String: String] = dic?.value(forKey: "Info") as? [String : String] {
    ReplaceInfo.setup(data: infoDic, projectPath: projectPath)
}
if let languageDic: [String: [String: String]] = dic?.value(forKey: "Language") as? [String : [String: String]] {
    ReplaceLanguage.setup(data: languageDic, projectPath: projectPath)
}






