//
//  YLSDKMeetingMemberListModel.swift
//  CallServer
//  获取参会人员信息列表
//  “method”:” getMemberInfoList”,
//  收到3.1介绍MSG_TALK_CONFERENCE_MEMBERLIST_INFO_UPDATE消息后更新消息后对显示的成员列表进行更新。 ConferenceUserData结构体内容参考json格式说明。
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON

class YLSDKMeetingMemberListModel: NSObject  {
    
    //命名规则 模块名 + 接口名 + Input
    struct InputData: HandyJSON {
        var nCallId: Int = 0
        var usersId:[String] = []//需要获取参会人员信息的唯一标示id，如果列表为空，则表示全部
    }
    
    // MARK: output
    //命名规则 模块名 + 接口名 + OutPut + 自定义名称
    struct OutPutInfo: HandyJSON {
        var result: Result?
        var body: Body?
    }
    
    struct Result: HandyJSON {
        var errorCode: Int = 0
        var errorDesc: String = ""
        var operateID: String = ""
        var type: String = ""
    }
    
    
    struct Body: HandyJSON {
        var memberInfoList: [ConfMemInfo] = []
    }

    public struct ConfMemInfo: HandyJSON {
        var bAudioMute: Bool = false //是否音频Mute：false或true,
        var bDataMe: Bool = false // 是否是自己 
        var bLecturer: Bool = false //是否演讲者：false或true,
        var bMuteByServer: Bool = false //是否被服务器Mute：false或true,
        var bMuteSpeakerByServer : Bool = false //
        var bMuteVideoByServer: Bool = false //是否被服务器Mute视频：false或true,
        var bRequestSpeak: Bool = false //是否申请发言：false或true,
        var bShareSend: Bool = false //是否辅流发送者：false或true,
        var bShareVideo: Bool = false
        var id: String = ""
        var listDepart:Array<String> = []
        var nAudioId: Int = 0 //int型音频id
        var nVideoId: Int = 0
        var roleUser: String =  "" //CUR_PRESENTER或CUR_ATTENDEE”,
        var staJoin: String = ""
        var strId: String = "" //”成员唯一标示符”
        var strName: String = "" //”Name”
        var strNumber: String = "" //”号码”
        var strUri: String = "" //”会议uri”
        //var strDepart: String = "" //”部门显示名”
    }
}
