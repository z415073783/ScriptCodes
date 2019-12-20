//
//  CallWholeEnum.swift
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

import Foundation
import UIKit
enum CallType: Int {
    case unKnown = 0, video = 1, voice = 2
}

// 通话相关

enum CallFinishResonCode: Int {
    case noError = 0,
    sipH323,
    localEndHangupTheSession2,
    localEndHangupTheSession3,
    timeouted,
    sessionOverFlow,
    unkownProtocol,
    uoUsableAccount,
    crashed,
    networkError,
    unkownError
}

/*
 **
 resuslt为对应的错误类型：0时
 finishCode为详细的错误码：
 */
enum FinishNoErrorCode: Int {
    case localEndHangupTheSession = -1,
    ipRemoteEnd = 3,
    sipEndedByForbidden = 403,
    sipEndedByNotFound = 404,
    sipEndedByRequestTimeOut = 408,
    remoteEndHangupTheSession = 400001,
    dnd = 400091,
    talkFinishNetworkBroken = 401001,
    userNotRegister = 401002,
    mediaNegotiateFail = 401003,
    ignoreCallOrForceRejectByPeer = 401005,
    completedElsewhere = 401006,
    talkFinishAudioHasError = 401007,
    conferenceUriUnknown = 402003,
    conferenceLocked = 402004,
    conferenceUserCountExceed = 402005,
    conferenceUserDuplicate = 402006,
    youAreRemovedFromTheConference =  402007,
    conferenceIsEndedByModerator = 402008
}

/*
 **    SIP呼叫失败的错误原因，一般用于V2P_MSG_CALL_FAIL带的扩展数据
 */

enum VoipSIPCallEndReasonCode: Int {
    case unknownReason = 0,
    unknownUriScheme = 1,
    badRequest                    = 400, /* 400 */
    forbidden                        = 403, /* 403 */
    notFound                        = 404, /* 404 */
    methodNotAllowed                = 405, /* 405 */
    notAcceptable                    = 406, /* 406 */
    requestTimeOut                = 408, /* 408 */
    unsupportedMediaType            = 415, /* 415 */
    unsupportedUriScheme            = 416, /* 416 */
    badExtension                    = 420, /* 420 */
    anonymityDisallowed            = 433, /* 433 */
    temporarilyUnavailable        = 480, /* 480 */
    callTransactionDoesNotExist    = 481, /* 481 */
    loopDetected                    = 482, /* 482 */
    busyHere                        = 486, /* 486 */
    notAcceptableHere                = 488, /* 488 */
    badEvent                        = 489, /* 489 */
    requestPending                = 491, /* 491 */
    internalServerError            = 500, /* 500 */
    serviceLost                    = 502, /* 502 */
    serviceUnavailable            = 503, /* 503 */
    decline                        = 603, /* 603 */

    endByLocal                  = -1,
    endByReMote                 = 400001,
    forceSignout                = 400003,
    videoTimeOut                = 400051,
    userIgnore                  = 400090,
    dnd                         = 400091,
    callLimit                   = 400092,
    backList                    = 400093,
    extenBase                   = 401000,
    netWorkBroken               = 401001,
    userNotReg                  = 401002,
    mediaNegotiateFailed        = 401003,
    IgnoreCall                  = 401004,
    forceReject                 = 401005,
    elsewhereComplate           = 401006,
    audioError                  = 401007,

    confServiceFailed           = 402001,
    confInitFailed              = 402002,
    confNotFound                = 402003,
    confLocked                  = 402004,
    confUserCountLimit          = 402005,
    confElsewhereJoin           = 402006,
    confUserDel                 = 402007, //被移出会议
    confForceEnd                = 402008//主持人结束了当前会议
}

/*
 **    323呼叫失败的错误原因，一般用于V2P_MSG_CALL_FAIL带的扩展数据
 */

enum Voip323CallEndReasonCode: Int {
    case h323FinishCodeLocalUser = 0,            /* < Local endpoint application cleared call */
    h323FinishCodeNoAccept,             /* < Local endpoint did not accept call OnIncomingCall()=FALSE */
    h323FinishCodeAnwserDenied,         /* < Local endpoint declined to answer call */
    h323FinishCodeRemoteUser,           /* < Remote endpoint application cleared call */
    h323FinishCodeRefusal,              /* < Remote endpoint refused call */

    h323FinishCodeNoAnswer,             /* < Remote endpoint did not answer in required time*/
    h323FinishCodeCallAbout,            /* < Remote endpoint stopped calling */
    h323FinishCodeTransportFail,        /* < Transport error cleared call */
    h323FinishCodeConnectFail,          /* < Transport connection failed to establish call */
    h323FinishCodeGateKeeper,           /* < Gatekeeper has cleared call */

    h323FinishCodeNoUser,               /* < Call failed as could not find user (in GK) */
    h323FinishCodeNoBandwidth,          /* < Call failed as could not get enough bandwidth*/
    h323FinishCodeCapabilityExchange,   /* < Could not find common capabilities */
    h323FinishCodeCallForward,          /* < Call was forwarded using FACILITY message */
    h323FinishCodeSecurityDenial,       /* < Call failed a security check and was ended*/

    h323FinishCodeLocalBusy,            /* < Local endpoint busy */
    h323FinishCodeLocalCongestion,      /* < Local endpoint congested */
    h323FinishCodeRemoteBusy,           /* < Remote endpoint busy */
    h323FinishCodeRemoteCongestion,     /* < Remote endpoint congested */
    h323FinishCodeUNReachable,          /* < Could not reach the remote party */

    h323FinishCodeNoEndPoint,           /* < The remote party is not running an endpoint */
    h323FinishCodeHostOffline,          /* < The remote party host off line */
    h323FinishCodeTemporaryFailue,      /* < The remote failed temporarily app mayretry */
    h323FinishCodeQ931Cause,            /* < The remote ended the call with unmapped Q.931 cause code */
    h323FinishCodeDurationLimit,        /* < Call cleared due to an enforced duration limit */

    h323FinishCodeInvalidConferenceId,  /* < Call cleared due to invalid conferenceID  */
    h323FinishCodeOSPRefusal,           /* < Call cleared as OSP server unable or unwilling to route */
    h323FinishCodeInvalidNumberFormat,  /* < Call cleared as number was invalid format */
    h323FinishCodeUnspecifiedPortocol,  /* < Call cleared due to unspecified protocol error  */
    h323FinishCodeNoFeatureSupport,     /* < Call ended due to Feature not being present. */

    h323FinishCodeInfomationELEMissing, /* mandatory information element missing */
    h323FinishCodeCompatStateError,     /* message not compatible with call state */
    h323FinishCodeInvalidInfomation,    /* invalid information element */
    h323FinishCodeTimerExpiry,          /* EndedByTimerExpiry T301 */
    h323FinishCodeParamError,           /* new msg, add by requirement */

    h323FinishCodeNumCallEndReasons,

    endByReMote                 = 400001,
    forceSignout                = 400003,
    videoTimeOut                = 400051,
    userIgnore                  = 400090,
    dnd                         = 400091,
    callLimit                   = 400092,
    backList                    = 400093,
    extenBase                   = 401000,
    netWorkBroken               = 401001,
    userNotReg                  = 401002,
    mediaNegotiateFailed        = 401003,
    IgnoreCall                  = 401004,
    forceReject                 = 401005,
    elsewhereComplate           = 401006,
    audioError                  = 401007,

    confServiceFailed           = 402001,
    confInitFailed              = 402002,
    confNotFound                = 402003,
    confLocked                  = 402004,
    confUserCountLimit          = 402005,
    confElsewhereJoin           = 402006,
    confUserDel                 = 402007, //被移出会议
    confForceEnd                = 402008//主持人结束了当前会议

}

/*
 ** 邀请会议成员失败的原因码
 */

enum InviteUserFailedCode: Int {
    case rejectByBlackList = 400093, //黑名单被拒
    limitCalls = 400092, //通话上限被拒
    setDnd = 400091, //对方设置了DND
    rejectByAcl = 40010,
    dnd = 40008,
    timeOut = 40007, //邀请超时
    notFound =  40006, //邀请人未找到
    reject = 40004, //邀请人拒绝
    busy = 40003, //对方忙
    notRegister = 40001, //邀请人未注册
    invalidHeader = 20007,
    offline =  100001// 离线
}

enum ConfEndFailedCode: Int {
    case confNoExistent = 060001, //会议不存在
    haveNoRight = 060029 //权限受限
}

enum LogicVideoType: Int {
    case LvtUnknow = 0,
    LvtLocal = 1,
    LvtRemote = 2,
    LvtShareSend = 3,
    LvtShareRecv = 4
}

/*
 ** 通话滑动 type
 */

enum ScrollViewType: Int {
    case mainScroll = 9560,
    shareScroll = 9561

}

enum CallMoreCellType: Int {
    case unknow = 0,
    addUser,
    dTMF,
    changeAudio,
    smallWindow
}

//CallMeetingCell 控制相关
enum CallMoreCellVideMuteType: Int {
    case unknow  = 0,
    normal,
    muteByServer
}
enum CallMoreCellAudioMuteType: Int {
    case unknow = 0,
    normal,
    muteByLocal,
    muteByServer,
    handup
}

enum meetRoleStateType: Int {
    case unkonw  = 0,
    host, // 主持人
    visitor,// 访客
    hostSpeaking, // 主持人发言中
    visitorSpeaking // 访客发言中
}

enum meetRequestType: Int {
    case hundUp = 0,//举手申请
    handDown,//取消举手
    allowHandUp,//允许举手发言
    disallowHandUP,//不允许举手发言
    mute,//静音
    unmute,// 取消静音
    muteVideo,//视频mute
    unmuteVideo,// 视频视频unmute
    bLecturer,//将成员设置成演讲者
    removeLecturerRight, //将成员取消演讲者
    removeOutConference,//移出会议
    bHost,// 设为主持人
    removeHostRight, // 取消主持人权限
    cancelInvite //取消邀请
}


/*! @brief 选择类型
 *  手势操作
 */
//enum iclickType: Int{
//   case UNknow = 0,                         //**未知 默认  */
//    
//    contacts = 1,                       //** 1.邀请联系人 - 传入参会人员列表 */
//    h323AndSip = 2,                     //**2.邀请H323/sip*/
//    imute = 3,                           //**3.静音*/
//    dtmfPad = 4,                        //**4.拨号键盘*/
//    speaker = 5,                        //**5.扬声器*/
//    
//    ihangup = 6,                         //**6.挂断*/
//    callstatistics = 7,                 //**7.通话统计*/
//    shareReceived = 8,                  //**8.接收辅流*/
//    shareStop = 9,                      //**9.断开辅流*/
//    hideSmallWindow = 10,               //**10.隐藏小窗口*/
//    
//    showSmallWindow = 11,               //**11.显示小窗口*/
//    muteCamear = 12,                    //**12.mute摄像头*/
//    unmuteCamear = 13,                  //**13.unmute摄像头*/
//    openFullScreen = 14,                //**14.全屏开*/
//    closeFullScreen = 15,               //**15.全屏关*/
//    
//    lockScreen = 16,                    //**16.锁定屏幕*/
//    unlockScreen = 17,                  //**17.解锁屏幕*/
//    switchCamear = 18,                  //**18.切换摄像头*/
//    switchBigSmallContent = 19,         //**19.大小窗口切换*/
//    handup = 20,                        //**20.举手*/
//    
//    unhundup = 21                     //**21.取消举手*/
//}
