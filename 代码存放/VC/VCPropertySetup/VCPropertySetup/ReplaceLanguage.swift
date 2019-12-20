//
//  ReplaceLanguage.swift
//  VCPropertySetup
//
//  Created by zlm on 2019/1/23.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
class ReplaceLanguage {
    class func setup(data: [String : [String : String]], projectPath: String) {
        let list = FileControl.getFilePath(rootPath: projectPath, selectFile: "YLLanguage.plist", isSuffix: false, onlyOne: true)
        for fileModel in list {
            let dic = NSMutableDictionary(contentsOfFile: fileModel.fullPath())
            let languageDic = dic?.value(forKey: "Language") as? NSMutableDictionary
            for (key,value) in data {
                if ((languageDic?.value(forKey: key)) != nil) {
                    languageDic?.setValue(value, forKey: key)
                } else {
                    YLLOG.error("未发现对应的key = \(key) fileModel.fullPath() = \(fileModel.fullPath())")
                }
            }
            dic?.setValue(languageDic, forKey: "Language")
            let isBool = dic?.write(toFile: fileModel.fullPath(), atomically: true)
            YLLOG.info("isBool = \(String(describing: isBool)) fileModel.fullPath() = \(fileModel.fullPath())")
        }
    }
}
