//
//  CallManagerUIGusterVC.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class CallManagerUIGusterVC: CallManagerUIMethodVC {
    // MARK: - 👉UI GE Area
    @objc func singleShareScrollTapView(_ ge: UIGestureRecognizer) {
        let taouchpoint = ge.location(in: shareScrollView )
        let containtPointFlag = bottomContainerView.frame.contains(taouchpoint)
        if containtPointFlag == true {
            return
        }
        YLSDKLogger.log("singleTapView")
        if RotationManager.getInstance.openRotation == false {
            lockScreemBtnAutoHide()
            return
        }
        if bottomeMenuHide == true {
            if moreView == nil || moreView?.alpha == 0 {
                bottomContainerShow()
                startbottomContainerHide()
            } else {
                cancleDismissMenu()
            }
        } else {
            bottomContainerHide()
            if moreView != nil {
                moreView?.alpha = 0
                if moreAngeleView != nil {
                    moreAngeleView?.alpha = 0
                }
                moreBtnLocation()
            }
        }
    }
    @objc func singleMainScrollTapView(_ ge: UIGestureRecognizer) {
        let taouchpoint = ge.location(in: contentView)
        let containtPointFlag = bottomContainerView.frame.contains(taouchpoint)
        if containtPointFlag == true {
            return
        }
        YLSDKLogger.log("singleTapView")
        if RotationManager.getInstance.openRotation == false {
            lockScreemBtnAutoHide()
            return
        }
        
        if bottomeMenuHide == true {
            if moreView == nil || moreView?.alpha == 0 {
                bottomContainerShow()
                startbottomContainerHide()
            } else {
                cancleDismissMenu()
            }
        } else {
            bottomContainerHide()
            if moreView != nil {
                moreView?.alpha = 0
                if moreAngeleView != nil {
                    moreAngeleView?.alpha = 0
                }
                moreBtnLocation()
            }
        }
    }
    @objc func doubleMainScrollTapView(_ ge: UIGestureRecognizer) {
        if RotationManager.getInstance.openRotation == false { return }
        let taouchpoint = ge.location(in: mainScrollView)
        let containtPointFlag = smallVideoView.frame.contains(taouchpoint)
        if containtPointFlag == true {
            return
        }
        
        if bottomeMenuHide == false {
            let bottomContaintPointFlag = bottomContainerView.frame.contains(taouchpoint)
            if bottomContaintPointFlag == true {
                return
            }
        }
        
        if mainScrollView?.zoomScale == mainScrollView?.minimumZoomScale {
            if let newScal = mainScrollView?.maximumZoomScale {
                let centerPoint = ge.location(in: mainScrollView)
                var zoomRect = CGRect.init()
                if let thisMainScrollView = mainScrollView {
                    zoomRect.size.height = thisMainScrollView.bounds.size.height / newScal
                    zoomRect.size.width = thisMainScrollView.bounds.size.width / newScal
                    zoomRect.origin.x = centerPoint.x - (zoomRect.size.width / 2.0)
                    zoomRect.origin.y = centerPoint.y - (zoomRect.size.height / 2.0)
                    mainScrollView?.zoom(to: zoomRect, animated: true)
                }
            }
        } else {
            if let thisMinMumZoomScale = mainScrollView?.minimumZoomScale {
                mainScrollView?.setZoomScale(thisMinMumZoomScale, animated: true)
            }
        }
    }
    
    @objc func doubleShareScrollTapView(_ ge: UIGestureRecognizer) {
        if RotationManager.getInstance.openRotation == false { return }
        let taouchpoint = ge.location(in: shareScrollView)
        let containtPointFlag = smallVideoView.frame.contains(taouchpoint)
        if containtPointFlag == true {
            return
        }
        
        if shareScrollView?.zoomScale == shareScrollView?.minimumZoomScale {
            if let newScal = shareScrollView?.maximumZoomScale {
                let centerPoint = ge.location(in: shareScrollView)
                var zoomRect = CGRect.init()
                if let thisShareScrollView = shareScrollView {
                    zoomRect.size.height = thisShareScrollView.bounds.size.height / newScal
                    zoomRect.size.width = thisShareScrollView.bounds.size.width / newScal
                    zoomRect.origin.x = centerPoint.x - (zoomRect.size.width / 2.0)
                    zoomRect.origin.y = centerPoint.y - (zoomRect.size.height / 2.0)
                    shareScrollView?.zoom(to: zoomRect, animated: true)
                }
            }
        } else {
            if let thisMinimumZoomScale = shareScrollView?.minimumZoomScale {
                shareScrollView?.setZoomScale(thisMinimumZoomScale, animated: true)
            }
        }
    }
    
    func addlisterForSpeaker() {
        removelisterForSpeaker()
        NotificationCenter.default.addObserver(self, selector: #selector(audioRoteChange), name: kAudioOutputModeChangedNotification, object: nil)
    }
    
    func removelisterForSpeaker() {
        NotificationCenter.default.removeObserver(self, name: kAudioOutputModeChangedNotification, object: nil)
    }
    
    func talkEstblishSetSpeak() {
        if isVideo == true {
            //视频 扬声器
            AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
        } else {
            //音频 听筒
            AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
        }
    }
    @objc func audioRoteChange() {
        DispatchQueue.main.async {[weak self] in
            if self == nil {
                return
            }
            let outputMode =  AudioRouteManager.getInstance.audioOutputMode
            // 发送 notice info
            if self?.isVideo ==  true {
                return
            }
            if outputMode ==  "Headphone" {
                //使用耳機
                self?.bottmSpeakerBtn.isSelected = false
                self?.isAddNewDevice = true
            } else if outputMode ==  "Built-In Receiver" {
                // 使用听筒
                self?.bottmSpeakerBtn.isSelected = false
            } else if outputMode == "Speaker" {
                self?.bottmSpeakerBtn.isSelected = true
                //使用扬声器
            }
        }
    }
    
    
    
    
    @objc func hungUpBtnClick() {
        if isConficen == true {
            let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
            if callData != nil && callData?.m_dataMe != nil && callData?.m_dataMe.m_iRoleUser != nil  && callData?.m_dataMe.m_iRoleUser == 1 {
                // 主持人结束会议
                let titleAttr = NSMutableAttributedString.init(string: YLSDKLanguage.YLSDKLeaveOrEndConf)
                titleAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.textGrayColorYL, range: NSRange.init(location: 0, length: titleAttr.string.count))
                
                let endAttr = NSMutableAttributedString.init(string: YLSDKLanguage.YLSDKEndConf)
                endAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.mainNoticeColorYL(alpha: 1), range: NSRange.init(location: 0, length: endAttr.string.count))
                
                let leaveAttr = NSMutableAttributedString.init(string: YLSDKLanguage.YLSDKLeaveConf)
                leaveAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.mainColorYL, range: NSRange.init(location: 0, length: leaveAttr.string.count))
                
                let alertSheet = YLDailListSection(frame: .zero)
                UIApplication.shared.keyWindow?.addSubview(alertSheet)
                
                alertSheet.updateHeaderFromBottomView(sheetTitleArray: [YLSDKLanguage.YLSDKLeaveOrEndConf, YLSDKLanguage.YLSDKEndConf, YLSDKLanguage.YLSDKLeaveConf], textColor: UIColor.mainColorYL, sheetAttrTitleArray: [titleAttr, endAttr, leaveAttr], titleBgcolor:UIColor.titleBackGroudColorYL, block: {[weak self] (title) in
                    if self == nil { return }
                    //离开，其它人继续会议
                    if title == YLSDKLanguage.YLSDKLeaveConf {
                        YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
                    } else if title == YLSDKLanguage.YLSDKEndConf {
                        YLConfAPI.finish_Conference(Int32(CallServerDataSource.getInstance.getCallId()))
                    }
                    CallServerInterface.sharedManager().click(EVENT_HANP_UP, respon: nil)
                })
                if let thisView = (self.view) {
                    alertSheet.snp.remakeConstraints { (make) in
                        make.edges.equalTo(thisView)
                    }
                }
                return
            }
        }
        YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
        CallServerInterface.sharedManager().click(EVENT_HANP_UP, respon: nil)
    }
    @objc func switchCamearBtnClick() {
        if switchCamearBtn.isSelected == true {
            return
        }
        if isVideo == true {
            switchCamearBtn.isSelected = true
            CallServerInterface.sharedManager().click(EVENT_SWITCH_CAMERA, respon: nil)
            YLSDKDispatchManager.callQueue.addOperation {[weak self] in
                if self == nil {
                    return
                }
                CallServerDeviceSource.getInstance.switchCamear(block: {
                    DispatchQueue.main.asyncYL { [weak self] in
                        if self == nil {
                            return
                        }
                        self?.switchCamearBtn.isSelected = false
                    }
                })
            }
        }
    }
    
    @objc func changeScreemBtnClick() {
        if RotationManager.getInstance.enableRotation == true {
            changeScreemBtn.isEnabled = false
            if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                RotationManager.getInstance.setOrientationType(sender: .landscapeRight)
                CallServerInterface.sharedManager().click(EVENT_FULL_SCREEN, respon: nil)
            } else {
                RotationManager.getInstance.setOrientationType(sender: .portrait)
                CallServerInterface.sharedManager().click(EVENT_EXIT_FULL_SCREEN, respon: nil)
            }
        } else {
            if isVideo ==  true {
                if UIInterfaceOrientationIsLandscape (UIApplication.shared.statusBarOrientation) {
                    YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKPleaseUnlock, position: .top, block: nil)
                } else {
                    changeScreemBtn.isEnabled = true
                    RotationManager.getInstance.openRotation = true
                    RotationManager.getInstance.enableRotation = true
                    
                    lockScreemBtn.setImage(#imageLiteral(resourceName: "lock_screen_nor"), for: .normal)
                    lockScreemBtn.setImage(#imageLiteral(resourceName: "lock_screen_pre"), for: .highlighted)
                }
            }
        }
        lockScreemBtnAutoHide()
    }
    
    @objc func lockScreemBtnClick() {
        if RotationManager.getInstance.openRotation == true {
            RotationManager.getInstance.openRotation = false
            RotationManager.getInstance.enableRotation = false
            RotationManager.getInstance.setOrientationType(sender: UIApplication.shared.statusBarOrientation)
            bottomContainerView.alpha = 0
            lockScreemBtn.setImage(#imageLiteral(resourceName: "unlock_screen_nor"), for: .normal)
            lockScreemBtn.setImage(#imageLiteral(resourceName: "unlock_screen_pre"), for: .highlighted)
            allHide()
            
            mainScrollView?.isUserInteractionEnabled = false
            
            
            if shareScrollView != nil {
                shareScrollView?.isUserInteractionEnabled = false
            }
            smallVideoView.videoHideShowBtn.isEnabled = false
            CallServerInterface.sharedManager().click(EVENT_LOCK_SCREEN, respon: nil)
        } else {
            RotationManager.getInstance.openRotation = true
            RotationManager.getInstance.enableRotation = true
            bottomContainerView.alpha = 1
            lockScreemBtn.setImage(#imageLiteral(resourceName: "lock_screen_nor"), for: .normal)
            lockScreemBtn.setImage(#imageLiteral(resourceName: "lock_screen_pre"), for: .highlighted)
            allshow()
            
            mainScrollView?.isUserInteractionEnabled = true
            
            
            if shareScrollView != nil {
                shareScrollView?.isUserInteractionEnabled = true
            }
            smallVideoView.videoHideShowBtn.isEnabled = true
            CallServerInterface.sharedManager().click(EVENT_UNLOCK_SCREEN, respon: nil)
        }
    }
    
    func smallVideoViewBtnClick() {
        if RotationManager.getInstance.openRotation == false { return }
        removeMainSmallVideoDisplay()
        if mainVideoType == LogicVideoType.LvtRemote {
            mainVideoType = LogicVideoType.LvtLocal
            smallVideoType = LogicVideoType.LvtRemote
            if smallVideoView.videoHideShowBtn.isSelected == false {
                smallVideoViewSet(width: 160, hight: 90)
            }
            smallVideoRealVideSet(width: 160, hight: 90)
        } else if mainVideoType == LogicVideoType.LvtLocal {
            mainVideoType = LogicVideoType.LvtRemote
            smallVideoType = LogicVideoType.LvtLocal
            
            if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                if smallVideoView.videoHideShowBtn.isSelected == false {
                    smallVideoViewSet(width: 90, hight: 160)
                }
                smallVideoRealVideSet(width: 90, hight: 160)
            } else {
                if smallVideoView.videoHideShowBtn.isSelected == false {
                    smallVideoViewSet(width: 160, hight: 90)
                }
                smallVideoRealVideSet(width: 160, hight: 90)
            }
        }
        self.perform(#selector(setMainSmallVideoDisplay), with: nil, afterDelay: 0.35)
        setMuteHoldNotice()
    }
    
    @objc func bottmDtmfBtnClick() {
        if dtmfView == nil {
            dtmfView = CallDtmfView.init(frame: .zero)
            
        }
        
        if let thisDtmfView = dtmfView {
            view.addSubview(thisDtmfView)
            thisDtmfView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(view)
            })
        }
        CallServerInterface.sharedManager().click(EVENT_SHOW_DTMF, respon: nil)
        
    }
    
    // 视频mute和取消视频mute
    @objc func bottmCamearBtnClick() {
        if bottmCamearBtn.tag != 0 {
            return
        }
        bottmCamearBtn.isSelected = !bottmCamearBtn.isSelected
        bottmCamearBtn.tag = 1
        if bottmCamearBtn.isSelected == true {
            CallServerInterface.sharedManager().click(EVENT_VIDEO_MUTE, respon: nil)
        } else {
            CallServerInterface.sharedManager().click(EVENT_AUDIO_UNMUTE, respon: nil)
        }
        DispatchQueue.global().async {[weak self] in
            if self == nil {
                return
            }
            if self?.bottmCamearBtn.isSelected == true {
                YLLogicAPI.muteVideo()
                self?.muteVideoViewSet()
                DispatchQueue.main.sync {
                    if self == nil {
                        return
                    }
                    self?.switchCamearBtn.isEnabled = false
                    self?.switchCamearBtn.isSelected = true
                    self?.bottmCamearBtn.tag = 0
                }
            } else {
                YLLogicAPI.unmuteVideo()
                self?.muteVideoViewSet()
                DispatchQueue.main.sync {
                    if self == nil {
                        return
                    }
                    self?.switchCamearBtn.isEnabled = true
                    self?.switchCamearBtn.isSelected = false
                    self?.bottmCamearBtn.tag = 0
                }
            }
        }
    }
    
    @objc func bottmInviteBtnClick() {
        showInviteSheet()
    }
    @objc func bottmMemberListBtnClick() {
        let meetController = CallMeetingControlController()
        presentVC = meetController
        let nav = UINavigationController.init(rootViewController: meetController)
        present(nav, animated: true, completion: nil)
    }
    
    /** 听筒扬声器切换效果 */
    @objc func bottmSpeakerBtnClick(_ button: UIButton) {
        YLSDKDispatchManager.callQueue.addOperation {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                if AudioRouteManager.getInstance.hasHeadsetPlugged() {
                    
                    if AudioRouteManager.getInstance.audioRouteHasOverrided {
                        AudioRouteManager.getInstance.setAudioModeOverride2None()
                    } else {
                        AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
                    }
                    
                } else {
                    if AudioRouteManager.getInstance.isSpeakerOutputMode() == true {
                        AudioRouteManager.getInstance.setAudioMode2Handset()
                        CallServerInterface.sharedManager().click(EVENT_SPEAKER_OFF, respon: nil)
                    } else {
                        AudioRouteManager.getInstance.setAudioMode2HandFree()
                        CallServerInterface.sharedManager().click(EVENT_SPEAKER_ON, respon: nil)
                    }
                }
            } else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                if AudioRouteManager.getInstance.isSpeakerOutputMode() ==  true {
                    AudioRouteManager.getInstance.setAudioModeOverride2None()
                } else {
                    AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
                }
            }
        }
    }
    
    @objc func handUpBtnClick() {
        let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
        if isConficen == true {
            if callData != nil && callData?.m_dataMe != nil {
                if callData?.m_dataMe.m_iRoleUser == 2 && callData?.m_iConferencePattern == 3 && callData?.m_dataMe.m_bMuteByServer == true {
                    if callData?.m_dataMe.m_bRequestSpeak == true {
                        //手X
                        YLConfAPI.cancelRequestSpeak(Int32(CallServerDataSource.getInstance.getCallId()))
                        YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouHaveCancelledYourSpeakingApplication, position: .top, block: nil)
                        CallServerInterface.sharedManager().click(EVENT_CANCEL_HAND_UP, respon: nil)
                    }  else if callData?.m_dataMe.m_bRequestSpeak == false {
                        //手
                        //当前在禁言状态 申请发言
                        YLConfAPI.requestSpeak(Int32(CallServerDataSource.getInstance.getCallId()))
                        YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKYouAreSendingSpeakingApplication, position: .top, block: nil)
                        CallServerInterface.sharedManager().click(EVENT_HAND_UP, respon: nil)
                    }
                    
                }
            }
        }
    }
    
    // 静音，解开静音点击
    @objc func muteBtnClick() {
        muteBtn.isSelected = !muteBtn.isSelected
        setMuteState()
        let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
        if isConficen == true {
            if callData != nil && callData?.m_dataMe != nil {
                
                let model = IConferenceUserData()
                if let thisAudioID = (callData?.m_dataMe.m_nAudioId) {
                    model.m_nAudioId = thisAudioID
                }
                model.m_strUri = callData?.m_dataMe.m_strUri
                model.m_strId = callData?.m_dataMe.m_strId
                
                let isAllow = YLConfAPI.disableMemberSpeak(Int32(CallServerDataSource.getInstance.getCallId()), userData: model, isDisable: muteBtn.isSelected)
            }
        }
    }
    
    @objc func bottmMoreBtnClick() {
        if moreView == nil {
            let addUserModel = CallMoreCellDataModel()
            addUserModel.titleStr = YLSDKLanguage.YLSDKInviteMembers
            addUserModel.imageNorName = "more_add_users"
            addUserModel.type = CallMoreCellType.addUser
            
            let dtmfModel = CallMoreCellDataModel()
            dtmfModel.titleStr = YLSDKLanguage.YLSDKDialKeyboard
            dtmfModel.imageNorName = "more_dtmf"
            dtmfModel.type = CallMoreCellType.dTMF
            
            let changeAudioModel = CallMoreCellDataModel()
            changeAudioModel.titleStr = YLSDKLanguage.YLSDKChangeAudio
            changeAudioModel.imageNorName = "more_change_audio"
            changeAudioModel.type = CallMoreCellType.changeAudio
            
            let closeOpenSmallWINModel = CallMoreCellDataModel()
            
            closeOpenSmallWINModel.showSelectView = smallVideoView.videoHideShowBtn.isSelected
            closeOpenSmallWINModel.titleStr = YLSDKLanguage.YLSDKHideSmallWindow
            closeOpenSmallWINModel.imageNorName = "more_small_window_close"
            
            closeOpenSmallWINModel.titleStrSel = YLSDKLanguage.YLSDKShowSmallSindow
            closeOpenSmallWINModel.iamgeSelName = "more_small_window_open"
            closeOpenSmallWINModel.type = CallMoreCellType.smallWindow
            
            var moreElements: Array<CallMoreCellDataModel> = []
            if  isVideo == true {
                if isConficen ==  true {
                    moreElements = [addUserModel, dtmfModel]
                } else {
                    moreElements = [dtmfModel]
                }
            } else {
                if isConficen ==  true {
                    moreElements = [addUserModel, dtmfModel]
                } else {
                    moreElements = []
                }
            }
            // 判断是否是发言模式
            moreView = CallMoreView.init(frame: .zero, elements: moreElements, block: {[weak self] (dataModel, cell) in
                self?.bottmMoreBtnClick()
                if dataModel.type == CallMoreCellType.smallWindow {
                    if self?.smallVideoView.videoHideShowBtn.isSelected == false {
                        dataModel.showSelectView = true
                        self?.smallVideoView.hideOrShowSmallVideo(isHide: true)
                        cell.iconImageView.image = UIImage.init(named: dataModel.imageNorName)
                        cell.iconLabel.text = dataModel.titleStr
                    } else {
                        dataModel.showSelectView = false
                        self?.smallVideoView.hideOrShowSmallVideo(isHide: false)
                        cell.iconImageView.image = UIImage.init(named: dataModel.iamgeSelName)
                        cell.iconLabel.text = dataModel.titleStrSel
                    }
                } else if dataModel.type == CallMoreCellType.dTMF {
                    if self?.dtmfView == nil {
                        self?.dtmfView = CallDtmfView.init(frame: .zero)
                    }
                    
                    if let thisView = self?.view {
                        if let thisDtmfView = self?.dtmfView {
                            thisView.addSubview(thisDtmfView)
                            self?.dtmfView?.snp.remakeConstraints({ (make) in
                                make.edges.equalTo(thisView)
                            })
                        }
                    }
                    
                    CallServerInterface.sharedManager().click(EVENT_SHOW_DTMF, respon: nil)
                    
                } else if dataModel.type == CallMoreCellType.addUser {
                    self?.showInviteSheet()
                } else if dataModel.type == CallMoreCellType.changeAudio {
//                    CallServerDataSource.getInstance.getTkData().m_isVideoTalking = false
//                    self?.talkEstablish() // 通话变更为音频
                }
            })
            if let thisMoreView = moreView {
                UIApplication.shared.keyWindow?.addSubview(thisMoreView)
            }
            moreBtnLocation()
            moreAngeleView = CallAngleView.init(frame: .zero)
            if let thisMoreAngeleView = moreAngeleView {
                bottomContainerView.addSubview(thisMoreAngeleView)
                thisMoreAngeleView.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize.init(width: 15, height: 6))
                    make.top.equalTo((bottomContainerView))
                    make.centerX.equalTo(bottmMoreBtn)
                }
            }
            cancleDismissMenu()
        } else {
            if moreView?.alpha ==  1 {
                moreView?.alpha = 0
                if moreAngeleView != nil {
                    moreAngeleView?.alpha = 0
                }
                moreBtnLocation()
                startbottomContainerHide()
            } else {
                moreView?.alpha = 1
                if moreAngeleView != nil {
                    moreAngeleView?.alpha = 1
                }
                moreBtnLocation()
                cancleDismissMenu()
            }
        }
    }
}
