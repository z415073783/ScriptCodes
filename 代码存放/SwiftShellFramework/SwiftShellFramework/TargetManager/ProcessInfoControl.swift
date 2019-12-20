//
//  ProcessInfoControl.swift
//  YLPackage
//
//  Created by zlm on 2018/8/16.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public extension ProcessInfo {
    //参数为: -key=value 格式
    public func getDictionary() -> [String: String] {
        var dic: [String:String] = [:]
        for item in arguments {
//            YLLOG.info("item = \(item)")
            if item.hasPrefix("-") {
                let list = item.split("=")
                if let first = list.first {
                    let key = (first as NSString).substring(with: NSRange(location: 1, length: first.count - 1))
                    let value = item.regularExpressionReplace(pattern: "-.*?=", with: "")
                    dic[key] = value
                }
            }
        }
        YLLOG.info("参数: = \(dic)")
        return dic
    }

//    public func isHelp(helpStr: String) -> Bool {
//        for item in arguments {
//            //            YLLOG.info("item = \(item)")
//            if item.hasPrefix("-") {
//                if item == "-h" || item == "help" || item == "-help"  {
//                    let detail = """
// --------------------------------------------------------
//参数结构: -key=value
//\(helpStr)
//----------------------------------------------------------
//"""
//                    print(detail)
//                    return true
//                }
//            }
//        }
//        return false
//    }

    public func isHelp(helpStr: String, needExit: Bool = true) {
        let detail = """
        --------------------------------------------------------
        参数结构: -key=value
        \(helpStr)
        ----------------------------------------------------------
        """
        print(detail)
        for item in arguments {
            //            YLLOG.info("item = \(item)")
            if item.hasPrefix("-") {
                if item == "-h" || item == "help" || item == "-help"  {
                    exit(0)
                }
            }
        }
    }
}
