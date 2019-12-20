//
//  CallNotificationNames.swift
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

import Foundation

let VOIPNotifisArray = [keyServiceInitFinish,
                        keyTalkRingbackNotify,
                        keyTalkConnectingNotify,
                        keyTalkEstablishedNotify,
                        keyTalkIncomingNotify,
                        keyTalkFinishedNotify,
                        keyTalkRemoteHoldNotify,
                        keyScreenShareReceivedNotify,
                        keyScreenShareSendResetNotify,
                        keyScreenShareStopedNotify,
                        keyVideoSizeChangeNotify,
                        keyMeetingDescriptionNotify,
                        keyCallidReplacedNotify,
                        keyConfUserConnectStatusNotify,
    ]

let CallAppNotifisArray = [keyConfUserUpdateNotification,
                           keyConfAudioMuteFailedNotification,
                           keyConfCancelJoinNotifyNotification,
                           NSNotification.Name.UIApplicationWillEnterForeground,
                           KCallLogUpdateNotification,
                           keyConferencsSomeOneHandup,
                           
]

let kcallTalkFinishViewDissMiss = "CallTalkFinishViewDissMiss"
let kWidgetClickedNeedCall = "WidgetClickedNeedCall"
// 角色信息变更
let keyConfUserUpdateNotification = Notification.Name(keyConfUserUpdateNotify)
// 会议用户本地静音失败
let keyConfAudioMuteFailedNotification = Notification.Name(keyConfAudioMuteFailedNotify)
let keyConfCancelJoinNotifyNotification = Notification.Name(keyConfCancelJoinNotify)
let kAudioOutputModeChangedNotification  = Notification.Name("AudioOutputModeChangedNotification")
// 邀请用户失败
let keyConfInviteUserFailedNotification = Notification.Name(keyConfInviteUserFailedNotify)
// 邀请成功或者用户拒绝
let kUserInOrRejectUpdateNotification = Notification.Name(keyConfUserConnectStatusNotify)
let KCallLogUpdateNotification = Notification.Name(keyTalkMissCallNotify)

// 注册状态变更"AccountStateChangeNotify"
let kAccountStateChangeNotification = Notification.Name(keyAccountStateChangeNotify)
// 云注册状态变更"AccountStateChangeNotify"
let keyCloudAccountChangeNotification = Notification.Name(keyCloudAccountChangeNotify)

// 会议列表信息变更"MSG_TALK_CONFERENCE_MEMBERLIST_INFO_UPDATE"

/*
 会议成员显示名或状态等的变化
 */
let keyConferencsMemberListInfoUpdate =  Notification.Name("MSG_TALK_CONFERENCE_MEMBERLIST_INFO_UPDATE")

/*
 会议成员角色信息变更失败
 */
let keyConferencsModifyRoleFailed = Notification.Name("MSG_TALK_CONFERENCE_MODIFY_ROLE_FAILED")


/*
 会议成员角色移除失败
 */
let keyConferencsRemoveUserFailed = Notification.Name("MSG_TALK_CONFERENCE_DELETE_USER_FAILED")

/*
 会议被锁定
 */
let keyConferencsLockFailed = Notification.Name("MSG_TALK_CONFERENCE_LOCK_CONFERENCE_FAILED")

/*
 会议有新消息
 */
let keyConferencsMessageListInfoUpdate =  Notification.Name("MSG_TALK_CONFERENCE_MESSAGE_LIST_UPDATE")

/*
 有人申请发言
 */
let keyConferencsSomeOneHandup = Notification.Name("MSG_TALK_CONFERENCE_MEMBER_REQUEST_SPEAKER")
