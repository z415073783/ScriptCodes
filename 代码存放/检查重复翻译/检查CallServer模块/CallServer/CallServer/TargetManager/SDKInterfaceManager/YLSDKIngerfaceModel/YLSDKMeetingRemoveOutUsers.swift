//
//  YLSDKMeetingRemoveOutUsers.swift
//  CallServer
//  移出会议   “method”:” removeConfMember”,
//  主持人踢出会议成员
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingRemoveOutUsers: NSObject {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = [] //被踢出会议成员的strUri
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
