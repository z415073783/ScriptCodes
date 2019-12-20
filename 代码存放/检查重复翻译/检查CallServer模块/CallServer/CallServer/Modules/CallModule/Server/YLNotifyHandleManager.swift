//
//  YLNotifyHandleManager.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class YLNotifyHandleManager: YLCallServerDataSource {
    
    
    func registerVOIPNotify() {
        YLSDKLogger.log("CallManager registerVOIPNotify")
        for name in VOIPNotifisArray {
            NotificationCenter.default.addObserver(self, selector: #selector(handleVOIPNotification(notification:)), name: NSNotification.Name(rawValue: name), object: nil)
        }
    }
    func registerAppNotify() {
        YLSDKLogger.log("CallManager registerAppNotify")
        for notify in CallAppNotifisArray {
            NotificationCenter.default.addObserver(self, selector: #selector(handleAPPNotification(notification:)), name: notify, object: nil)
        }
        CallInviteManager.getInstance.addListener()
    }

    /** VOIP  unregister service*/
    func unregisterVOIPNotify() {
        YLSDKLogger.log("CallManager unregisterVOIPNotify")
        for name in VOIPNotifisArray {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
        }
    }
    
    func unregisterAppNotify() {
        YLSDKLogger.log("CallManager unregisterAppNotify")
        for notify in CallAppNotifisArray {
            NotificationCenter.default.removeObserver(self, name: notify, object: nil)
        }
        CallInviteManager.getInstance.removeListener()
    }
    
    @objc func handleAPPNotification(notification: NSNotification) {
        switch notification.name {
        case keyConfUserUpdateNotification:
            confUserUpdate(note: notification)
            break
        case keyConfAudioMuteFailedNotification:
            confAudioMuteFailed(note: notification)
            break
            
        case keyConfCancelJoinNotifyNotification:
            confCancelJoin(note: notification)
            break
            
        case NSNotification.Name.UIApplicationWillEnterForeground:
            checkIfincome(note: notification)
            break
        case KCallLogUpdateNotification:
            handleMissCall(note: notification)
            break
        case keyConferencsSomeOneHandup:
            handleSomeOneHandUp(note: notification)
            break
        default:
            break
        }
    }
    
    // 角色变化
    @objc func confUserUpdate (note: NSNotification) {
        YLSDKLogger.log("CallManager confUserUpdateNotification")
        if let code = note.userInfo?["ConfUserUpdateResult"] as? Int {
            if callStateManager.isEqualState(OnTalkingState) || callStateManager.isEqualState(EstablishedState) {
                DispatchQueue.main.async {[weak self] in
                    if self == nil {
                        return
                    }
                    self?.noticePrestent(code)
                    self?.callManagerController.muteButtonViewUpdate()
                }
            }
        }
    }
    
    // 邀请用户失败
    @objc func confInviteUserFailed(note: NSNotification) {
        YLSDKLogger.log("CallManager keyConfInviteUserFailedNotification")
        
        if let member  = note.userInfo?[keyConfInviteMember] as? String {
            DispatchQueue.main.syncYL { [weak self] in
                if self == nil {
                    return
                }
                if member.count > 0 {
                    _ = YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKInvite_ + member + YLSDKLanguage.YLSDKFail, position: .top, block: nil)
                }
            }
        }
    }
    
    // 用户静音操作失败 举手请求失败
    @objc func confAudioMuteFailed(note: NSNotification) {
        YLSDKLogger.log("CallManager keyConfAudioMuteFailedNotification")
        
        DispatchQueue.main.syncYL {[weak self] in
            if self == nil {
                return
            }
            self?.callManagerController.muteButtonViewUpdate()
        }
    }
    //请求加入会议的成员被取消
    @objc func confCancelJoin (note: NSNotification) {
        YLSDKLogger.log("CallManager keyConfCancelJoinNotifyNotification")
        
    }
    //是否正在来电需要响铃
    @objc func checkIfincome (note: NSNotification) {
        YLSDKLogger.log("checkIfincome")
        if callStateManager.isEqualState(IncomingState) && VoIPPushManager.default.isPushedLocalNotification() == true {
            AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
            SoundPlayer.getInstance.cancelRing()
            SoundPlayer.getInstance.playIncome()
        }
    }
    // 错过来电
    
    @objc func handleMissCall (note: NSNotification) {
        YLSDKLogger.log("handleMissCall")
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleTalkIncomeEvent(notification:)), object: nil)
    }
    @objc func handleSomeOneHandUp (note: NSNotification) {
        YLSDKLogger.log("handleSomeOneHandUp note:\(note.object)" )

        YLSDKLogger.log("handleSomeOneHandUp note:\(note.userInfo)" )
        if let userinfo  = note.userInfo {
            let json = userinfo["JsonMessageInfo"]
            YLSDKLogger.log("\(json)")
        }
        
        
    }
    
    @objc func handleVOIPNotification(notification: NSNotification) {
        YLSDKLogger.log("handleVOIPNotification notify name:" + notification.name.rawValue)
        
        switch notification.name.rawValue {
        case keyServiceInitFinish:
            self.performSelector(onMainThread: #selector(handleVOIPServiceStandBy(notification:)), with: notification, waitUntilDone: true)
            break
        case keyTalkRingbackNotify:
            self.performSelector(onMainThread: #selector(handleRingbackEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyTalkEstablishedNotify:
            isEstblish = true
            self.performSelector(onMainThread: #selector(handleTalkEstablishedEvent(notification:)), with: notification, waitUntilDone: true)
            CallServerInterface.sharedManager().click(EVENT_CALL_START, respon: nil)
            VoIPPushManager.default.notifyCallTake()
            break
        case keyTalkFinishedNotify:
            isEstblish = false
            self.performSelector(onMainThread: #selector(handleTalkFinishedEvent(notification:)), with: notification, waitUntilDone: true)
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleTalkIncomeEvent(notification:)), object: nil)
            CallServerDataSource.getInstance.remoteName = ""
            CallServerInterface.sharedManager().click(EVENT_CALL_UESTABLISH, respon: nil)
            VoIPPushManager.default.notifyCallFinish()
            break
        case keyScreenShareReceivedNotify:
            self.performSelector(onMainThread: #selector(handleScreenShareReceivedEvent(notification:)), with: notification, waitUntilDone: true)
            break
            
        case keyScreenShareSendResetNotify:
            self.performSelector(onMainThread: #selector(handleScreenShareResetNotifyEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyScreenShareStopedNotify:
            self.performSelector(onMainThread: #selector(handleScreenShareStopedEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyVideoSizeChangeNotify:
            self.performSelector(onMainThread: #selector(handleVideoSizeChangeEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyTalkIncomingNotify:
            self.performSelector(onMainThread: #selector(handleTalkIncomeEvent(notification:)), with: notification, waitUntilDone: true)
            //            VoIPPushManager.default.notifyCallIncoming()
            break
        case keyTalkConnectingNotify:
            self.performSelector(onMainThread: #selector(handleConnectionEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyTalkRemoteHoldNotify:
            self.performSelector(onMainThread: #selector(handleRemoteHoldEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyCallidReplacedNotify:
            self.performSelector(onMainThread: #selector(handleCallidReplacedEvent(notification:)), with: notification, waitUntilDone: true)
            if isEstblish == true {
                self.performSelector(onMainThread: #selector(handleTalkEstablishedEvent(notification:)), with: notification, waitUntilDone: true)
            }
            break
        case keyMeetingDescriptionNotify:
            self.performSelector(onMainThread: #selector(handleMeetDescriptUpdateEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyConfReqDeleteFailedCode:
            self.performSelector(onMainThread: #selector(handleConfReqDeleteFailedEvent(notification:)), with: notification, waitUntilDone: true)
            break
        case keyConfUserConnectStatusNotify:
            self.performSelector(onMainThread: #selector(handleUserConnectStatusEvent(notification:)), with: notification, waitUntilDone: true)
            
        default:
            break
        }
    }
    @objc func handleVOIPServiceStandBy(notification: NSNotification) {
        YLSDKLogger.log("handleVOIPServiceStandBy notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyServiceInitFinish) {
            if let success = notification.userInfo?[keyInitResult] as? Int {
                if success == 1 {
                    if callStateManager.canFireEvent(InitSucessEvent) {
                        callStateManager.fireEvent(InitSucessEvent, userInfo: nil)
                    }
                }
            }
        }
    }
    
    @objc func handleRingbackEvent(notification: NSNotification) {
        YLSDKLogger.log("handleRingbackEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyTalkRingbackNotify) {
            if callStateManager.canFireEvent(RingbackEvent) {
                callStateManager.fireEvent(RingbackEvent, userInfo: nil)
                if let tkData = notification.userInfo?[keyTalkData] as? TalkData {
                    CallServerDataSource.getInstance.saveTkData(tkdata: tkData)
                }
                SoundPlayer.getInstance.playRing()
                callManagerController.updateDisplayName()
            }
        }
    }
    
    @objc func handleTalkEstablishedEvent(notification: NSNotification) {
        YLSDKLogger.log("handleTalkEstablishedEvent notify name:" + notification.name.rawValue)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleTalkIncomeEvent(notification:)), object: nil)
        if (notification.name.rawValue == keyTalkEstablishedNotify) {
            if callStateManager.canFireEvent(EstablishedEvent) {
                UIApplication.shared.isIdleTimerDisabled = true
                callIpAddress = YLLogicAPI.get_LocalIp()  //CallIpAddress.getIPAddress(true)
                callStateManager.fireEvent(EstablishedEvent, userInfo: nil)
                SoundPlayer.getInstance.cancelRing()
                if let tkData = notification.userInfo?[keyTalkData] as? TalkData {
                    CallServerDataSource.getInstance.saveTkData(tkdata: tkData)
                    CallServerDataSource.getInstance.saveCallId(callId: Int(tkData.m_iCallID))
                }
                if (callStateManager.canFireEvent(OnTalkingEvent)) {
                    callStateManager.fireEvent(OnTalkingEvent, userInfo: nil)
                    callManagerController.talkEstablish()
                }
                
                if (UIApplication.shared.applicationState != .active) {
                    YLLogicAPI.muteVideo()
                }
            }
        }
    }
    
    @objc func handleTalkFinishedEvent(notification: NSNotification) {
        if let finishID = notification.userInfo?[keyCallID] as? Int {
            CallServerDataSource.getInstance.finishCallIds.append(finishID)
            UIApplication.shared.isStatusBarHidden = false
            YLSDKLogger.log("handleTalkFinishedEvent notify name:" + notification.name.rawValue)
            
            if (notification.name.rawValue == keyTalkFinishedNotify) && finishID == CallServerDataSource.getInstance.getCallId() {
                if (callStateManager.canFireEvent(FinishEvent)) {
                    UIApplication.shared.isIdleTimerDisabled = false
                    callStateManager.fireEvent(FinishEvent, userInfo: nil)
                    SoundPlayer.getInstance.cancelRing()
                    
                    var resultCode = 0
                    var finishCode = 0
                    if ((notification.userInfo?[keyCallResult]) != nil) {
                        if let  thisCode = notification.userInfo?[keyCallResult] as? Int {
                            resultCode = thisCode
                        }
                    }
                    if notification.userInfo?[keyFinishCode] != nil {
                        if let   thisCode = notification.userInfo?[keyFinishCode] as? Int {
                            finishCode = thisCode
                        }
                    }
                    
                    YLSDKLogger.log("handleTalkFinishedEvent resultCode = " + String(resultCode)  + " finishCode = " + String(finishCode))
                    
                    if UIApplication.shared.applicationState != .active {
                        if CallServerDataSource.getInstance.getTkData().m_isVideoTalking ==  true {
                            if callManagerController.bottmCamearBtn.isSelected == false {
                                YLLogicAPI.unmuteVideo()
                            }
                        }
                    }
                    YLSDKAlertNoButtonViewManager.getInstance.removeView()
                    if callManagerController != nil {
                        callManagerController.talkFinish {[weak self] in
                            CallServerDataSource.getInstance.iCallID = 0
                            CallServerDataSource.getInstance.tkData = nil
                            self?.callManagerController.dismiss(animated: false, completion: {
                            })
                            self?.addfinishView(resultCode: resultCode, finishCode: finishCode)
                        }
                    } else {
                        addfinishView(resultCode: resultCode, finishCode: finishCode)
                    }
                }
            }
        }
    }
    
    @objc func handleScreenShareReceivedEvent(notification: NSNotification) {
        YLSDKLogger.log("handleScreenShareReceivedEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyScreenShareReceivedNotify) {
            callManagerController.shareReceived()
            DispatchQueue.main.async {
                YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKReceivedSecondary, position: .top, block: nil)
            }
        }
    }
    
    @objc func handleScreenShareResetNotifyEvent (notification: NSNotification) {
        YLSDKLogger.log("handleScreenShareResetNotifyEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyScreenShareReceivedResetNotify) {
            callManagerController.shareReset()
        }
    }
    
    @objc func handleScreenShareStopedEvent(notification: NSNotification) {
        YLSDKLogger.log("handleScreenShareStopedEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyScreenShareStopedNotify) {
            callManagerController.shareStoped()
        }
    }
    
    @objc func handleVideoSizeChangeEvent(notification: NSNotification) {
        YLSDKLogger.log("handleVideoSizeChangeEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyVideoSizeChangeNotify) {
            callManagerController.setMainSmallVideoDisplay()
        }
    }
    
    // 通话来电处理
    @objc func handleTalkIncomeEvent(notification: NSNotification) {
        
        YLSDKLogger.log("handleTalkIncomeEvent notify name:" + notification.name.rawValue)
        if telphoneBusy == true {
            YLSDKLogger.log("Still In not login " )
            return
        }
        
        if let tkData = notification.userInfo?[keyTalkData] as? TalkData {
            if CallServerDataSource.getInstance.finishCallIds.contains(Int(tkData.m_iCallID)) {
                YLSDKLogger.log("Call Finish return" )
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleTalkIncomeEvent(notification:)), object: nil)
                return
            }
            
            if (notification.name.rawValue == keyTalkIncomingNotify) {
                if callStateManager.canFireEvent(IncomingCallEvent) {
                    callStateManager.fireEvent(IncomingCallEvent, userInfo: nil)
                    CallServerInterface.sharedManager().click(EVENT_INCOMING, respon: nil)
                    DispatchQueue.main.syncYL {[weak self ] in
                        if self == nil {
                            return
                        }
                        
                        
                        if tkData.m_iCallID > 0 {
                            CallServerDataSource.getInstance.saveCallId(callId: Int(tkData.m_iCallID))
                            CallServerDataSource.getInstance.saveTkData(tkdata: tkData)
                            CallServerDeviceSource.getInstance.dissMisspresentView()
                            if let _ = VoIPPushManager.default.callingID {
                                // voip
                                // foreground: ring and show call ui
                                // background: wait for foreground to ring and show call ui
                                if UIApplication.shared.applicationState != .background {
                                    YLSDKLogger.log("CallServerManager voip incoming foreground")
                                    
                                    AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
                                    
                                    SoundPlayer.getInstance.playIncome()
                                } else {
                                    YLSDKLogger.log("CallServerManager voip incoming background")
                                }
                            } else {
                                YLSDKLogger.log("CallServerManager ip incoming foreground")
                                
                                // ip
                                // ring and show call ui always
                                AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
                                
                                SoundPlayer.getInstance.playIncome()
                            }
                            
                            self?.callManagerController = CallManagerController()
                            self?.callManagerController.callIn()
                            if let presentVC = (self?.callManagerController) {
                                UIApplication.shared.keyWindow?.rootViewController?.present(presentVC, animated: true, completion: {
                                    RotationManager.getInstance.enableRotation = true
                                })
                            }
                            if (UIApplication.shared.applicationState != .active) {
                                if let _ = VoIPPushManager.default.callingID {
                                    return
                                }
                                let info =  tkData.m_strRemoteDisplayName
                                var body = ""
                                if let thisInfo = info {
                                    body = YLSDKLanguage.YLSDKFrom + thisInfo + YLSDKLanguage.YLSDKSPhone as String
                                    YLLocalPushManager.getInstance.registerLocalPushEvent(title: nil, body: body, info: nil, number: 0, distanceTime: 0, kCallCategory, UILocalNotificationDefaultSoundName)
                                } else {
                                    YLLocalPushManager.getInstance.addMissCallNotification()
                                }
                            }
                        }
                    }
                } else {
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleTalkIncomeEvent(notification:)), object: nil)
                    if callStateManager.isEqualState(IncomingState) {
                        if let tkData = notification.userInfo?[keyTalkData] as? TalkData {
                            if tkData.m_iCallID > 0 {
                                CallServerDataSource.getInstance.saveCallId(callId: Int(tkData.m_iCallID))
                                CallServerDataSource.getInstance.saveTkData(tkdata: tkData)
                            }
                        }
                    } else {
                        self.perform(#selector(handleTalkIncomeEvent(notification:)), with: notification, afterDelay:1)
                        
                    }
                }
            }
        }
    }
    //通话连接请求
    @objc func handleConnectionEvent(notification: NSNotification) {
        YLSDKLogger.log("handleConnectionEvent notify name:" + notification.name.rawValue)
        if (notification.name.rawValue == keyTalkConnectingNotify) {
            if let tkData = notification.userInfo?[keyTalkData] as? TalkData {
                if tkData.m_iCallID > 0 {
                    CallServerDataSource.getInstance.saveCallId(callId: Int(tkData.m_iCallID))
                    CallServerDataSource.getInstance.saveTkData(tkdata: tkData)
                }
            }
        }
    }
    //通话hold处理
    @objc func handleRemoteHoldEvent(notification: NSNotification) {
        if let talkData = notification.userInfo?[keyTalkData] as? TalkData {
            if talkData.m_bHold == true {
                CallServerDataSource.getInstance.isHold = true
                callManagerController.holdOrUnHold()
            } else {
                CallServerDataSource.getInstance.isHold = false
                callManagerController.holdOrUnHold()
            }
        }
    }
    
    @objc func handleCallidReplacedEvent(notification: NSNotification) {
        if let callID = notification.userInfo?[keyNewCallID] as? Int {
            if callID > 0 {
                let newCallId = callID
                CallServerDataSource.getInstance.saveCallId(callId: newCallId)
                let conficenData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
                if conficenData?.m_iConferencePattern != 0 {
                    callManagerController.changeYMSNumber(ymsNumber: (conficenData?.m_strNumber)!)
                }
                YLSDKLogger.log("CallManager kCallidReplacedNotification new call id = \(newCallId)")
            }
        }
    }
    
    @objc func handleMeetDescriptUpdateEvent (notification: NSNotification) {
        if let callID = notification.userInfo?[keyCallID] as? Int {
            if callID > 0 {
                callManagerController.changeYMSNumber(ymsNumber: String(callID))
            }
            YLSDKLogger.log("CallManager kCallidReplacedNotification")
        }
    }
    
    @objc func handleConfReqDeleteFailedEvent (notification: NSNotification) {
        if let callID = notification.userInfo?[keyCallID] as? Int {
            if callID > 0 && callID == CallServerDataSource.getInstance.getCallId() {
                if let failedReasonCode = notification.userInfo?[keyConfReqDeleteFailedCode] as? Int {
                    let reason =  CallReasonCodeToText.getConfEndFailedCode(reasonCode: failedReasonCode)
                    if reason.count > 0 {
                        YLSDKAlertNoButtonView.show(reason)
                    }
                }
            }
        }
    }
    
    @objc func handleUserConnectStatusEvent(notification: NSNotification) {
        inOrRejectUpdate()
    }
}
