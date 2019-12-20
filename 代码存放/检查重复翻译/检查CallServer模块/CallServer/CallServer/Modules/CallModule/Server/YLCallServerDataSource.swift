//
//  YLCallServerDataSource.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class YLCallServerDataSource: NSObject {
    // 外部传入底部navagationcontroller
    var rootViewController: UIViewController?  //[[UIApplication sharedApplication] keyWindow].rootViewController;
    /** 通话状态机 */
    var callStateManager: CallStateMachine = CallStateMachine()
    var isEstblish: Bool = false
    /** login 时 不能通话的控制字段 */
    var telphoneBusy: Bool =  false
    /** 是否通过UserID 拨号，YES：是 ，NO： 否，（IP 或着SPI 拨号） */
    var isUserIDCall: Bool = false
    /** 通话协议选择  iProtocol 拨号界面选择拨号类型：0，自动；1：云账号；2：H323或sip帐号*/
    var iProtocol: Int = 0
    
    /** 计时器 YLTimer*/
    var watchTimer: YLTimer?
    /** pickup计时器 YLTimer*/
    var timers: YLTimer?
    /** 计时器 TimeInterval*/
    var talkTimeInterval: TimeInterval?
    /**  通话统计反馈 每次重置到0 以后提示 网络丢包率较高*/
    var showNoticeCountTimer: Int = 0
    var isFinish: Bool = false
    /** 同意使用移动流量每次APP重新启动 设为False*/
    //    var agreeUseMobileTrafficData: Bool = false;
    /** 是否设为演讲者 设为False*/
    var isLecturer: Bool = false
    
    /** 是否设为主持人 设为False*/
    var isPrestent: Bool = false
    
    /** 是否网络变化 设为False*/
    var callIpAddress: String = ""
    // MARK: - 👉Property UI Area
    /** 语音视频通话VC */
    
    var _callManagerController: CallManagerController?
    var callManagerController: CallManagerController! {
        set {
            _callManagerController = newValue
        }
        get {
            return _callManagerController
        }
    }
    
    var callTalkFinishView: CallFinishGroundView?
    
    var  finishClickbutton: UIButton?
    
    
    func noticePrestent(_ code: Int) {
        if CallServerDataSource.getInstance.getCallId() == 0 && callManagerController == nil {
            return
        }
        let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
        
        if callData != nil && callData?.m_dataMe != nil {
            // 角色和会议数据更新
            if callData?.m_iConferencePattern != 0 {
                CallServerDataSource.getInstance.isConfience = true
                if let confModel = callData?.m_iConferencePattern  {
                    CallServerDataSource.getInstance.confModel = String(format: "%d", confModel)
                }
                if let userRole = callData?.m_dataMe.m_iRoleUser {
                    CallServerDataSource.getInstance.userRole = String(format: "%d", userRole)
                }
            }
            if callData?.m_iConferencePattern == 3 || callData?.m_iConferencePattern == 2 {
                if callData?.m_dataMe.m_bLecturer == true && isLecturer == false {
                    
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreSetAsALecturer, position: .top, block: nil)
                    isLecturer = true
                } else if callData?.m_dataMe.m_bLecturer == false && isLecturer == true {
                    isLecturer = false
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYourLecturerRoleHasBeenCancelled, position: .top, block: nil)
                }
                if callData?.m_dataMe.m_iRoleUser == 1 && isPrestent == false {
                    isPrestent = true
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreSetAsAModerator, position: .top, block: nil)
                } else if callData?.m_dataMe.m_iRoleUser == 2 && isPrestent == true {
                    isPrestent = false
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreSetAsAGuest, position: .top, block: nil)
                }
            }
            let flag = Int16(code)
            
            if userCodeFlag(flag: flag, judge: Int16(0x00000008)) > 0 {
                if userCodeFlag(flag: flag, judge: Int16(0x00000001)) > 0 && callData?.m_dataMe.m_bAudioMute == false {
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYourSpeakingApplicationHasBeenAllowed, position: .center, block: nil)
                    if let thisAudioMute = callData?.m_dataMe.m_bAudioMute {
                        callManagerController.muteorUnmuteNoteChange(ismute: thisAudioMute)
                    }
                } else {
                    if callData?.m_dataMe.m_bRequestSpeak == true {
                        // 申请发言
                    } else {
                        YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYourSpeakingApplicationHasBeenRefused, position: .center, block: nil)
                    }
                }
            }
            
            if code == 1 {
                let currNumber: String? = YLLogicAPI.get_CurrentNumber()
                var currName = ""
                if currNumber != nil {
                    currName = YLContactAPI.searchCloudName(byNumber:currNumber)
                }
                if callData?.m_dataMe.m_bAudioMute == false  && callData?.m_dataMe.m_bMuteByServer == false {
                    if currName != callData?.m_strOrganizer {
                        
                        if callManagerController.muteLabel.text != YLSDKLanguage.YLSDKMute {
                            YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreUnmutedByModerator, position: .center, block: nil)
                        }
                    }
                } else if  callData?.m_dataMe.m_bMuteByServer == true  && callData?.m_dataMe.m_bAudioMute == true {
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreMutedByModerator, position: .center, block: nil)
                }
                if let thisAudioMute = callData?.m_dataMe.m_bAudioMute {
                    callManagerController.muteorUnmuteNoteChange(ismute:thisAudioMute)
                }
            }
        }
    }
    
    func addfinishView(resultCode: Int, finishCode: Int) {
        self.timers =  Timer.scheduledTimerYL(withTimeInterval: 2.5, repeats: false, block: { [weak self] (_) in
            self?.dissmissSelf()
        })
        // add finisheCover View
        callTalkFinishView = CallFinishGroundView.init(frame: .zero, block: {[weak self] in
            if self == nil {
                return
            }
            self?.dissmissSelf()
        })
        if let time = callManagerController.talkTimeStartInterval {
            let result = CallReasonCodeToText.getCallfinisheCode(resultCode: resultCode, finishCode: finishCode, timeStart: time)
            callTalkFinishView?.mainTitle.text = result.mainTitle
            callTalkFinishView?.subTitle.text = result.subtitle
        } else {
            let result = CallReasonCodeToText.getCallfinisheCode(resultCode: resultCode, finishCode: finishCode, timeStart: 0)
            callTalkFinishView?.mainTitle.text = result.mainTitle
            callTalkFinishView?.subTitle.text = result.subtitle
        }
        if let callIpAddressEnd = YLLogicAPI.get_LocalIp() {
            if callIpAddressEnd != callIpAddress && callIpAddress != "" {
                callTalkFinishView?.subTitle.text = YLSDKLanguage.YLSDKTheCurrentCallHasBeenInterruptedByANetworkSwitchPleaseTryToCallAgain 
                callIpAddress = callIpAddressEnd
            }
        }
        if let finishView = callTalkFinishView {
            UIApplication.shared.keyWindow?.addSubview(finishView)
            finishView.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIApplication.shared.keyWindow!)
            })
        }
    }
    
    func dissmissSelf() {
        if(callStateManager.canFireEvent(ToIdleEvent)) {
            YLSDKLogger.log("Dismiss Self")
            if timers != nil {
                telphoneBusy = false
                timers?.invalidate()
                timers = nil
                if callTalkFinishView != nil {
                    callTalkFinishView?.removeFromSuperview()
                    callTalkFinishView = nil
                }
                CallServerDeviceSource.getInstance.iphoneDisableRoate()
                YLSDKDispatchManager.callQueue.cancelAllOperations();
                callManagerController = nil
                CallServerDataSource.getInstance.iCallID = 0
                CallServerDataSource.getInstance.saveCallIPOrName(callIPOrStr: "")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kcallTalkFinishViewDissMiss), object: nil)
                CallInviteManager.getInstance.clean()
            }
            callStateManager.fireEvent(ToIdleEvent, userInfo: nil)
            CallServerInterface.sharedManager().click(EVENT_CALL_FINISHVIEW_DISSMISS, respon: nil)
        }
    }
    
    func userCodeFlag(flag: Int16, judge: Int16) -> Int16 {
        return (flag & judge)
    }
    
    public func inOrRejectUpdate() {
        if  callManagerController != nil {
            DispatchQueue.main.syncYL {[weak self] in
                if self == nil { return }
                self?.callManagerController.inOrRejectUpdate()
            }
        }
    }
    
}
