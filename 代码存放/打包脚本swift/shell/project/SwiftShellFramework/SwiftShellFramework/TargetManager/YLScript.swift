//
//  YLScript.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
struct ScriptModel {
    var path: String = ""
    var arguments: [String] = []
    var scriptRunPath: String?

    init(path: String, arguments: [String] = [], scriptRunPath: String? = nil) {
        self.path = path
        self.arguments = arguments
        self.scriptRunPath = scriptRunPath
    }
}


class YLScript {
    static let shared = YLScript()
//    let curTask = Process()
//    func runCurScript(path: String, arguments: [String] = []) -> Bool {
//        curTask.launchPath = path
//        curTask.arguments = arguments
//        curTask.launch()
//        YLLOG.info("task.terminationStatus = \(curTask.terminationStatus)")
//        if curTask.terminationStatus == 0 {
//            return false
//        }
//        return true
//    }
    //设置执行目录
    @discardableResult class func runScript(model: ScriptModel) -> Bool {
        let task = Process()
        YLLOG.info("连续执行脚本 path = \(model.path)\n arguments = \(model.arguments)")
        YLLOG.info("task.currentDirectoryPath = \(task.currentDirectoryPath)")
        if let runPath = model.scriptRunPath {
            task.currentDirectoryPath = runPath
        }
        YLLOG.info("task.currentDirectoryPath = \(task.currentDirectoryPath)")
        task.launchPath = model.path
        task.arguments = model.arguments
        task.launch()
        task.waitUntilExit()
        YLLOG.info("task.terminationStatus = \(task.terminationStatus)")
        if task.terminationStatus == 0 {
            return true
        }
        return false
    }

    // 单次执行
    @discardableResult class func runScript(path: String, arguments: [String] = [], _ showOutData: Bool? = false) -> Bool {
        YLLOG.info("scrpit: \(path)\nparams:\(arguments)")
        let task = Process()
        task.launchPath = path
        task.arguments = arguments
        let outpipe = Pipe()
        let errpipe = Pipe()
        if showOutData == true {
            task.standardOutput = outpipe
            task.standardError = errpipe
        }

        task.launch()
        if showOutData == true {
            let outData = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData
            let outPutString = String(data: outData ?? Data(), encoding: .utf8)
            if let _outPutString = outPutString, _outPutString.count > 0 {
                YLLOG.info(_outPutString)
            }
            let errData = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData
            let errString = String(data: errData ?? Data(), encoding: .utf8)
            if let _errString = errString, _errString.count > 0 {
                YLLOG.error(_errString)
            }
        }

        task.waitUntilExit()
        YLLOG.info("task.terminationStatus = \(task.terminationStatus)")
        if task.terminationStatus == 0 {
            return true
        }
        return false
    }
}




