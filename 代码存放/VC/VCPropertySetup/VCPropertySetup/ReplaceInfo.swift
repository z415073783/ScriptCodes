//
//  ReplaceInfo.swift
//  VCPropertySetup
//
//  Created by zlm on 2019/1/23.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
class ReplaceInfo {
    class func setup(data: [String : String], projectPath: String) {
        let list = FileControl.getFilePath(rootPath: projectPath, selectFile: "Info.plist", isSuffix: false, onlyOne: false, recursiveNum: 1)
        for fileModel in list {
            let dic = NSMutableDictionary(contentsOfFile: fileModel.fullPath())
            for (key,value) in data {
                if ((dic?.value(forKey: key)) != nil) {
                     dic?.setValue(value, forKey: key)
                } else {
                    YLLOG.error("未发现对应的key = \(key) fileModel.fullPath() = \(fileModel.fullPath())")
                }
            }
            let isBool = dic?.write(toFile: fileModel.fullPath(), atomically: true)
            YLLOG.info("isBool = \(String(describing: isBool)) fileModel.fullPath() = \(fileModel.fullPath())")
        }
    }
}
