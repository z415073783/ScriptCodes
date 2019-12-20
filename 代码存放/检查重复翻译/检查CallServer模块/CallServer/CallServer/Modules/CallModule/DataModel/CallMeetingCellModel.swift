

//
//  CallMeetingCellModel.swift
//  CallServer
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON


class CallMeetingCellModel: NSObject {
    var userRoalStateType: meetRoleStateType = .unkonw
    var userIconImage: UIImage?
    var userIconAnimationImages: Array<UIImage>?
    var title: String = ""
    var subTitle: String = ""

    var sourceDataModel: CallMeetingCellSourceModel =  CallMeetingCellSourceModel()
    
    func setValue(sourValue:YLSDKMeetingMemberListModel.ConfMemInfo) {
        sourceDataModel = CallMeetingCellSourceModel()
        
        sourceDataModel.bAudioMute = sourValue.bAudioMute //是否音频Mute：false或true,
        sourceDataModel.bDataMe = sourValue.bDataMe //是否自己：false或true,
        sourceDataModel.bLecturer = sourValue.bLecturer //是否演讲者：false或true,
        sourceDataModel.bMuteByServer = sourValue.bMuteByServer //是否被服务器Mute：false或true,
        sourceDataModel.bMuteSpeakerByServer = sourValue.bMuteSpeakerByServer //是否被服务器Mute：false或true,
        
        sourceDataModel.bMuteVideoByServer = sourValue.bMuteVideoByServer //是否被服务器Mute视频：false或true,
        sourceDataModel.bRequestSpeak = sourValue.bRequestSpeak //是否申请发言：false或true,
        sourceDataModel.bShareSend = sourValue.bShareSend //是否辅流发送者：false或true,
        sourceDataModel.bShareVideo = sourValue.bShareVideo //是否辅接受送者：false或true,
        sourceDataModel.id = sourValue.id //
        
        
        sourceDataModel.listDepart = sourValue.listDepart //
        sourceDataModel.nAudioId = sourValue.nAudioId //int型音频id
        sourceDataModel.nVideoId = sourValue.nVideoId //
        sourceDataModel.roleUser = sourValue.roleUser // CUR_PRESENTER或CUR_ATTENDEE”
        sourceDataModel.staJoin = sourValue.staJoin //
        
        sourceDataModel.strId = sourValue.strId //”成员唯一标示符”
        sourceDataModel.strName = sourValue.strName //”Name”
        sourceDataModel.strNumber = sourValue.strNumber //”号码”
        sourceDataModel.strUri = sourValue.strUri //”会议uri”
        
        if sourceDataModel.roleUser == "CUR_PRESENTER" {
            userRoalStateType = .host
        } else if sourceDataModel.roleUser == "CUR_ATTENDEE" {
            userRoalStateType = .visitor
        }
        title = sourceDataModel.strName
        if let subInfo = sourValue.listDepart.first {
            subTitle = subInfo
        }

    }
}
