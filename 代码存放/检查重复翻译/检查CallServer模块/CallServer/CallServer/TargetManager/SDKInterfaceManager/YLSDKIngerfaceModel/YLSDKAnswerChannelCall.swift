//
//  YLSDKAnswerChannelCall.swift
//  CallServer
//   是否是视频接起来电
//  answerChannelCall
//  Created by Apple on 2017/11/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKAnswerChannelCall: NSObject {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var bVideo: Bool = false //是否视频接起
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
