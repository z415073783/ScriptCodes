//
//  YLSDKMeetingDisableMemberSpeake.swift
//  CallServer
//  禁言或者取消禁言接口
//  “method”:”disableMemberSpeaker”,
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingAbleOrDisableMemberSpeaker: NSObject {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = [] //”会议成员列表的唯一标示id”,示全部
        var bMute: Bool = false //是否允许会议请求
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
