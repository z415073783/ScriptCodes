//
//  YLSDKMeetingSetSpeaker.swift
//  CallServer
//  入会成员设置成演讲者
//  “method”:” setMemberLecturer”,
//  将成员设置成演讲者或者非演讲者
//  将成员设置成演讲者或者非演讲者；需要处理3.1和3.2消息。
//  Created by Apple on 2017/11/14.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
class YLSDKMeetingSetSpeaker: NSObject  {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = [] //”会议成员列表的唯一标示id”,示全部
        var bLecturer: Bool = false //是否将成员设置成演讲者：false或true
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
