//
//  YLSDKMeetingSilenceORNotModel.swift
//  CallServer
//  开启或关闭声音
//  是否对成员进行闭音，闭音即不发送音频流给对方
//    “method”:”memberSilence”,
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
class YLSDKMeetingSilenceORNotModel: NSObject {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = [] //”会议成员列表的唯一标示id”,示全部
        var bSilence: Bool = false //是否对成员进行闭音：false或true
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
