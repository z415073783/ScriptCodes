//
//  CallServerDataSource.swift
//  Odin-YMS
//
//  Created by Apple on 09/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

@objc class CallServerDataSource: NSObject {
  @objc  static let getInstance: CallServerDataSource = CallServerDataSource()

    
    var isAutoTest:Bool = false
    var isShowLogin: Bool = false
    /** 通话Id*/
    var iCallID: Int = 0
    /** 通话数据 */
    var tkData: TalkData!
    /** 通话丢包百分率 整数部分*/
    var lostPercentDataInt: Int = 0
    var outgoingCloseCamera: Bool = true

    var callIPOrName: String = ""
    var remoteName: String = ""

    var isHold: Bool = false
    var finishCallIds: Array<Int> = []
    var isConfience: Bool = false
    var confModel = "0" //1：CP_ADHOC 立即会议；2：CP_DEFAULT 默认讨论；3：CP_DEMONSTRATOR 主席模式
    var userRole = "0" // ConferenceUserRole: 0:CUR_NONE;1:CUR_PRESENTER 主持人;2:CUR_ATTENDEE 参与人

    public func saveCallIPOrName(callIPOrStr: String) {
        callIPOrName = callIPOrStr
    }
     @objc public func getCallIPOrName() -> String {
        return callIPOrName
    }

    public func saveCallId(callId: Int) {
        YLSDKLOG.log("callid: \(callId)")
        iCallID = callId
    }

    @objc public func getCallId() -> Int {
        return iCallID
    }
    @objc public func getRemoteName() -> String {
        return remoteName
    }

    public func saveTkData(tkdata: TalkData) {
        tkData = TalkData.init()
        tkData.m_iCallID = tkdata.m_iCallID
        tkData.m_iCallState = tkdata.m_iCallState
        tkData.m_iAccountID = tkdata.m_iAccountID
        tkData.m_isTalking = tkdata.m_isTalking
        tkData.m_isVideoTalking = tkdata.m_isVideoTalking
        tkData.m_isAudioTalking = tkdata.m_isAudioTalking
        tkData.m_isCallEncrypt = tkdata.m_isCallEncrypt
        tkData.m_bMute = tkdata.m_bMute
        tkData.m_bHold = tkdata.m_bHold
        tkData.m_bDND = tkdata.m_bDND
        tkData.m_strRemoteUserName = tkdata.m_strRemoteUserName
        tkData.m_strRemoteDisplayName = tkdata.m_strRemoteDisplayName
        tkData.m_iType = tkdata.m_iType
        tkData.m_bAudioConfMute = tkdata.m_bAudioConfMute
    }

    public func getTkData() -> TalkData {
        if tkData == nil {
            tkData = TalkData.init()
            tkData.m_iCallID = 0
            tkData.m_iCallState = 0
            tkData.m_iAccountID = 0
            tkData.m_isTalking = false
            tkData.m_isVideoTalking = false
            tkData.m_isAudioTalking = false
            tkData.m_isCallEncrypt = false
            tkData.m_bMute = false
            tkData.m_bHold = false
            tkData.m_bDND = false
            tkData.m_strRemoteUserName = ""
            tkData.m_strRemoteDisplayName = ""
            tkData.m_iType = 0
            tkData.m_bAudioConfMute = false
        }
        return tkData!
    }
    public func cleanTkData() {
        tkData = nil
    }

    public func hungup() {
        YLLogicAPI.hangUp(Int32(iCallID))
        cleanTkData()
    }

    public func answer() {
        YLLogicAPI.answer(Int32(iCallID))
    }

    public func sendDtmf(soundId: String) {
        YLLogicAPI.sendDtmfCallid(Int32(iCallID), soundId: soundId)
    }
//    /** 当前丢包率的百分比的整数部分 */
//    public func getLostPercentInt() ->Int {
//        if (lostPercentDataInt >= 21) {
//            lostPercentDataInt = 21;
//        } else if (lostPercentDataInt <= 0) {
//            lostPercentDataInt = 0;
//        }
//        return lostPercentDataInt
//    }
    /** 当前丢包率的百分比对应的显示格数 */
    public func getSingleCount() -> Int {
        if SDKNetworkManager.getInstance.reachability?.isReachable == false {
            return 0 ; // 无网络
        } else {
            if lostPercentDataInt <= 5 {
                return 4
            } else if lostPercentDataInt <= 10 {
                return 3
            } else if lostPercentDataInt <= 20 {
                return 2
            } else if lostPercentDataInt > 20 {
                return 1
            } else {
                return 1
            }
        }
    }
    /** 设置当前丢包率 */
    public func setLostDataPercentInt(currentPercentDataInt: Int) {
        if (currentPercentDataInt != lostPercentDataInt) {
            if (currentPercentDataInt >= 21 ) {
                lostPercentDataInt = 21
            } else if (currentPercentDataInt <= 0) {
                lostPercentDataInt = 0
            } else {
                lostPercentDataInt = currentPercentDataInt
            }
        }
    }

    public func showLoginVC() {
        isShowLogin = true
    }
    public func dissmissLoginVC() {
        isShowLogin = false
    }

    public func isShowLoginVC() -> Bool {
        return isShowLogin
    }

    public func getCallType() -> CallType {
        if tkData == nil {
            return CallType.unKnown
        } else if tkData.m_isVideoTalking == true {
            return CallType.video
        } else if tkData.m_isAudioTalking == true {
            return CallType.voice
        } else {
            return CallType.unKnown
        }
    }
}
