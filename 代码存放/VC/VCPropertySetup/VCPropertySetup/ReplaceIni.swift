//
//  ReplaceIni.swift
//  VCPropertySetup
//
//  Created by zlm on 2019/1/23.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
class ReplaceIni {
    class func setup(data: [String : String], projectPath: String) {
        let list = FileControl.getFilePath(rootPath: projectPath, selectFile: ".ini", isSuffix: true, onlyOne: false)
        for (key,value) in data {
            for fileModel in list {
                do {
                    let fileData = try String(contentsOfFile: fileModel.fullPath(), encoding: String.Encoding.utf8)
                    let newData = fileData.regularExpressionReplace(pattern: "\(key) =.*", with: "\(key) = \(value)")
                    try newData?.write(toFile: fileModel.fullPath(), atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    YLLOG.error("error = \(error)")
                }
            }
        }
    }
}
