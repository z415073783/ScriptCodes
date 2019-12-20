//
//  YLSDKLockMeetingModel.swift
//  CallServer
//  锁定会议接口
//    “method”:” lockConference”,
// 对某个成员进行关闭视频；返回错误直接提示处理不成功，返回true，需要处理3.1和3.2消息。
//  Created by Apple on 2017/11/14.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingLockMeetingModel: NSObject  {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var bLockConf: Bool = false //:是否锁定会议：false或true
    }
    
    struct OutPutInfo: HandyJSON {
        var result: Result?
    }
    
    struct Result: HandyJSON {
        var errorCode: Int = 0
        var errorDesc: String = ""
        var operateID: String = ""
        var type: String = ""
    }
}
