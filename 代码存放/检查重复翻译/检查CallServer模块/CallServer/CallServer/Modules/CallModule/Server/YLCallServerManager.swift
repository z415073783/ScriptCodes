//
//  CallServerManager.swift
//  Odin-YMS
//
//  Created by Apple on 25/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
// MARK: - 👉Struct define Area
typealias inviteResultFunc = (_ result: Bool?) -> Void

@objc class YLCallServerManager: YLNotifyHandleManager {
    // MARK: - 👉Property Data Area
    @objc static let getInstance: YLCallServerManager = YLCallServerManager.init()
    
    // MARK: - 👉Public Method
    @objc func getCallViewController() -> UIViewController {
        return callManagerController
    }
    
    @objc func createService() {
        telphoneBusy = false
        registerVOIPNotify()
        registerAppNotify()
        if (YLLogicAPI.isInitSucess() == true) {
            if callStateManager.canFireEvent(InitSucessEvent) {
                callStateManager.fireEvent(InitSucessEvent, userInfo: nil)
            }
        }
        if OpenSDK == false {
            VoIPPushManager.default.registerVoIPNotification()
        }
    }
    @objc func unRegisterService() {
        unregisterAppNotify()
        unregisterVOIPNotify()
    }

    // 对外OC 呼叫
    @objc func ocMakeCallWith (number: String, callType: Int, protol: Int) {
        if callType == 2 {
            makeCallWith(ipOrSip: number, callType: .voice, protol: protol)
        } else {
            makeCallWith(ipOrSip: number, callType: .video, protol: protol)
        }
    }
    
    // 对外OC 暴露 立即会议
    @objc func ocMeetingNow(numberList: NSArray, callType: Int) {
        var listInviteMember: Array<String> = []
        for item in numberList {
            if let userNumber = item as? String {
                listInviteMember.append(userNumber)
            }
        }
        if callType == 2 {
            makeYMSConfRightNow(listInviteMember: listInviteMember, callType: .voice)
        } else {
            makeYMSConfRightNow(listInviteMember: listInviteMember, callType: .video)
        }
    }
    // 对外OC 暴露 加入会议
    @objc func ocJoinMetting(strConferenceNumber: String, strUri: String, strSubject: String, meetingId: String) {
        joinYMSConf(strConferenceNumber: strConferenceNumber, strURI: strUri, strSubject: strSubject, meetingId: meetingId)
    }
    
    @objc func ocJoinMeetingNoLogin(model:YlLogingOutJoinMeetingModel) {
         joinConfNoLogin(model: model)
    }
    
    /** IP 或者 SIP 拨号*/
    func makeCallWith(ipOrSip: String, callType: CallType, protol: Int) {
        if checkNetWorkAndNotice() == false {
            return
        }
        if SDKNetworkManager.getInstance.reachability?.isReachableViaWiFi == false {
            // 移动流量 且未同意使用移动流量的情况 非音频通话 需要确认


            let alertController = UIAlertController(title: YLSDKLanguage.YLSDKWifiVideoCallNotice, message: nil, preferredStyle: .alert)
           

            let cancelAction = UIAlertAction.init(title: YLSDKLanguage.YLSDKCancel, style: .cancel, handler: { (_) in
                YLSDKLogger.log("点击取消")
            })
            
            let continueAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKContinueVideoCall, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击继续")
                self?.callWith(ipOrSip: ipOrSip, callType: callType, protol: protol)
            })
            
            let switchAudioAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKSwitchToAudio, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("转音频")
                self?.callWith(ipOrSip: ipOrSip, callType: .voice, protol: protol)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            
            cancelAction.setValue(UIColor.textBlackColorYL, forKey:"titleTextColor")
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            // 直接通话
            callWith(ipOrSip: ipOrSip, callType: callType, protol: protol)
        }
    }
    
    /*
     *
     *立即会议 Array 填写 2956  短号 短号列表中 不能还有自己的号码
     *
     */
    public func makeYMSConfRightNow(listInviteMember: Array<String>, callType: CallType) {
        if checkNetWorkAndNotice() == false {
            return
        }
        if SDKNetworkManager.getInstance.reachability?.isReachableViaWiFi == false {
            // 移动流量 且未同意使用移动流量的情况 非音频通话 需要确认

            let alertController = UIAlertController(title: YLSDKLanguage.YLSDKWifiVideoCallNotice, message: nil, preferredStyle: .alert)
           

            let cancelAction = UIAlertAction.init(title: YLSDKLanguage.YLSDKCancel, style: .cancel, handler: { (_) in
                YLSDKLogger.log("点击取消")
            })
            
            let continueAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKContinueVideoCall, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击继续")
                self?.ymsConfWith(listInviteMember: listInviteMember, callType: callType)
            })
            
            let switchAudioAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKSwitchToAudio, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击继续")
                self?.ymsConfWith(listInviteMember: listInviteMember, callType: callType)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            
            cancelAction.setValue(UIColor.textBlackColorYL, forKey:"titleTextColor")
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            // 直接通话
            ymsConfWith(listInviteMember: listInviteMember, callType: callType)
        }
    }
    
    public func joinYMSConf(strConferenceNumber: String, strURI: String, strSubject: String, meetingId: String) {
        if checkNetWorkAndNotice() == false {
            return
        }
        // 忙立即返回
        if telphoneBusy == true {
            YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKCallingPleaseTryAgainLater, position: .center, block: nil)
            return
        }

        if SDKNetworkManager.getInstance.reachability?.isReachableViaWiFi == false {
            // 移动流量 且未同意使用移动流量的情况 非音频通话 需要确认
            let alertController = UIAlertController(title: YLSDKLanguage.YLSDKWifiVideoCallNotice, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: YLSDKLanguage.YLSDKCancel, style: .cancel, handler: { (_) in
                YLSDKLogger.log("点击取消")
            })
            
            let continueAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKContinueVideoCall, style: .default, handler: {[weak self] (_) in

                if self == nil {
                    return
                }
                YLSDKLogger.log("点击继续")
                self?.joinConf(strConferenceNumber: strConferenceNumber, strURI: strURI, strSubject: strSubject, meetingId: meetingId)
            })
            
            let switchAudioAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKSwitchToAudio, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击转音频")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            
            cancelAction.setValue(UIColor.textBlackColorYL, forKey:"titleTextColor")
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            // 直接会议
            joinConf(strConferenceNumber: strConferenceNumber, strURI: strURI, strSubject: strSubject, meetingId: meetingId)
        }
    }
    
    public func joinConfNoLogin(model:YlLogingOutJoinMeetingModel) {
        if checkNetWorkAndNotice() == false { return }
        // 忙立即返回
        if telphoneBusy == true {
            YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKCallingPleaseTryAgainLater, position: .center, block: nil)
            return
        }
        if SDKNetworkManager.getInstance.reachability?.isReachableViaWiFi == false {
            // 移动流量 且未同意使用移动流量的情况 非音频通话 需要确认
            let alertController = UIAlertController(title: YLSDKLanguage.YLSDKWifiVideoCallNotice, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: YLSDKLanguage.YLSDKCancel, style: .cancel, handler: { (_) in
                YLSDKLogger.log("点击取消")
            })
            
            let continueAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKContinueVideoCall, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击继续")
                self?.joinConf(model)

            })
            
            let switchAudioAction = UIAlertAction.init(title:YLSDKLanguage.YLSDKSwitchToAudio, style: .default, handler: {[weak self] (_) in
                if self == nil {
                    return
                }
                YLSDKLogger.log("点击转音频")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            
            cancelAction.setValue(UIColor.textBlackColorYL, forKey:"titleTextColor")
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            // 直接会议
            joinConf(model)
        }
        
    }
    
    @objc public func inviteToMeeting(listInviteMember: Array<String>) {
        let result = CallInviteManager.getInstance.tryInvite(listInviteMember)
        if result {
            YLSDKLogger.log("inviteToMeeting 结果为YES")
        } else {
            YLSDKLogger.log("inviteToMeeting 结果为 false")
        }
    }
    
    
    private func dissmissFinishView() {
        if callTalkFinishView != nil {
            callTalkFinishView?.removeFromSuperview()
            callTalkFinishView = nil
            telphoneBusy = false
            CallServerDeviceSource.getInstance.iphoneDisableRoate()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kcallTalkFinishViewDissMiss), object: nil)
        }
    }
    
    func checkIfVideoAndNeedSpeakOut() {
        if callStateManager.isEqualState(OnTalkingState) || callStateManager.isEqualState(EstablishedState) {
            if callManagerController != nil && CallServerDataSource.getInstance.getCallId() > 0 {
                // 正在通话，如果是视频把 声道调整为扬声器。
                callManagerController.talkEstblishSetSpeak()
            }
        }
    }
    // MARK: - 👉Listener Area
    /** App Listener service*/

    
    // MARK: - 👉Private Method
   
    
    func checkNetWorkAndNotice() -> Bool {
        if SDKNetworkManager.getInstance.reachability?.isReachable == false {
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                YLSDKAlertView.Show(YLSDKLanguage.YLSDKTheCurrentNetworkIsNotAvailablePleaseCheckTheNetwork, message: nil, param1: YLSDKLanguage.YLSDKConfirm, param2: nil, cancel: nil, preferredStyle: .alert, target: rootVC, block: { (this ) in
                })
            }
            return false
        } else {
            return true
        }
    }
    
    
    
    /* join 会议方法**/
    func joinConf(strConferenceNumber: String, strURI: String, strSubject: String, meetingId: String) {
        DispatchQueue.main.syncYL { [weak self] in
            if self?.telphoneBusy == true {
                YLSDKLogger.log("joinConf with No:" + strURI + "busy")
                DispatchQueue.main.async {
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKCallingPleaseTryAgainLater)
                }
                return
            } else {

                if let stateManResult = (self?.callStateManager.canFireEvent(OutgoingCallEvent)) {
                    if stateManResult {
                        let callid = YLConfAPI.joinConference(strConferenceNumber, strURI: strURI, strSubject: strSubject, strEntity: meetingId)
                        
                        if callid > 0 {
                            self?.callStateManager.fireEvent(OutgoingCallEvent, userInfo: nil)
                            CallServerDataSource.getInstance.saveCallId(callId: Int(callid))
                            CallServerDataSource.getInstance.saveCallIPOrName(callIPOrStr: strSubject)
                            CallServerInterface.sharedManager().click(EVENT_CALL_OUT, respon: nil)

                            DispatchQueue.main.async {[weak self] in
                                if self == nil { return }
                                CallServerDeviceSource.getInstance.dissMisspresentView()
                                self?.callManagerController = CallManagerController()
                                self?.callManagerController.callOutPhone(isVideoCall: true)
                                if let presentVC = self?.callManagerController {
                                    UIApplication.shared.keyWindow?.rootViewController?.present(presentVC, animated: true, completion: {
                                        RotationManager.getInstance.enableRotation = true
                                    })
                                }
                            }
                        } else {
                            YLSDKLogger.log("makeCallConference with No: CallID " + String(callid) )
                            _ = YLSDKAlertNoButtonView.show("Conf Id error" + String(callid), position: .top, block: nil)
                            
                            // add finisheCover View
                            DispatchQueue.main.async {[weak self] in
                                if self == nil {
                                    return
                                }
                                self?.callTalkFinishView = CallFinishGroundView.init(frame: .zero, block: {
                                    self?.dissmissFinishView()
                                })
                                
                                self?.timers =  Timer.scheduledTimerYL(withTimeInterval: 2.5, repeats: false, block: { [weak self] (_) in
                                    self?.dissmissFinishView()
                                })
                                self?.callTalkFinishView?.subTitle.text = YLSDKLanguage.YLSDKCallFailed
                                if let finishView = self?.callTalkFinishView {
                                    UIApplication.shared.keyWindow?.addSubview(finishView)
                                }
                                self?.callTalkFinishView?.snp.makeConstraints({ (make) in
                                    make.edges.equalTo(UIApplication.shared.keyWindow!)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    /* join 会议方法**/
    func joinConf(_ model:YlLogingOutJoinMeetingModel) {
        // network ，busy 外部方法已经验证过
        YLSDKDispatchManager.callQueue.addOperation {[weak self] in
            if (self?.callStateManager.canFireEvent(OutgoingCallEvent))! {
                YLSDKJoinConfByConfIDModel.InputData(strConfID: model.confID, strPassword: model.password, strName: model.strName, strServer: model.strServer, bOpenMic: model.bOpenMic, bOpenCamera: model.bOpenCamera).sdkGetData(name: kSdkIFjoinConfByConfID, block: { [weak self ](resultString) in
                    
                    YLSDKLogger.log("\(resultString)")
                    let model =  YLSDKJoinConfByConfIDModel.OutPutInfo.deserialize(from: resultString)
                    if let callID = model?.body.callID {
                        YLSDKLogger.log("joinConference WithOut Login and CallID = " + callID.description)
                        if callID > 0 {
                            self?.callStateManager.fireEvent(OutgoingCallEvent, userInfo: nil)
                            CallServerDataSource.getInstance.saveCallId(callId: Int(callID))
                            CallServerInterface.sharedManager().click(EVENT_CALL_OUT, respon: nil)
                            DispatchQueue.main.async {[weak self] in
                                CallServerDeviceSource.getInstance.dissMisspresentView()
                                self?.callManagerController = CallManagerController()
                                self?.callManagerController.callOutPhone(isVideoCall: true)
                                if let thisCallManagerController = self?.callManagerController {
                                    UIApplication.shared.keyWindow?.rootViewController?.present(thisCallManagerController, animated: true, completion: {
                                        RotationManager.getInstance.enableRotation = true
                                    })
                                }
                            }
                        } else {
                            self?.joinConfCallIDWrong(String(callID))
                        }
                    } else {
                        self?.joinConfCallIDWrong("接口Josn返回错误")
                    }
                })
            }
        }
    }
    
    func joinConfCallIDWrong(_ callID:String) {
        YLSDKLogger.log("makeCallConference NoLogin with No: CallID " + String(callID))
//        _ = YLSDKAlertNoButtonView.show("Conf Id error" + String(callID), position: .top, block: nil)
        // add finisheCover View
        DispatchQueue.main.async {[weak self] in
            if self == nil {return}
            self?.callTalkFinishView = CallFinishGroundView.init(frame: .zero, block: {
                self?.dissmissFinishView()
            })
            self?.timers =  Timer.scheduledTimerYL(withTimeInterval: 2.5, repeats: false, block: { [weak self] (_) in
                self?.dissmissFinishView()
            })
            self?.callTalkFinishView?.subTitle.text = YLSDKLanguage.YLSDKCallFailed
            if let thisFinishView = self?.callTalkFinishView {
                UIApplication.shared.keyWindow?.addSubview(thisFinishView)
                thisFinishView.snp.makeConstraints({ (make) in
                    make.edges.equalTo(UIApplication.shared.keyWindow!)
                })
            }
        }
    }
    /* 通话实际方法**/
    func callWith(ipOrSip: String, callType: CallType, protol: Int) {
        DispatchQueue.main.syncYL { [weak self] in
            if self == nil {return}
            var isVideo: Bool =  true
            if callType == .voice {
                isVideo = false
            }
            
            if self?.telphoneBusy == true {
                YLSDKLogger.log("makeCall with No:" + ipOrSip + "busy == true" )
                DispatchQueue.main.async {

                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKCallingPleaseTryAgainLater)
                }
                return
            } else {
                if let stateMaResult = self?.callStateManager.canFireEvent(OutgoingCallEvent) {
                    if stateMaResult {
                        var callNumber = ipOrSip
                        if ipOrSip.contains(":AUTOTEST") {
                            callNumber = ipOrSip.replacingOccurrences(of: ":AUTOTEST", with: "")
                            CallServerDataSource.getInstance.isAutoTest = true
                        }
                        
                        let callid = YLLogicAPI.makeCall(Int32(protol), isVideo: isVideo, callNumber: callNumber, dialType: 0)
                        if callid > 0 {
                            UIApplication.shared.isIdleTimerDisabled = true
                            
                            YLSDKLogger.log("makeCall succeed CallID = " + String(callid))
                            
                            self?.callStateManager.fireEvent(OutgoingCallEvent, userInfo: nil)
                            CallServerDataSource.getInstance.saveCallId(callId: Int(callid))
                            CallServerDataSource.getInstance.saveCallIPOrName(callIPOrStr: ipOrSip)
                            CallServerInterface.sharedManager().click(EVENT_CALL_OUT, respon: nil)
                            
                            DispatchQueue.main.async {[weak self] in
                                CallServerDeviceSource.getInstance.dissMisspresentView()
                                self?.callManagerController = CallManagerController()
                                self?.callManagerController.callOutPhone(isVideoCall: isVideo)
                                if let presentVC =  (self?.callManagerController) {
                                    UIApplication.shared.keyWindow?.rootViewController?.present(presentVC, animated: true, completion: {
                                        RotationManager.getInstance.enableRotation = true
                                    })
                                }
                            }
                        } else {
                            YLSDKLogger.log("makeCall with No:" + ipOrSip + " CallID " + String(callid))
                            

                            _ = YLSDKAlertNoButtonView.show("Call Id error:" + String(callid), position: .top, block: nil)
                            
                            // add finisheCover View
                            DispatchQueue.main.async {[weak self] in
                                if self == nil {
                                    return
                                }
                                self?.callTalkFinishView = CallFinishGroundView.init(frame: .zero, block: {
                                    self?.dissmissFinishView()
                                })
                                
                                self?.timers =  Timer.scheduledTimerYL(withTimeInterval: 2.5, repeats: false, block: { [weak self] (_) in
                                    self?.dissmissFinishView()
                                })
                                self?.callTalkFinishView?.subTitle.text = YLSDKLanguage.YLSDKCallFailed
                                if let finishView = (self?.callTalkFinishView) {
                                    UIApplication.shared.keyWindow?.addSubview(finishView)
                                    finishView.snp.makeConstraints({ (make) in
                                        make.edges.equalTo(UIApplication.shared.keyWindow!)
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    /* 立即会议实际方法**/
    func ymsConfWith(listInviteMember: Array<String>, callType: CallType) {
        DispatchQueue.main.syncYL { [weak self] in
            var isVideo: Bool =  true
            if callType == .voice {
                isVideo = false
            }
            if self?.telphoneBusy == true {

                YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKCallingPleaseTryAgainLater)
                return
            } else {
                if let thisResult = self?.callStateManager.canFireEvent(OutgoingCallEvent) {
                    if thisResult {
                        let inviteMembers = NSMutableArray()
                        var inviteArray: Array<CallInvitePersonDataModel> = []
                        for objStr in listInviteMember {
                            inviteMembers.add(objStr)
                            let person = CallInvitePersonDataModel()
                            person.number = objStr
                            person.inviteState = 0
                            inviteArray.append(person)
                        }
                        let callid = YLConfAPI.createConference(inviteMembers, isVideoCall: isVideo)
                        if callid > 0 {
                            UIApplication.shared.isIdleTimerDisabled = true
                            self?.callStateManager.fireEvent(OutgoingCallEvent, userInfo: nil)
                            CallServerDataSource.getInstance.saveCallId(callId: Int(callid))
                            CallServerInterface.sharedManager().click(EVENT_CALL_OUT, respon: nil)

                            DispatchQueue.main.async {[weak self] in
                                if self == nil {
                                    return
                                }
                                self?.callManagerController = CallManagerController()
                                self?.callManagerController.callOutConf(isVideoCall: isVideo)
                                if let presentVC = (self?.callManagerController) {
                                    UIApplication.shared.keyWindow?.rootViewController?.present(presentVC, animated: true, completion: {
                                        RotationManager.getInstance.enableRotation = true
                                    })
                                }

                            }
                        } else {
                            // add finisheCover View
                            DispatchQueue.main.async {[weak self] in
                                if self == nil {
                                    return
                                }
                                self?.callTalkFinishView = CallFinishGroundView.init(frame: .zero, block: {
                                    self?.dissmissFinishView()
                                })
                                
                                self?.timers =  Timer.scheduledTimerYL(withTimeInterval: 2.5, repeats: false, block: { [weak self] (_) in
                                    self?.dissmissFinishView()
                                })
                                self?.callTalkFinishView?.subTitle.text = YLSDKLanguage.YLSDKCallFailed
                                UIApplication.shared.keyWindow?.addSubview((self?.callTalkFinishView)!)
                                self?.callTalkFinishView?.snp.makeConstraints({ (make) in
                                    make.edges.equalTo(UIApplication.shared.keyWindow!)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

