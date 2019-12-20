//
//  YLSDKInterFaceManager.swift
//  CallServer
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
import YLBaseFramework

struct SdkInterfaceBaseModel: HandyJSON {
    var method: String!
    var param: Any!
}

struct SdkInterfaceBaseOutputModel<T>: HandyJSON {
    var result: SdkResultStringStruct?
    var body: T?
}

struct SdkResultStringStruct: HandyJSON {
    var errorCode: Int = 0 // 0 默认表示失败
    var errorDesc: String = ""
    var operateID: String = ""
    var type: String = ""
}

struct SdkResultStruct: HandyJSON {
    var errorCode: Int = 0 // 0 默认表示失败
    var errorDesc: String = ""
    var operateID: String = ""
    var type: SdkInterfaceResultType = .fail
}

struct SdkInterfaceEmptyBody: HandyJSON {
}

enum SdkInterfaceResultType: String {
    case fail = "0", success = "1", wait = "2"
    static func getType(sender: String) ->SdkInterfaceResultType {
        let newStr = sender
        if newStr.contains("SUCCESS")  {
            return .success
        } else if newStr.contains("FAIL") {
            return .fail
        } else if newStr.contains("WAIT") {
            return .wait
        } else {
            return .fail
        }
    }
}

extension HandyJSON {
    
    //多线程T
    @discardableResult func getData <T: HandyJSON> (name: String, BodyClass: T.Type, block: @escaping (_ body: T?, _ result: SdkResultStruct?) -> Void) -> BlockOperation {
        let newOperation = BlockOperation()
        newOperation.addExecutionBlock {
            self.getDataSync(name: name, BodyClass: BodyClass, block: { (body, result) in
                ExecuteOnMainThread {
                    block(body, result)
                }
            })
        }
        YLSDKDispatchManager.interfaceOperatorQueue.addOperation(newOperation)
        return newOperation
    }
    //队列执行, 移除重复队列
    @discardableResult func getDataQueue <T: HandyJSON> (name: String, BodyClass: T.Type, block: @escaping (_ body: T?, _ result: SdkResultStruct?) -> Void) -> BlockOperation {
        let queue = YLBasicDispatchManager.getOperationQueue(withName: name, maxCount: 1)
        let operations = queue.operations
        for operation in operations {
            if operation.isExecuting == false {
                operation.cancel()
            }
        }
        let newOperation = BlockOperation()
        newOperation.addExecutionBlock {
            guard !newOperation.isCancelled else { return }
            self.getDataSync(name: name, BodyClass: BodyClass, block: { (body, result) in
                guard !newOperation.isCancelled else { return }
                ExecuteOnMainThread {
                    guard !newOperation.isCancelled else { return }
                    block(body, result)
                }
            })
        }
        queue.addOperation(newOperation)
        return newOperation
    }
    
    func getDataSync <T: HandyJSON> (name: String, BodyClass: T.Type, block: @escaping (_ body: T?, _ result: SdkResultStruct?) -> Void) {
        
        let model = SdkInterfaceBaseModel(method: name, param: self as Any!)
        let result = YLLogicAPI.rpcCall(model.toJSONString())
        let getOperation = OperationQueue.current?.operations.first
        if getOperation?.isCancelled == true {
            // 如果正在执行的operation被设置为cancel,将不再返回结果
            return
        }
        YLSDKLOG.log(result)
        
        if let result = result,
            let output = SdkInterfaceBaseOutputModel<T>.deserialize(from: result),
            let outputResult = output.result {
            
            print(output)
            
            block(output.body, SdkResultStruct(errorCode: outputResult.errorCode,
                                              errorDesc: outputResult.errorDesc,
                                              operateID: outputResult.operateID,
                                              type: SdkInterfaceResultType.getType(sender: outputResult.type)))
        }
        else {
            block(nil, SdkResultStruct())
        }
    }
    
    //多线程
    func sdkGetData (name: String,block: @escaping CallBlockFuncString) {
        YLSDKDispatchManager.interfaceOperatorQueue.addOperation {
            self.sdkGetDataSync(name: name, block: block)
        }
    }
    func sdkGetDataSync(name: String, block: @escaping CallBlockFuncString) {
        let model = SdkInterfaceBaseModel(method: name, param: self as Any!)
        let result = YLLogicAPI.rpcCall(model.toJSONString())
        if result == nil {
            block("")
        } else {
            if let reslult = result {
                block(reslult)
            }
        }
    }
}


