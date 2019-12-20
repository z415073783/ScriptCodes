//
//  CallMeetingCellSourceModel.swift
//  CallServer
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class CallMeetingCellSourceModel: NSObject {
    var bAudioMute: Bool = false //是否音频Mute：false或true,
    var bDataMe: Bool =  false //是否自己：false或true,
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
}
