//
//  LogManager.swift
//  AutoPackageScript
//
//  Created by zlm on 2018/7/5.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation

public class LogManager {
    public static let shared = LogManager()
    public static let logDic = kShellPath + "/log"
    public static let logPath = logDic + "/systemLog"
    public var logNamePath: String? //log全路径
    public var logName: String? //log名字
    public class func logFreOpen(block: (_ logPath: String) -> Void) {
        do {
            if !FileManager.default.fileExists(atPath: logPath) {
                try FileManager.default.createDirectory(atPath: logPath, withIntermediateDirectories: true, attributes: nil)
            }
            let time = showNormalDate(timeInterval: Date().timeIntervalSince1970)
            let name = time + ".log"
            shared.logName = name
            let path = logPath + "/" + name
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            freopen(path.cString(using: String.Encoding.ascii), "a+", stdout)
            freopen(path.cString(using: String.Encoding.ascii), "a+", stderr)
            freopen(path.cString(using: String.Encoding.ascii), "a+", stdin)

            shared.logNamePath = path
            block(path)
        } catch  {
            YLLOG.info("error = \(error)")
        }
    }
    public class func readLogFile() -> String {
        guard let path = shared.logNamePath else {
            return ""
        }
        do {
            let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return data
        } catch {
            YLLOG.error("error = \(error)")
            return ""
        }
    }
}

