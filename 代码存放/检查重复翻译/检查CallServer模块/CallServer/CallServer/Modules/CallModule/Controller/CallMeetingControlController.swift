//
//  CallMeetingControlController.swift
//  CallServer
//  meetingControlQueue 管理多线程
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
import YLBaseFramework
class CallMeetingControlController: YLWhiteTitleController {
    /** 统计 Verticaltable */
    var callMeetingControlTable: UITableView?
    var hostArray:Array<CallMeetingCellModel> = []
    var visitorArray:Array<CallMeetingCellModel> = []
    
    // 全部禁言
    var muteAllBtn:UIButton = {
        var button = UIButton.init()
        button.setTitle(YLSDKLanguage.YLSDKMeetingControlMuteAll, for: .normal)
        button.setTitle(YLSDKLanguage.YLSDKMeetingMemberCancelAllMuteModerator, for: .selected)
        button.setTitleColor(UIColor.dailHeaderBtnTextColor(alpha: 1), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.dailHeaderBtnTextColor(alpha: 1).cgColor
        button.titleLabel?.font = UIFont.fontWithHelvetica(14)
        return button
    }()
    
    // 锁定会议
    var lockMeetingBtn:UIButton = {
        var button = UIButton.init()
        button.setTitle(YLSDKLanguage.YLSDKMeetingControlLockMeeting, for: .normal)
        button.setTitle(YLSDKLanguage.YLSDKMeetingMemberUnlockMeeting, for: .selected)
        button.setTitleColor(UIColor.dailHeaderBtnTextColor(alpha: 1), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.dailHeaderBtnTextColor(alpha: 1).cgColor
        button.titleLabel?.font = UIFont.fontWithHelvetica(14)
        return button
    }()
    
    lazy var messageVC: MeetingMemberMessageController = {
        let vc = MeetingMemberMessageController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = YLSDKLanguage.YLSDKMeetingMemberTitle
        buildSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addRightMsgNoticeButton()
        subViewAddAttr()
        addListener()
        requestListData()
        
    }
    @objc override func clickMsgNoticeBtn() {
        presentViewControllerYL(messageVC, animated: false, completion: nil)
    }
}

extension CallMeetingControlController {
    fileprivate func addListener() {
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: keyConferencsMemberListInfoUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: kUserInOrRejectUpdateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: keyConferencsModifyRoleFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: keyConferencsRemoveUserFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: keyConferencsLockFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(handleMeetingUpdate(note:)), name: keyConfUserUpdateNotification, object: nil)
    }
    
    @objc fileprivate func handleMeetingUpdate(note:NSNotification) {
        requestListData()
    }
    
    func requestListData() {
        YLSDKLOG.log("MeetingMemberList callid: \(CallServerDataSource.getInstance.getCallId())" )

        YLSDKDispatchManager.meetingControlQueue.addOperation {
            YLSDKLogger.log("MeetingMemberList callid:\(CallServerDataSource.getInstance.getCallId())")
            YLSDKMeetingMemberListModel.InputData.init(nCallId: CallServerDataSource.getInstance.getCallId(),
                                                       usersId: [String]()).getData(name: kSdkIFGetMemberInfoList,
                                                                            BodyClass: YLSDKMeetingMemberListModel.Body.self, block: { [weak self] (body, result) in
                                                                                guard let `self` = self else { return }
                                                                                self.listDataUpdateList(result,body)
                                                       })
        }
    }
    
    fileprivate func listDataUpdateList(_ result: SdkResultStruct?, _ body: YLSDKMeetingMemberListModel.Body?) {
        if let result = result {
            print("\(result)")
            if let body = body {
                if result.type == .success {
                    var thisHostArray:Array<CallMeetingCellModel> = []
                    var hitsVisitorArray :Array<CallMeetingCellModel> = []
                    for confUserItem in body.memberInfoList {
                        let cellmeetingModel = CallMeetingCellModel()
                        cellmeetingModel.setValue(sourValue: confUserItem)
                        if cellmeetingModel.userRoalStateType == .host || cellmeetingModel.userRoalStateType == .hostSpeaking {
                            thisHostArray.append(cellmeetingModel)
                        } else {
                            hitsVisitorArray.append(cellmeetingModel)
                        }
                    }
                    ExecuteOnMainThread {[weak self] in
                        guard let `self` = self else { return }
                        self.hostArray = thisHostArray
                        self.visitorArray = hitsVisitorArray
                        self.callMeetingControlTable?.reloadData()
                    }
                }
            }
        }
    }
    // tableview 添加约束信息
    func subViewAddAttr() {
        // 获取用户角色信息 如果是
        if let callMeetingControlTable = callMeetingControlTable {
            callMeetingControlTable.snp.remakeConstraints { (make) in
                make.top.left.right.equalTo(view)
                if CallServerDataSource.getInstance.userRole == "1" {
                    make.bottom.equalToSuperview().offset(-56)
                } else {
                    make.bottom.equalToSuperview()
                }
            }
            if CallServerDataSource.getInstance.userRole == "1" {
                canAddMuteAndLockButton()
            } else {
                hiddenAddMuteAndLockButton()
            }
        }
    }
    
    func canAddMuteAndLockButton() {
        view.addSubview(lockMeetingBtn)
        view.addSubview(muteAllBtn)
        
        lockMeetingBtn.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        muteAllBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        lockMeetingBtn.isUserInteractionEnabled = true
        lockMeetingBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.dailHeaderBtnTextColor(alpha: 1)), for: .selected)
        lockMeetingBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.whiteColorAlphaYL(alpha: 1)), for: .normal)
        lockMeetingBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.whiteColorAlphaYL(alpha: 0.8)), for: .highlighted)
        lockMeetingBtn.addTarget(self, action: #selector(lockMeetingBtnClick), for: .touchUpInside)
        
        muteAllBtn.isUserInteractionEnabled = true
        muteAllBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.whiteColorAlphaYL(alpha: 1)), for: .normal)
        muteAllBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.whiteColorAlphaYL(alpha: 0.8)), for: .highlighted)
        muteAllBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.mainNoticeColorYL(alpha: 1)), for: .selected)
        muteAllBtn.addTarget(self, action: #selector(muteAllBtnClick), for: .touchUpInside)
        
        
    }
    
    func hiddenAddMuteAndLockButton() {
        muteAllBtn.removeFromSuperview()
        lockMeetingBtn.removeFromSuperview()
    }
   
    func buildSubView() {
        callMeetingControlTable = UITableView.init()
        callMeetingControlTable?.dataSource = self
        callMeetingControlTable?.delegate = self
        callMeetingControlTable?.register(CallMeetingCell.self, forCellReuseIdentifier: "CallMeetingCell")
        callMeetingControlTable?.register(CallMeetingSectionHeader.self, forHeaderFooterViewReuseIdentifier: "CallMeetingSectionHeader")
        callMeetingControlTable?.rowHeight =  64
        callMeetingControlTable?.separatorStyle = .none
        callMeetingControlTable?.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlTable
        if let callMeetingControlTable = callMeetingControlTable {
            view.addSubview(callMeetingControlTable)
        }
    }
    @objc func lockMeetingBtnClick() {
        lockMeetingBtn.isSelected = !lockMeetingBtn.isSelected
        YLSDKMeetingLockMeetingModel.InputDataInfo.init(nCallId: CallServerDataSource.getInstance.getCallId(), bLockConf: true).sdkGetData(name: kSdkIFLockConference) { (resultString) in
            YLSDKLOG.log("lockMeetingBtnClick result: \(resultString)" )
            
        }
    }
    @objc func muteAllBtnClick() {
        YLSDKMeetingAbleOrDisableMemberSpeaker.InputDataInfo.init(nCallId: CallServerDataSource.getInstance.getCallId(),usersId: [], bMute: !muteAllBtn.isSelected).getData(name: kSdkIFDisableMemberSpeaker, BodyClass: SdkInterfaceEmptyBody.self) { (body, result) in
            if let result = result {
                if result.type == .success {
                    ExecuteOnMainThread { [weak self] in
                        guard let `self` = self else { return }
                        self.muteAllBtn.isSelected =  !self.muteAllBtn.isSelected
                    }
                }
            }
        }
    }

    func cellRequestFunc(model: CallMeetingCellModel, type: meetRequestType, cell: CallMeetingCell) {
        let callID = CallServerDataSource.getInstance.getCallId()
        let userID = model.sourceDataModel.id
        let userUri = model.sourceDataModel.strUri
        YLLogger.log("cellCLickFucn :\(type), callID:\(callID), userID:\(userID) ")
        switch type {
        case .hundUp:
            break;
        case .handDown:
            break;
        case .allowHandUp:
            YLSDKMeetingAllowSpeak.InputDataInfo.init(nCallId: callID, userId: [userID], bAllow: true).getData(name: kSdkIFAllowSpeakerRequest, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("allowHandUp == success")
                    }
                }
            })

            break;
        case .disallowHandUP:
            YLSDKMeetingAllowSpeak.InputDataInfo.init(nCallId: callID, userId: [userID], bAllow: false).getData(name: kSdkIFAllowSpeakerRequest, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("disallowHandUP == success")
                    }
                }
            })

            break;
        case .mute:
            YLSDKMeetingAbleOrDisableMemberSpeaker.InputDataInfo.init(nCallId: callID, usersId: [userID], bMute: true).getData(name: kSdkIFDisableMemberSpeaker, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        ExecuteOnMainThread { 
                            cell.muteAudioBtn.isHidden = false
                            cell.muteAudioCloseBtn.isHidden = true
                        }
                    }
                }
            })
            
            break;
        case .unmute:
            YLSDKMeetingAbleOrDisableMemberSpeaker.InputDataInfo.init(nCallId: callID, usersId: [userID], bMute: false).getData(name: kSdkIFDisableMemberSpeaker, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        ExecuteOnMainThread {
                            cell.muteAudioBtn.isHidden = true
                            cell.muteAudioCloseBtn.isHidden = false
                        }
                    }
                }
            })
            
            
            break;
        case .muteVideo:
            YLSDKMeetingMuteVideoOrNotModel.InputDataInfo.init(nCallId: callID, usersId: [userID], bMuteVideo: true).getData(name: kSdkIFMuteMemberVideo, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        ExecuteOnMainThread {
                            cell.muteVideoCloseBtn.isHidden = true
                            cell.muteVideoBtn.isHidden = false
                        }
                    }
                }
            })
            
            break;
        case .unmuteVideo:
            YLSDKMeetingMuteVideoOrNotModel.InputDataInfo.init(nCallId: callID, usersId: [userID], bMuteVideo: false).getData(name: kSdkIFMuteMemberVideo, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        ExecuteOnMainThread {
                            cell.muteVideoCloseBtn.isHidden = false
                            cell.muteVideoBtn.isHidden = true
                        }
                    }
                }
            })
            break;
        case .bLecturer:
            YLSDKMeetingSetSpeaker.InputDataInfo.init(nCallId: callID, usersId: [userUri], bLecturer: true).getData(name: kSdkIFSetMemberLecturer, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("bLecturer == true")
                    }
                }
            })
            break;
        case .removeLecturerRight:
            YLSDKMeetingSetSpeaker.InputDataInfo.init(nCallId: callID, usersId: [userUri], bLecturer: false).getData(name: kSdkIFSetMemberLecturer, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("bLecturer == false")
                    }
                }
            })
            
            break;
        case .removeOutConference:
            YLSDKMeetingRemoveOutUsers.InputDataInfo.init(nCallId: callID, usersId: [userUri]).getData(name: kSdkIFRemoveConfMember, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("removeOutConference == success")
                    }
                }
            })
            break;
        case .cancelInvite:
            break;
        case .bHost:
            YLSDKMeetingModifyConfRole.InputDataInfo.init(nCallId: callID, usersId: [userUri], userRole: PRESENTER).getData(name: kSdkIFModifyConfRole, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("ModifyConfRole PRESENTER success")
                    }
                }
            })
            
            break;
        case .removeHostRight:
            YLSDKMeetingModifyConfRole.InputDataInfo.init(nCallId: callID, usersId: [userUri], userRole: ATTENDEE).getData(name: kSdkIFModifyConfRole, BodyClass: SdkInterfaceEmptyBody.self, block: { (body, result) in
                if let result = result {
                    if result.type == .success {
                        YLSDKLOG.log("ModifyConfRole ATTENDEE success")
                    }
                }
            })
            break;
            
        }
    }
}

// MARK: - 👉UITableViewDataSource

extension CallMeetingControlController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallMeetingCell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return hostArray.count
        } else if section == 1 {
            return visitorArray.count
        } else {
            return 0
        }
    }
}

// MARK: - 👉UITableViewDelegate

extension CallMeetingControlController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let callMeetingCell = cell as? CallMeetingCell {
            if indexPath.section == 0 {
                if indexPath.row < hostArray.count {
                    let hostModel = hostArray[indexPath.row]
                    callMeetingCell.updateCellByModel(model: hostModel, requestBlock: {[weak self] ( requestType) in
                        //举手等的请求操作
                        self?.cellRequestFunc(model: hostModel, type: requestType, cell: callMeetingCell)
                    })
                }
            } else if indexPath.section == 1 {
                if indexPath.row < visitorArray.count {
                    let visitorModel = visitorArray[indexPath.row]
                    callMeetingCell.updateCellByModel(model: visitorModel, requestBlock: {[weak self] (requestType) in
                         //举手等的请求操作
                        self?.cellRequestFunc(model: visitorModel, type: requestType, cell: callMeetingCell)
                    })
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && hostArray.count == 0 {
            return 0
        } else if section == 1 && visitorArray.count == 0 {
            return 0
        } else {
           return 35
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CallMeetingSectionHeader")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? CallMeetingSectionHeader {
            if section == 0 {
                headerView.titleLabel.text = "主持人"
            } else if section == 1 {
                headerView.titleLabel.text = "访客"
            }
        }
    }
}
