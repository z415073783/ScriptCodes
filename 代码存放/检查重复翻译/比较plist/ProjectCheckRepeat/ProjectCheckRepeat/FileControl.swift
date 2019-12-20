//
//  FileControl.swift
//  CheckRepeat
//
//  Created by zlm on 2017/12/4.
//  Copyright © 2017年 zlm. All rights reserved.
//

import Foundation
class FileControl {
    class func getSubPaths(path: String) -> [String] {
        var filePaths: [String] = []
        do {
            let fileList = try FileManager.default.contentsOfDirectory(atPath: path)
            for fileName in fileList {
                var isDir: ObjCBool = true
                let fullPath = "\(path)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
                    }else {
                        filePaths += getSubPaths(path: fullPath)
                    }
                }
            }
            return filePaths
        } catch {
        }
        return []
    }
}

