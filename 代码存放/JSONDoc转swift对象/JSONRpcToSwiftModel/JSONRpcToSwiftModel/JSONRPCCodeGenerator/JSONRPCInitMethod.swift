//
//  JSONRPCInitMethod.swift
//  JSONRpcToSwiftModel
//
//  Created by zlm on 2019/2/12.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
class JSONRPCInitMethod {
    class func addInitMethod(originalStr: String, regular: String = "public struct Input: YLJSONCodable(.|\\n)*?\\}", t: Int = 1) -> String {
        var _originalStr = (originalStr as NSString)
        YLLOG.info("regular = \(regular)")
        var tNumber = ""
        for i in 0 ..< t {
            tNumber += "\t"
        }

        let resultList = originalStr.regularExpressionFind(pattern: regular)
        for i in (0 ..< resultList.count).reversed() {

            var initMethod = "\tpublic init("
            var initParams = " {\n"

            let item = resultList[i]
            let subStr = (originalStr as NSString).substring(with: item.range)
            let paramsList = subStr.regularExpressionFind(pattern: "public var .*:.*\\?")
            for j in 0 ..< paramsList.count {
                let onceParam = paramsList[j]
                let paramStr = (subStr as NSString).substring(with: onceParam.range)
                let paramSplit = paramStr.split(":")
                let first = paramSplit.first
                let value = paramSplit.last ?? ""
                let key = first?.split(" ").last ?? ""

                initMethod += "\(key):\(value)"
                if j < paramsList.count - 1 {
                    initMethod += ", "
                }
                initParams += "\t\(tNumber)\tself.\(key) = \(key)\n"
            }
            initMethod += ")"
            initParams += "\t\(tNumber)}\n\(tNumber)"

            initMethod += initParams

            //TODO: 应该放}里面
            _originalStr = _originalStr.replacingCharacters(in: NSRange(location: item.range.location + item.range.length - 1, length: 0), with: initMethod) as NSString
        }

        return _originalStr as String
    }
}


