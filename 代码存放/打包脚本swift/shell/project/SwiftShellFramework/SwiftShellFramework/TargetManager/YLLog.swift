//
//  YLLog.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
class YLLOG: NSObject {
    enum LogLevel: String {
        case log = "log", info = "info", error = "err", exception = "exception"
    }
    static let getInstance = YLLOG()
    var logs: String = ""
    class func info( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.info)
    }

    class func error( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.error)
    }

    class func except( _ closure: @autoclosure () -> String?) {
        log(closure, level: YLLOG.LogLevel.exception)
    }


    class func log( _ closure: @autoclosure () -> String?, level: LogLevel = .log) {
        let str = closure()
        let beginTime = showLogDate(timeInterval: Date().timeIntervalSince1970)
        print("\(beginTime) [\(level.rawValue)] \(str ?? "")")
    }

}

