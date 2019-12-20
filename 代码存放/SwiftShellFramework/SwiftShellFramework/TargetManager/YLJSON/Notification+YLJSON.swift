//
//  Notification+YLJSON.swift
//  YLCommonUtility
//
//  Created by zlm on 2018/8/20.
//  Copyright © 2018年 yealink. All rights reserved.
//

import Foundation
struct YLJSONNotificationModel<T: YLJSONCodable> : YLJSONCodable {
    var lparam: Int = 0
    var wparam: Int = 0
    var extraobject: T?
}

public extension Notification {

    /// 通知数据转换 全数据
    ///
    /// - Parameter DataClass: 全部数据都要model化
    /// - Returns: 实例对象
    public func getRpcDataSync<T: YLJSONCodable> (_ DataClass: T.Type) ->T? {
        guard let value = object as? String else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let output = try decoder.decode(DataClass, from: value.data(using: String.Encoding.utf8) ?? Data())
            return output
        } catch {
            print("字符串转换错误: OutputClass = \(DataClass)\n value = \(value)")
            return nil
        }
    }

    /// 通知数据转换 只针对逻辑层的ExtraObject数据
    ///
    /// - Parameter OutputClass: 只针对ExtraObject数据进行model化
    /// - Returns: 返回ExtraObject的Model实例
    public func getRpcExtraDataSync<T: YLJSONCodable> (_ OutputClass: T.Type) ->T? {
        let data = getRpcDataSync(YLJSONNotificationModel<T>.self)
        return data?.extraobject
    }




}
