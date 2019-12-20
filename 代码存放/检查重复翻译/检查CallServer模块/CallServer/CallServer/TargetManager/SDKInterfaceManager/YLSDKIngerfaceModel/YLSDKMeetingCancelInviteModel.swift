//
//  YLSDKMeetingCancelInviteModel.swift
//  CallServer
//  取消邀请接口
//  收到3.1介绍MSG_TALK_CONFERENCE_MEMBERLIST_INFO_UPDATE消息后更新消息后对显示的成员列表进行更新。
//    “method”:”cancelInvite”,
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingCancelInviteModel: NSObject  {
    //命名规则 模块名 + 接口名 + Input
    struct InputDataInfo: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = []//需要获取参会人员信息的唯一标示id，如果列表为空，则表示全部
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
