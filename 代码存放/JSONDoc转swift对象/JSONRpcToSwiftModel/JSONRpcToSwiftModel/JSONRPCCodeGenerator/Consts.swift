//
//  Consts.swift
//  JSONRpcToSwiftModel
//
//  Created by yealink-dev on 2018/12/4.
//  Copyright © 2018年 Yealink Inc'. All rights reserved.
//

import Foundation

// 文件名相关
let kAPIsDirectoryName = "APIs"
let kRpcEnumFileName = "RpcIEnums.swift"
let kRpcStructsFileName = "RpcIStructs.swift"
let kRpcApiFileName = "RpcAPIs.swift"
let kRpcNotificationFileName = "RpcINotifications.swift"

let kRpcInterfacePre = "RpcInterface_"
let kRpcStructPre = "RpcStruct_"
let kRpcEnumPre = "RpcEnum_"
let kRpcNotificationPre = "RpcNotification_"

let kTab = "\t"


let kRpcFileImportHeader = """
import Foundation
import YLBaseFramework
\n
"""

let kRpcNotificationFileImportHeader = """
import Foundation
\n
"""

