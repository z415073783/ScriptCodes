//
//  JSONRPCCodeGenerateConfig.swift
//  JSONRpcToSwiftModel
//
//  Created by yealink-dev on 2018/12/6.
//  Copyright © 2018年 Yealink Inc'. All rights reserved.
//

import Foundation

/// 文件生成配置类
class JSONRPCCodeGenerateConfig: NSObject {
    /// 导出路径
    var outputDirPath: String = "."

    class func defaultConfig() -> JSONRPCCodeGenerateConfig {
        let config = JSONRPCCodeGenerateConfig()
        config.outputDirPath =  kShellPath + "/" + kAPIsDirectoryName + ""
        return config
    }

}
