//
//  YLSDKMeetingModifyConfRole.swift
//  CallServer
//  变更成员入会角色
//    “method”:” modifyConfRole”,
//  变更成员在会议中的角色；需要处理3.1 MSG_TALK_CONFERENCE_MEMBERLIST_INFO_UPDATE  和3.2消息 MSG_TALK_CONFERENCE_OPERATE_RESULT。

//  Created by Apple on 2017/11/14.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingModifyConfRole: NSObject  {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = [] //”变更角色成员的[strUri]
        var userRole: String = "" //是否允许会议请求
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
