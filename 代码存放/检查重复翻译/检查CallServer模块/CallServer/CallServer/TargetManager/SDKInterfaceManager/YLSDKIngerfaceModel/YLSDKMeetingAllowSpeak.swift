//
//  YLSDKMeetingAllowSpeak.swift
//  CallServer
//  是否允许发言申请接口
//  允许或者拒绝申请发言请求
//  “method”:” allowSpeakerRequest”,
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
class YLSDKMeetingAllowSpeak: NSObject  {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var userId:[String] = [] //”会议成员列表的唯一标示id”,示全部
        var bAllow: Bool = false //是否允许会议请求
    }
    
    // MARK: output
    //命名规则 模块名 + 接口名 + OutPut + 自定义名称
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
