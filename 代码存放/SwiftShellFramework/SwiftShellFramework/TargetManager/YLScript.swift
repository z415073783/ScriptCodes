//
//  YLScript.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public struct ScriptModel {
    public var path: String = ""
    public var arguments: [String] = []
    public var scriptRunPath: String?  //脚本运行目录
    public var showOutData: Bool = false
    public var isQuiet = false
    public init(path: String, arguments: [String] = [], scriptRunPath: String? = nil, showOutData: Bool = false, isQuiet: Bool = false) {
        self.path = path
        self.arguments = arguments
        self.scriptRunPath = scriptRunPath
        self.showOutData = showOutData
        self.isQuiet = isQuiet
    }
}
public struct ScriptResult {
    public var status: Bool = true
    public var output: String?
    public var error: String?
    public var terminationStatus: Int32 = 0

}
public typealias ScriptOutput = String
public class YLScript {
    static let shared = YLScript()
    //设置执行目录
    @discardableResult public class func runScript(model: ScriptModel) -> ScriptResult {


        let task = Process()
        if !model.isQuiet {
            YLLOG.info("执行脚本 path = \(model.path)\n arguments = \(model.arguments)")
        }

        //        YLLOG.info("task.currentDirectoryPath 原始路径 = \(task.currentDirectoryPath)")
        if let runPath = model.scriptRunPath {
            task.currentDirectoryPath = runPath
        }
        //
        task.launchPath = model.path
        task.arguments = model.arguments
        let outpipe = Pipe()
        let errpipe = Pipe()
        if model.showOutData == true {
            task.standardOutput = outpipe
            task.standardError = errpipe
        }
        do {
            try task.run()
        } catch {
            YLLOG.error("error = \(error)")
        }
//        task.launch()
        task.waitUntilExit()
        
        var result: ScriptResult = ScriptResult()

        if model.showOutData == true {
            let outData = (task.standardOutput as? Pipe)?.fileHandleForReading.readDataToEndOfFile()
            let outPutString = String(data: outData ?? Data(), encoding: .utf8)
            if let _outPutString = outPutString, _outPutString.count > 0 {
                YLLOG.info(_outPutString)
                result.output = _outPutString
            }
            let errData = (task.standardError as? Pipe)?.fileHandleForReading.readDataToEndOfFile()
            let errString = String(data: errData ?? Data(), encoding: .utf8)
            if let _errString = errString, _errString.count > 0 {
                YLLOG.error("调试信息: \(_errString)")
                result.error = _errString
            }
        }

        if task.terminationStatus == 0 {
             result.status = true
            return result
        }
        if !model.isQuiet {
            YLLOG.info("脚本运行失败! model.path = \(model.path), task.terminationStatus = \(task.terminationStatus)")
            YLLOG.info("task.currentDirectoryPath路径 = \(task.currentDirectoryPath)")
        }
        result.status = false
        result.terminationStatus = task.terminationStatus
        return result
    }

    // 单次执行
    @discardableResult public class func runScript(path: String, arguments: [String] = [], _ showOutData: Bool? = false) -> Bool {
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
        task.waitUntilExit()
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
        YLLOG.info("task.terminationStatus = \(task.terminationStatus)")
        if task.terminationStatus == 0 {
            return true
        }
        return false
    }
}




