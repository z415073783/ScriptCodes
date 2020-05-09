//
//  PodManager.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
let kPodsProjectPath = "Pods/" + kPodsProjectName
let kPodsProjectName = "Pods.xcodeproj"
class PodManager {
    class func checkPodsIsExist() -> Bool {
        if FileManager.default.fileExists(atPath: kProjectPath + "/" + kPodsProjectPath) {
            return true
        }
        return false
    }
    class func removeAllHistoryFiles() {
        do {
            let rootPath =  kProjectPath + "/Pods"
            let subFiles = try FileManager.default.contentsOfDirectory(atPath: rootPath)
            for item in subFiles {
                if kPodsProjectName != item {
                    try FileManager.default.removeItem(atPath: rootPath + "/" + item)
                    YLLOG.info("删除文件: \(item)")
                }
            }
        } catch {
            YLLOG.except("抛出异常: \(error)")
        }
    }

    class func updatePods() {
        YLScript.runScript(path: kCocoapodsShellPath, arguments: [kProjectPath])
    }
}

