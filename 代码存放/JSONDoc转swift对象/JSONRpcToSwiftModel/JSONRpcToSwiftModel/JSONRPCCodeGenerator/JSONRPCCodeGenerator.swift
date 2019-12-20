//
//  JSONRpcToSwiftConverter.swift
//  JSONRpcToSwiftModel
//
//  Created by yealink-dev on 2018/11/29.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation

/// 结果码
///
/// - success: 成功
/// - apisFieldInvalid: API数据问题
/// - notificationFieldInvalid: 通知字段数据问题
/// - enumFieldInvalid: 枚举字段数据问题
/// - structsFieldInvalid: 结构体字段数据问题
/// - dataNull: 空数据
enum ResultCode: Int {
    case success = 0
    case apisFieldInvalid = 1
    case notificationFieldInvalid = 2
    case enumFieldInvalid = 3
    case structsFieldInvalid = 4
    case dataNull = 5
}



/// RPC类文件代码生成器
class JSONRPCCodeGenerator: NSObject {

    /// 枚举类型缓存
    var enumCache: [String: String] = [:]

    /// 结构体类型缓存
    var structsCache: [String: String] = [:]


    /// 初始化方法
    ///
    /// - Parameter config: 配置
    init(_ config: JSONRPCCodeGenerateConfig? = nil) {
        if let unwrapConfig = config {
            self.config = unwrapConfig
        } else {
            self.config = JSONRPCCodeGenerateConfig.defaultConfig()
        }
        //清理
        print("**** 开始清理之前生成的文件 *****")
        do {
            try FileManager.default.removeItem(atPath: self.config.outputDirPath)
        } catch {
            YLLOG.info("删除原始文件夹失败 error = \(error)")
        }

        do {
            try FileManager.default.createDirectory(atPath: self.config.outputDirPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            YLLOG.info("创建保存文件夹失败 error = \(error)")
        }
    }

    /// 文件导出配置
    var config: JSONRPCCodeGenerateConfig = JSONRPCCodeGenerateConfig()

    /// 当前处理的API名
    var curApiCursorName = ""

    /// 枚举文件字符串内容
    var enumsContentBuffer: String = ""

    /// API类文件字符串内容
    var apisContentBuffer: String = ""

    /// 结构体文件字符串内容
    var structsConttentBuffer: String = ""

    /// 通知文件字符串内容
    var notificationsContentBuffer: String = ""


    /// 根据层级获取缩进空格
    ///
    /// - Parameter level: 层级
    /// - Returns: 缩进
    func getIndentByLevel(_ level: Int) -> String {
        var indent: String = ""
        for _ in 0 ..< level {
            indent += kTab
        }
        return indent
    }


    func getKeyPre(key: String) ->String {
        //  取首个enum值的前缀
        let keyList = key.split("_")
        var preKey = ""
        if keyList.count > 1 {
            preKey = keyList.first ?? ""
        }
        return preKey.uppercased()
    }


    // TODO: 通知缺少映射类模块的生成
    func generateNotificationCode(_ notifys: NSArray) -> ResultCode {
        if notifys.count == 0 {
            return .notificationFieldInvalid
        }

        apisContentBuffer = ""

        notificationsContentBuffer =  kRpcFileImportHeader

        for item in notifys {
            guard let itemDic = item as? NSDictionary,
                let name = itemDic.value(forKey: "name") as? String,
                let dataField = itemDic.value(forKey: "data") as? NSDictionary else {
                continue
            }

            // 类名
            curApiCursorName = name
            let className = convertNotifyNameToClassName(notifyName: name)

            // 类体内容
            var classDefBuffer =
            """
            public class \(className) {
            \(kTab)public static let name = Notification.Name("\(curApiCursorName)")

            """
            classDefBuffer += generateStructFromObject(object: dataField, indentLevel: 0)
            classDefBuffer +=
            """
            }\n\n
            """

            notificationsContentBuffer += classDefBuffer
        }

        let generateResult = generateNotifyFile()
        if generateResult != .success {
            return generateResult
        }

        return .success
    }




    /// 生成对应的property
    ///
    /// - Parameters:
    ///   - key: 参数名
    ///   - value: 参数类型
    ///   - indentLevel: 缩进级数
    /// - Returns: 生成的property字符串
    func generatePropertyDefWithoutDuplicated(key: String, value: NSObject, indentLevel: Int) -> String {
        var property = ""
        let levelData = getIndentByLevel(indentLevel)
        if let valueStr = value as? NSString {
            var typeName: String?
            if valueStr == "int" {
                typeName = "Int"
            } else if  valueStr == "uint64"{
                typeName = "UInt64"
            } else if valueStr == "uint"{
                typeName = "UInt"
            } else if valueStr == "int64" {
                typeName = "Int64"
            } else if valueStr == "double" {
                typeName = "Double"
            } else if valueStr == "" {
                typeName = "String"
            } else if valueStr as String == "[String]" {
                typeName = "[String]"
            } else if valueStr as String  == "[Int]" {
                typeName = "[Int]"
            } else if valueStr as String  == "[Int64]" {
                typeName = "[Int64]"
            } else if valueStr as String  == "[UInt]" {
                typeName = "[UInt]"
            } else if valueStr as String  == "[UInt64]" {
                typeName = "[Int64]"
            } else if (valueStr as String).hasPrefix("Rpc[") {
                typeName = (valueStr as String).regularExpressionReplace(pattern: "^Rpc", with: "")
            } else if valueStr.hasPrefix("Rpc") {
                typeName = valueStr as String
            } else  {

                // 识别是否为enum
                // 当前返回格式中 字段带【 , 】为enum类型
                let enumStrings = (valueStr as String).split(",")
                if enumStrings.count > 0 {

                    //MARK: 添加枚举类型
                    var onceEnumStr = ""
                    var onceEnumContainer = ""
                    for i in 0 ..< enumStrings.count {
                        let originalValue = enumStrings[i]
                        var lowercasedValue = originalValue.lowercased()
                        //value 过滤掉所有符号,只保留因为
                        lowercasedValue = lowercasedValue.regularExpressionReplace(pattern: "[^A-Za-z]{1,}", with: "_") ?? lowercasedValue
                        if i == 0 {
                            typeName = "\(kRpcEnumPre)\(getKeyPre(key: lowercasedValue))\(key)"
                        }
                        onceEnumContainer +=
                        """
                        \n\(kTab)case \(lowercasedValue) = "\(originalValue)"
                        """
                    }
                    var enumDefineLine = "public enum \(typeName ?? ""): String, YLJSONCodable"

                    //检查是否已存在
                    var enumExists = false
                    for (key, value) in enumCache {
                        if onceEnumContainer == value {
                            //已存在
                            enumExists = true
                            typeName = key
                        }
                    }
                    if !enumExists {

                        // 遍历Buffer，发现重名则添加数字后缀
                        let rangesOfSubStrExisted =  enumsContentBuffer.ranges(of: enumDefineLine)
                        if rangesOfSubStrExisted.count > 0 {
                            typeName = (typeName ?? "") + "\(rangesOfSubStrExisted.count)"
                        }
                        enumDefineLine = "public enum \(typeName ?? ""): String, YLJSONCodable"

                        onceEnumStr +=
                        """
                        \(enumDefineLine) {
                        """
                        onceEnumStr += onceEnumContainer
                        enumCache[typeName ?? ""] = onceEnumContainer
                        //MARK: 添加枚举参数
                        onceEnumStr +=
                        """
                        \n}\n\n
                        """
                        enumsContentBuffer += onceEnumStr
                    }
                }
            }

            guard let existTypeName = typeName else {
                YLLOG.error("类型获取失败 key = \(key), value = \(value), level = \(indentLevel)")
                return ""
            }

            property +=
            """
            \(levelData)public var \(key): \(existTypeName)?\n
            """

        } else if String(format: "%@", value)  == "0" {
            property +=
            """
            \(levelData)public var \(key): Int = 0\n
            """
        } else if let _ = value as? Bool {
            property +=
            """
            \(levelData)public var \(key): Bool?\n
            """
        }
        return property
    }


    // 生成对应结构体文本
    func generateStructFromObject(object: NSObject, indentLevel: Int) -> String {
        var structString = ""
        if let existDic = object as? NSDictionary {
            let newLevel = indentLevel + 1
            let curIndent = getIndentByLevel(newLevel)
            for (key, value) in existDic {
                //过滤关键字
                if let _keyStr = key as? String, _keyStr == "extension" {
                    YLLOG.error("参数不能与关键字同名!!! key = \(key); 方法名 = \(curApiCursorName),当前已过滤同名参数")
                    continue
                }

                // 如果value有值且为字符串,说明是enum
                if let valueDic = value as? NSDictionary {

                    var structTypeName = "\(kRpcStructPre)\(key)"

                    let structBody = generateStructFromObject(object: valueDic, indentLevel: 0)
                    var isStructExisted = false

                    // 当 枚举 和 结构体 中有重名的，则添加尾标处理
                    var structNameTailTag = 0
                    for (key, _) in structsCache {
                        if key.contains(structTypeName)  {
                            structNameTailTag += 1
                        }
                    }
                    for (key, _) in enumCache {
                        if key.contains(structTypeName) {
                            structNameTailTag += 1
                        }
                    }
                    if structNameTailTag > 0 {
                         structTypeName = structTypeName + "\(structNameTailTag)"
                    }

                    // 如果已存在可复用的结构体，则直接复用
                    for (key, value) in structsCache {
                        if structBody == value {
                            //已存在
                            isStructExisted = true
                            structTypeName = key
                        }
                    }

                    /// 如果不存在结构体，则创建并缓存
                    if !isStructExisted {
                        structsCache[structTypeName] = structBody
                    }
                    structString +=
                    """
                    \(curIndent)public var \(key): \(structTypeName)?\n
                    """
                } else if let valueArr = value as? NSArray {
                    //                    添加类
                    let item = valueArr.firstObject
                    if let unrapItem = item as? NSDictionary {
                        //值为容器对象
                        var structTypeName = kRpcStructPre + (key as? String ?? "")
                        let structBody = generateStructFromObject(object: unrapItem, indentLevel: 0)
                        var isStructExisted = false

                        // 当 枚举 和 结构体 中有重名的，则添加尾标处理
                        var structNameTailTag = 0
                        for (key, _) in structsCache {
                            if key.contains(structTypeName)  {
                                structNameTailTag += 1
                            }
                        }
                        for (key, _) in enumCache {
                            if key.contains(structTypeName) {
                                structNameTailTag += 1
                            }
                        }
                        if structNameTailTag > 0 {
                            structTypeName = structTypeName + "\(structNameTailTag)"
                        }

                        // 如果已存在可复用的结构体，则直接复用
                        for (key, value) in structsCache {
                            if structBody == value {
                                //已存在
                                isStructExisted = true
                                structTypeName = key
                            }
                        }

                        /// 如果不存在结构体，则创建并缓存
                        if !isStructExisted {
                            structsCache[structTypeName] = structBody
                        }

                        structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "Rpc[\(structTypeName)]" as NSObject, indentLevel: newLevel)

                    } else if let itemStr = item as? String {
                        if itemStr == "" {
                            //值为字符串
                            structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "[String]" as NSObject, indentLevel: newLevel)
                        } else if itemStr == "int" {
                           structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "[Int]" as NSObject, indentLevel: newLevel)
                        } else if  itemStr == "uint64" {
                           structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "[Int64]" as NSObject, indentLevel: newLevel)
                        } else if itemStr == "uint" {
                           structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "[UInt]" as NSObject, indentLevel: newLevel)
                        } else if itemStr == "int64" {
                           structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: "[UInt64]" as NSObject, indentLevel: newLevel)
                        }
                    }

                } else {
                    structString += generatePropertyDefWithoutDuplicated(key: key as? String ?? "", value: value as? NSObject ?? NSObject(), indentLevel: newLevel)
                }
            }
        } else if let existArr = object as? NSArray {
            YLLOG.error("---------该类型未做处理!!!!-----------\n---------该类型未做处理!!!!-----------\n---------该类型未做处理!!!!-----------\n---------该类型未做处理!!!!-----------")
            for _ in existArr {

            }
        }
        return structString
    }

    // 生成API类文件
    func generateApiFile() -> ResultCode {

        let apisFilePath = self.config.outputDirPath + "/\(kRpcApiFileName)"
        let isSuccess = FileManager.default.createFile(atPath: apisFilePath,
                                       contents: apisContentBuffer.data(using: String.Encoding.utf8),
                                       attributes: nil)
        YLLOG.info("保存状态 = \(isSuccess); apisFilePath = \(apisFilePath)")
        return .success
    }
    

    // 生成通知类文件
    func generateNotifyFile() -> ResultCode {
        let notificationFilePath = self.config.outputDirPath + "/\(kRpcNotificationFileName)"
        let isSuccess = FileManager.default.createFile(atPath: notificationFilePath,
                                       contents: notificationsContentBuffer.data(using: String.Encoding.utf8),
                                       attributes: nil)
        YLLOG.info("保存状态 = \(isSuccess); notificationFilePath = \(notificationFilePath)")
        return .success
    }

    /// 生成结构体及枚举文件
    func generateStructsAndEnumsFiles() -> ResultCode {

        // 生成结构体文件
        for (key, value) in structsCache {
            structsConttentBuffer +=
            """
            \npublic struct \(key): YLJSONCodable {\n
            """
            structsConttentBuffer += value
            structsConttentBuffer +=
            """
            \n}\n\n
            """
        }

        structsConttentBuffer = JSONRPCInitMethod.addInitMethod(originalStr: structsConttentBuffer, regular: "public struct .*: YLJSONCodable(.|\\n)*?\\}", t: 0)
        let structsFilePath = self.config.outputDirPath + "/\(kRpcStructsFileName)"
        var isSuccess = FileManager.default.createFile(atPath: structsFilePath,
                                       contents: structsConttentBuffer.data(using: String.Encoding.utf8),
                                       attributes: nil)
        YLLOG.info("保存状态 = \(isSuccess); structsFilePath = \(structsFilePath)")

        // 生成枚举文件
        let enumFilePath = self.config.outputDirPath + "/\(kRpcEnumFileName)"

        isSuccess = FileManager.default.createFile(atPath: enumFilePath,
                                       contents: enumsContentBuffer.data(using: String.Encoding.utf8),
                                       attributes: nil)
        YLLOG.info("保存状态 = \(isSuccess); enumFilePath = \(enumFilePath)")

        return .success
    }



    /// 生成API文件
    ///
    /// - Parameter methods: API方法集数据
    /// - Returns: 生成结果
    func generateAPIsCode(_ methods: NSArray) -> ResultCode {
        apisContentBuffer = kRpcFileImportHeader
        enumsContentBuffer = kRpcFileImportHeader
        structsConttentBuffer = kRpcFileImportHeader

        for method in methods {
            //读取单个方法
            guard let methodDic: NSDictionary = method as? NSDictionary else {
                continue
            }

            guard let name: String = methodDic.value(forKey: "name") as? String,
                let inputDic: NSDictionary = methodDic.value(forKey: "input") as? NSDictionary,
                let ouputDic: NSDictionary = methodDic.value(forKey: "ouput") as? NSDictionary else {
                continue
            }

            // 类名
            curApiCursorName = name
            // 类体内容
            var  classDefBuffer = ""

            let className = "\(kRpcInterfacePre)\(curApiCursorName)"
            classDefBuffer +=
            """
            public class \(className) {
            \(kTab)public static let name = "\(curApiCursorName)"

            """

            // 方法名
            let curIndent = getIndentByLevel(1)
            //MARK: ------传入参数------
            classDefBuffer +=
            """
            \n\(curIndent)public struct Input: YLJSONCodable {\n
            """
            //实际参数
            if let input = inputDic.value(forKey: "param") as? NSDictionary {
                classDefBuffer += generateStructFromObject(object: input, indentLevel: 1)
            }
            classDefBuffer +=
            """
            \(curIndent)}\n
            """

            //MARK: ------传出参数------
            //实际参数
            classDefBuffer +=
            """
            \n\(curIndent)public struct Output: YLJSONCodable {\n
            """
            if let ouput = ouputDic.value(forKey: "body") as? NSDictionary {
                classDefBuffer += generateStructFromObject(object: ouput, indentLevel: 1)
            }
            classDefBuffer +=
            """
            \(curIndent)}\n
            """

            //最后封口
            classDefBuffer +=
            """
            }\n\n
            """

            apisContentBuffer += classDefBuffer
        }

        //生成init方法脚本
        apisContentBuffer = JSONRPCInitMethod.addInitMethod(originalStr: apisContentBuffer)

        let generatedResult = generateApiFile()
        if  generatedResult != .success {
            return generatedResult
        }

        return .success
    }


    /// 生成lRPC类文件
    ///
    ///   - data: 要生成的JSONDoc的JSON生成的NSDictionary数据信息
    ///   - config: 导出配置，传nil使用默认配置
    /// - Returns: 返回结果类型
    func generateCode(_ data: NSDictionary) -> ResultCode {

        // 如果数据空，则直接返回
        if data.count == 0 {
            return .dataNull
        }

        // 生成API文件
        guard let methods: NSArray = data.value(forKey: "method") as? NSArray else {
            return .apisFieldInvalid
        }

        let apisFilesGeneratedResult = generateAPIsCode(methods)
        if apisFilesGeneratedResult != .success {
            return apisFilesGeneratedResult
        }


        // 生成通知文件
        guard let notifys: NSArray = data.value(forKey: "notify") as? NSArray else {
            return .notificationFieldInvalid
        }

        let notifyFilesGeneratedResult = generateNotificationCode(notifys)
        if notifyFilesGeneratedResult != .success {
            return notifyFilesGeneratedResult
        }

        // 写文件
        let writeFileResult = generateStructsAndEnumsFiles()
        if writeFileResult != .success {
            return writeFileResult
        }

        // 全部生成正常，返回success
        return .success
    }

    /// 将通知名转换为类名
    func convertNotifyNameToClassName(notifyName: String) -> String {
        let lowcaseNotifyName = notifyName.lowercased()
        let removeUnderlineLowcaseNotifyName = lowcaseNotifyName.replacingOccurrences(of: "_", with: " ")
        let capitalizedNotifyName = removeUnderlineLowcaseNotifyName.capitalized
        let className = kRpcNotificationPre + capitalizedNotifyName.replacingOccurrences(of: " ", with: "")
        return className
    }
}



