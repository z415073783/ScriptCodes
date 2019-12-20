//
//  main.swift
//  JSONRpcToSwiftModel
//
//  Created by zlm on 2018/11/23.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation


//let helpInstruction = """
//jsonDocPath    jsonDoc.txt的文件路径
//ouputPath      输出文件的根目录位置
//"""
//
//ProcessInfo.processInfo.isHelp(helpStr:  helpInstruction)
//
//let dic = ProcessInfo.processInfo.getDictionary()
//
//guard let jsonDocPath = dic["jsonDocPath"], let ouputPath = dic["ouputPath"] else {
//    YLLOG.error("请传入参数: jsonDocPath 和 ouputPath")
//    exit(1)
//}


let jsonDocPath = "\(kShellPath)/jsonDoc.txt"
YLLOG.info("jsonDoc文件路径: \(jsonDocPath)")
let ouputPath = "."

let enumFilePath =  "\(ouputPath + "/" + kAPIsDirectoryName)/\(kRpcEnumFileName)"
let notificationFilePath =  "\(ouputPath + "/" + kAPIsDirectoryName)/\(kRpcNotificationFileName)"





var dataDic: NSDictionary?
do {
    let str = try NSString(contentsOfFile: jsonDocPath, encoding: String.Encoding.utf8.rawValue)
    YLLOG.info("str.count = \(str.length)")
    if let data = str.data(using: String.Encoding.utf8.rawValue) {
        let value = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        if let dic: NSDictionary = value as? NSDictionary {
            dataDic = dic
        }
    }
} catch {
    YLLOG.error("数据转化错误: error = \(error)")
}

guard let dataDic = dataDic else { exit(1) }

let codeGenerator = JSONRPCCodeGenerator()
let resultCode = codeGenerator.generateCode(dataDic)


exit(Int32(resultCode.rawValue))



