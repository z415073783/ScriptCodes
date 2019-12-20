//
//  CallInviteManager.swift
//  Odin-YMS
//
//  Created by Apple on 01/07/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class CallInviteManager: NSObject {
    static let getInstance: CallInviteManager = CallInviteManager.init()

//    var inviteArray:Array<CallInviteDataModel> = []


    var alerTimer: YLTimer?

    var alertTitleArray: Array<String> = []

    var isSelfInvited: Bool = false

    let lock: NSRecursiveLock = NSRecursiveLock()
    override init() {
        super.init()
        alerTimer =  Timer.scheduledTimerYL(withTimeInterval: 1.5, repeats: true, block: { [weak self](_) in

            if self?.alertTitleArray.count == 0 {
                return
            }

            DispatchQueue.main.asyncYL {[weak self] in
                if self == nil {
                    return
                }
                if let thisTitleArrayCount = (self?.alertTitleArray.count) {
                    if thisTitleArrayCount > 0 {
                        let title = self?.alertTitleArray.first
                        _ = YLSDKAlertNoButtonView.show(title!, position: .center, block: nil)
                        self?.alertTitleArray.removeFirst()
                        if self?.alertTitleArray.count == 0 {
                            if self?.checKifTopNoticeCanDismiss() == true {
                                self?.perform(#selector(self?.topNoticeDismiss), with: nil, afterDelay: 3)
                            }
                        }
                    }
                }
            }
        })
    }

    func clean() {
        YLSDKAlertNoButtonViewManager.getInstance.removeView()
        alertTitleArray = []
        isSelfInvited =  false
    }

    func meetingNow(_ meetingNowArray: Array<CallInvitePersonDataModel>) {
        isSelfInvited = true
        DispatchQueue.main.asyncYL {[weak self] in
            if self == nil {
                return
            }
            if YLSDKAlertNoButtonViewManager.getInstance.residentView != nil {
                YLSDKAlertNoButtonViewManager.getInstance.removeView()
            }
        }
    }

    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(confInviteUserFailed(note:)), name: keyConfInviteUserFailedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userInOrReject(note:)), name: kUserInOrRejectUpdateNotification, object: nil)
    }

    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: keyConfInviteUserFailedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: kUserInOrRejectUpdateNotification, object: nil)
    }

    // 邀请用户失败
    @objc func confInviteUserFailed(note: NSNotification) {
        if let member  = note.userInfo?[keyConfInviteMember] as? String {
            if let failedCode = note.userInfo?[keyConfInviteFailedCode] as? Int {
                YLSDKLogger.debug("CallManager keyConfInviteUserFailedNotification :" + member )
                
                let resonResult = CallReasonCodeToText.getMeetingInviteFailedCode(failedCode: failedCode) 
                let person = CallInvitePersonDataModel()
                person.number = member
                person.inviteState = -1
                if person.name.count > 0 {
                    let title = person.name + resonResult
                    alertTitleArray.append(title)
                } else {
                    let title = person.number + YLSDKLanguage.YLSDKFail
                    alertTitleArray.append(title)
                }
                setAllInviteArrayResult(person)
            }
        }
    }

    //加入或离开会议
    @objc func userInOrReject(note: NSNotification) {
        YLSDKLogger.debug("CallManager kUserInOrRejectUpdateNotification")

        if CallServerDataSource.getInstance.getCallId() == 0 {
            return
        }
        let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))

        if let addOrRemove = note.userInfo?["IsConfUserConnected"] as? Int {
            if addOrRemove == 1 {
                if callData != nil && callData?.m_strLastJoinedUser != nil {
                    if let inArray = YLConfAPI.getPreviousJoinedMembers(Int32(CallServerDataSource.getInstance.getCallId())) {
                        if  (inArray.count) > 1 {
                            for item in inArray {
                                if let number = item as? String {
                                    let person = CallInvitePersonDataModel()
                                    person.number = number
                                    person.inviteState = 1
                                    if person.name.count > 0 {
                                        let title = person.name + YLSDKLanguage.YLSDKjoinsTheConference
                                        alertTitleArray.append(title)
                                    } else {
                                        let title = person.number + YLSDKLanguage.YLSDKjoinsTheConference
                                        alertTitleArray.append(title)
                                    }
                                    setAllInviteArrayResult(person)
                                }
                            }
                        } else {
                            if let thisLastJoinUser = (callData?.m_strLastJoinedUser) {
                                let title = thisLastJoinUser + YLSDKLanguage.YLSDKjoinsTheConference
                                alertTitleArray.append(title)
                            }
                            
                            let person = CallInvitePersonDataModel()
                            if let thisCallLastJoinID = callData?.m_strLastJoinedID {
                                if thisCallLastJoinID != "" {
                                    person.number = thisCallLastJoinID
                                } else {
                                    if (callData?.m_strLastJoinedUser.contains("(")) == true {
                                        if let realNumber = callData?.m_strLastJoinedUser.components(separatedBy: "(").first {
                                            person.number = realNumber
                                        }
                                    }
                                }
                                person.inviteState = 1
                                setAllInviteArrayResult(person)
                            }
                        }
                    }
                }
            } else if addOrRemove == 0 {
                if callData != nil && callData?.m_strLastLeaveUser != nil {
                    if let thisLeaveUser = (callData?.m_strLastLeaveUser) {
                        let title = thisLeaveUser + YLSDKLanguage.YLSDKleavesTheConference
                        alertTitleArray.append(title)
                    }
                }
            }
            YLCallServerManager.getInstance.inOrRejectUpdate()
        }
    }

    func setAllInviteArrayResult(_ person: CallInvitePersonDataModel) {
//        for item in allInviteArray {
//            if item.number == person.number {
//                item.inviteState = person.inviteState
//            } else if item.name == person.name {
//                item.inviteState = person.inviteState
//            }
//        }
//        updateTopTitle()
    }

    func updateTopTitle() {
        // 判断发起人是否是自己
//        if  isSelfInvited ==  false {
//            return
//        }
//        let allCount = allInviteArray.count
//        var succeedCout = 0
//
//        for item in allInviteArray {
//            if item.inviteState == 1 {
//                succeedCout = succeedCout + 1
//            }
//        }
//        let title = localizedSDK(key: "Group call No.") + String(succeedCout) + "/" + String(allCount)
//
//        DispatchQueue.main.asyncYL {[weak self] in
//            if self == nil {
//                return
//            }
//            if YLSDKAlertNoButtonViewManager.getInstance.residentView == nil {
//                _ = YLSDKAlertNoButtonView.show(title, position: .resident, block: nil)
//            } else {
//                YLSDKAlertNoButtonViewManager.getInstance.setAttribute(sender: nil)
//                YLSDKAlertNoButtonViewManager.getInstance.setText(sender: title)
//            }
//        }
    }

    func checKifTopNoticeCanDismiss() -> Bool {
//        for item in allInviteArray {
//            if item.inviteState == 0 {
//                return false
//            }
//        }
        return true
    }

    @objc func topNoticeDismiss() {
        YLSDKAlertNoButtonViewManager.getInstance.removeView()
        YLCallServerManager.getInstance.inOrRejectUpdate()
    }

   func tryInvite(_ inviteArray: Array<String>) -> Bool {
        isSelfInvited = true
        if inviteArray.count > 0 {
            let result = YLConfAPI.inviteMember(Int32(CallServerDataSource.getInstance.getCallId()), members:  NSMutableArray(array: inviteArray), isDialIn: false)

//            if result == true {
//                lock.lock()
//                for inviteNumber in inviteArray {
//                    var number = inviteNumber
//                    if inviteNumber.contains(":") {
//                        let realNumber = inviteNumber.components(separatedBy: ":")
//                        if let thisRealNumber = realNumber.last {
//                            number = thisRealNumber
//                        }
//                    }
//                    if checkAllInviteArraycontainsAndSetInviting(number) == false {
//                        let addPerson = CallInvitePersonDataModel()
//                        addPerson.number = number
//                        addPerson.inviteState = 0
//                        allInviteArray.append(addPerson)
//                    }
//                }
//                lock.unlock()
//
//                let firstInvitePerson = CallInvitePersonDataModel()
//                if let firstInviteNumber = inviteArray.first {
//                    var number = firstInviteNumber
//                    if (firstInviteNumber.contains(":")) {
//
//                        let realNumber = firstInviteNumber.components(separatedBy: ":")
//                        if let thisNumber = realNumber.last {
//                            number = thisNumber
//                        }
//                    }
//                    firstInvitePerson.number = number
//                    var title = ""
//                    if inviteArray.count > 1 {
//                        if firstInvitePerson.name != "" {
//                            title = localizedSdk(key: "Invite ") + firstInvitePerson.name + localizedSdk(key: "... Join the meeting")
//                        } else {
//                            title = localizedSdk(key: "Invite ") + firstInvitePerson.number + localizedSdk(key: "... Join the meeting")
//                        }
//                    } else {
//                        if firstInvitePerson.name != "" {
//                            title = localizedSdk(key: "Invite ") + firstInvitePerson.name + YLSDKLanguage.YLSDKjoinsTheConference
//                        } else {
//                            title = localizedSdk(key: "Invite ") + firstInvitePerson.number + YLSDKLanguage.YLSDKjoinsTheConference
//                        }
//                    }
//                    alertTitleArray.append(title)
//                }
//            }
            return result
        }
        return false
    }
    /*遍历allInviteArray 将已包含人员的状态设为Inviting 没有包含返回false  */
    func checkAllInviteArraycontainsAndSetInviting(_ inviteNumber: String) -> Bool {
//        for item in allInviteArray {
//            if item.number == inviteNumber {
//               item.inviteState = 0
//                return true
//            }
//        }
        return false
    }
}
