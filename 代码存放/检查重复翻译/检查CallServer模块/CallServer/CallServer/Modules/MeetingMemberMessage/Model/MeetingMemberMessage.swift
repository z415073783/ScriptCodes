//
//  MeetingMemberMessage.swift
//  Odin-YMS
//
//  Created by soft7 on 2017/11/1.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit
import HandyJSON
import YLBaseFramework

enum MeetingMemberMessageType: String, HandyJSONEnum {
    case removedByModerator = "removedFromConf", // 会议中参会者被移出会议
    meetingEndByModerator = "confEndedByModerator", // 会议中主持人结束会议，所有人离开会议
    applyingSpeaking = "sendingSpeaking", // 会议中本地申请发言
    cancelApplyingSpeaking = "cancelledSpeaking", // 会议中本地取消申请发言
    rejectedApplyingSpeaking = "speakingBeRefused", // 会议中本地申请发言被拒绝
    allowedApplyingSpeaking = "speakingBeAllowed", // 会议中本地申请发言被允许
    mutedByModerator = "mutedByModerator", // 会议中参会者被主持人禁言
    unmutedByModerator = "unmutedByModerator", // 会议中参会者被主持人解除禁言
    blockByModerator = "blockedByModerator", // 会议中参会者被主持人闭音
    unblockByModerator = "unblockedByModerator", // 会议中参会者被主持人解除闭音
    beModerator = "setAsModerator", //  会议中参会者被主持人设置为主持人
    beGuest = "setAsGuest", // 会议中参会者被主持人设置为访客
    beLecturer = "setAsLecturer", // 会议中Web参会者被主持人设置为演讲者
    discardLecturer = "lecturerBeCancelled", // 会议中参会者被主持人取消演讲权限
    deleteConfUserFailed = "deleteConfUserFailed", // 移除用户失败
    
    memberJoin = "joinConf", // xxx加入了会议
    memberLeave = "leaveConf", // xxx离开了会议
    memberInvite = "invitedToConf", // 您邀请xxx了加入会议
    memberFailed = "inviteFailed" // 所有"xxx邀请失败，失败原因code xxx"类型的消息
    
//    memberInviteRejectedByDND = "", // xxx因为开启了DND
//    memberInviteRejectedByTimeout = "", // xxx邀请超时
//    memberInviteRejectedByCallLimit = "", // xxx邀请因为通话上限被拒
//    memberInviteRejectedByAccountNotExisted = "", // xxx账号不存在
//    memberInviteRejectedByBusy = "", // xxx用户忙
//    memberInviteRejectedByUserOffline = "" // xxx用户离线无法呼叫

    // 是否是重要消息，收到重要消息显示红点
    func isImportant() -> Bool {
        switch self {
        case .removedByModerator,
             .meetingEndByModerator,
             .applyingSpeaking,
             .cancelApplyingSpeaking,
             .rejectedApplyingSpeaking,
             .allowedApplyingSpeaking,
             .mutedByModerator,
             .unmutedByModerator,
             .blockByModerator,
             .unblockByModerator,
             .beModerator,
             .beGuest,
             .beLecturer,
             .discardLecturer:
            return true
        default:
            return false
        }
    }
    
    func toString(withMemberName memberName: String? = nil) -> String {
        switch self {
        case .removedByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageRemoveFromMeeting
        case .meetingEndByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageMeetingEnd
        case .applyingSpeaking:
            return YLSDKLanguage.YLSDKMeetingMemberMessageApplicationSpeaking
        case .cancelApplyingSpeaking:
            return YLSDKLanguage.YLSDKMeetingMemberMessageCancelApplicationSpeaking
        case .rejectedApplyingSpeaking:
            return YLSDKLanguage.YLSDKMeetingMemberMessageApplicationSpeakingRejected
        case .allowedApplyingSpeaking:
            return YLSDKLanguage.YLSDKMeetingMemberMessageApplicationSpeakingAllowed
        case .mutedByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageMuteByModerator
        case .unmutedByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageCancelMuteByModerator
        case .blockByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageBlockByModerator
        case .unblockByModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageCancelBlockByModerator
        case .beModerator:
            return YLSDKLanguage.YLSDKMeetingMemberMessageBeModerator
        case .beGuest:
            return YLSDKLanguage.YLSDKMeetingMemberMessageBeGuest
        case .beLecturer:
            return YLSDKLanguage.YLSDKMeetingMemberMessageBeLecturer
        case .discardLecturer:
            return YLSDKLanguage.YLSDKMeetingMemberMessageDiscardLecturer
        case .deleteConfUserFailed:
            return String(format: YLSDKLanguage.YLSDKMeetingMemberMessageDeleteConfUserFailed,
                          memberName ?? "")
        case .memberJoin:
            return String(format: YLSDKLanguage.YLSDKMeetingMemberMessageJoinMeetingFormat,
                          memberName ?? "")
        case .memberLeave:
            return String(format: YLSDKLanguage.YLSDKMeetingMemberMessageLeaveMeetingFormat,
                          memberName ?? "")
        case .memberInvite:
            return String(format: YLSDKLanguage.YLSDKMeetingMemberMessageInviteNewMemberFormat,
                          memberName ?? "")
        case .memberFailed:
            return String(format: YLSDKLanguage.YLSDKMeetingMemberMessageInviteFail,
                          memberName ?? "")
        }
    }
}

class MeetingMemberMessage: NSObject {
    /// 会议消息列表接口
    static let interfaceName = "getConfMsgList"
    
    struct Intput: HandyJSON {
        var nCallId: Int = 0
        var nStartIndex: Int = -1
    }
    
    struct Output: HandyJSON {
        var confMsgList: [Message] = []
    }
    
    struct Message: HandyJSON {
        var index: Int = 0
        var bornTime: TimeInterval = 0
        var msgType: MeetingMemberMessageType?
        var name: String = ""
        var strNumber: String = ""
        var listDepart: [String] = []
        var strErrorCode: String?
        var strErrorInfo: String?
        
        func getTimeStr() -> String {
            let realTime = bornTime
            let seconds = Int(realTime.truncatingRemainder(dividingBy: 60))
            let minutes = Int(realTime / 60)
            let timeStr = String(format: "%02d:%02d", minutes, seconds)
            return timeStr
        }
        
        func getMessage() -> String {
            guard let msgType = msgType else { return "" }
            
            let message = msgType.toString(withMemberName: name)
            if msgType == .memberFailed {
                if let strErrorCode = strErrorCode, let errorCode = Int(strErrorCode) {
                    return "\(message), \(CallReasonCodeToText.getMeetingInviteFailedCode(failedCode: errorCode))"
                }
                return "\(message), \(strErrorCode ?? "nil") , \(strErrorInfo ?? "nil")"
            }
            return message
        }
    }
}
