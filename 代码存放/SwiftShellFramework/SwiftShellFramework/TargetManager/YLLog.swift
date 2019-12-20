//
//  YLLog.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
//import os
public class YLLOG: NSObject {
    public enum LogLevel: String {
        case log = "log", info = "info", error = "err", exception = "exception"
    }
    public static let shared = YLLOG()
    public var staticStr: StaticString = StaticString()
    public var logs: String = ""
    public class func info( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.info)
    }

    public class func error( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.error)
    }

    public class func except( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.exception)
    }
    public class func log( _ closure: @autoclosure () -> String?) {
        let str = closure()
        print("\(str ?? "")")
    }

    public class func log( _ closure: @autoclosure () -> String?, level: LogLevel = .log) {
        let str = closure()
        let beginTime = showLogDate(timeInterval: Date().timeIntervalSince1970)
        let _log = "\(beginTime) [\(level.rawValue)] \(str ?? "")"
        print(_log)
        shared.logs += "\(_log)\n"
//        os_log(shared.staticStr, log)
//        fread(&log, 1, 1, stdout)
    }



}

