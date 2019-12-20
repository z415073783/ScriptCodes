//
//  CallManagerUIMethodVC.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class CallManagerUIMethodVC: CallManagerUIController {
    func moreBtnLocation() {
        if moreView == nil || view.window == nil {
            return
        }
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                moreView?.snp.remakeConstraints { (make) in
                    make.right.equalTo(view).offset(-4)
                    make.bottom.equalTo(bottomContainerView.snp.top)
                    make.width.equalTo(154)
                    if isConficen == true {
                        make.height.equalTo(90)
                    } else if isVideo == true {
                        make.height.equalTo(45)
                    }
                }
            } else {
                moreView?.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(bottmMoreBtn.snp.centerX)
                    make.bottom.equalTo(bottomContainerView.snp.top)
                    make.width.equalTo(154)
                    if isConficen == true {
                        make.height.equalTo(90)
                    } else if isVideo == true {
                        make.height.equalTo(45)
                    }
                }
            }
        } else {
            moreView?.snp.remakeConstraints { (make) in
                make.centerX.equalTo(bottmMoreBtn.snp.centerX)
                make.bottom.equalTo(bottomContainerView.snp.top)
                make.width.equalTo(154)
                if isConficen == true {
                    make.height.equalTo(90)
                } else if isVideo == true {
                    make.height.equalTo(45)
                }
            }
        }
    }
    @objc func swipeLeft() {
        
        if isZomming ==  true {
            return
        }
        if isReceivedShareData == false {
            return
        }
        mainScrollView?.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            if self == nil {
                return
            }
            if self?.isReceivedShareData == true {
                if let thisView = (self?.view) {
                    self?.mainScrollView?.snp.remakeConstraints { (make) in
                        make.edges.equalTo(thisView)
                    }
                }
                
                if let thisMainScrollView = (self?.mainScrollView) {
                    self?.shareScrollView?.snp.remakeConstraints { (make) in
                        make.top.bottom.equalTo(thisMainScrollView)
                        make.width.equalTo(thisMainScrollView)
                        make.right.equalTo(thisMainScrollView.snp.left)
                    }
                }
                self?.view.layoutIfNeeded()
            }
            
        }) { [weak self] (_) in
            if self == nil {
                return
            }
            
            if self?.isReceivedShareData == true {
                self?.shareNoticebtn?.setTitle(YLSDKLanguage.YLSDKSeeSecondaryFlow , for: .normal)
                self?.shareNoticebtn?.addTarget(self, action: #selector(self?.swipeRight), for: .touchUpInside)
                
                self?.control?.currentPage = 1
                if let thisView = (self?.view) {
                    self?.mainScrollView?.snp.remakeConstraints { (make) in
                        make.edges.equalTo(thisView)
                    }
                }
                
                if let thisMainScrollView = (self?.mainScrollView) {
                    self?.shareScrollView?.snp.remakeConstraints { (make) in
                        make.top.bottom.equalTo(thisMainScrollView)
                        make.width.equalTo(thisMainScrollView)
                        make.right.equalTo(thisMainScrollView.snp.left)
                    }
                }
            }
        }
    }
    
    @objc func swipeRight() {
        
        if isZomming ==  true {
            return
        }
        shareScrollView?.alpha = 1
        
        if isReceivedShareData == false {
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            if self == nil {
                return
            }
            if self?.isReceivedShareData == true {
                if let thisView = (self?.view) {
                    self?.shareScrollView?.snp.remakeConstraints { (make) in
                        make.edges.equalTo(thisView)
                    }
                }
                
                if let thisShareScrollView = (self?.shareScrollView) {
                    self?.mainScrollView?.snp.remakeConstraints { (make) in
                        make.top.bottom.equalTo(thisShareScrollView)
                        make.width.equalTo(thisShareScrollView)
                        make.left.equalTo(thisShareScrollView.snp.right)
                    }
                }
                self?.view.layoutIfNeeded()
            }
        }) { [weak self](_) in
            if self == nil {
                return
            }
            if self?.isReceivedShareData == true {
                self?.shareNoticebtn?.setTitle(YLSDKLanguage.YLSDKViewVideo, for: .normal)
                self?.shareNoticebtn?.addTarget(self, action: #selector(self?.swipeLeft), for: .touchUpInside)
                self?.control?.currentPage = 0
                if let thisView = (self?.view) {
                    self?.shareScrollView?.snp.remakeConstraints { (make) in
                        make.edges.equalTo(thisView)
                    }
                }
                
                if let thisShareScrollView = (self?.shareScrollView) {
                    self?.mainScrollView?.snp.remakeConstraints { (make) in
                        make.top.bottom.equalTo(thisShareScrollView)
                        make.width.equalTo(thisShareScrollView)
                        make.left.equalTo(thisShareScrollView.snp.right)
                    }
                }
            }
        }
    }
    
    func muteVideoViewSet() {
        DispatchQueue.main.async { [weak self] in
            if self == nil {
                return
            }
            if self?.mainVideoView.superview == nil {
                return
            }
            
            if self?.bottmCamearBtn.isSelected == true {
                if self?.mainVideoType == .LvtLocal {
                    self?.mainScrollView?.isScrollEnabled = false
                    self?.videoMuteViewBig = CallLocalVideoMuteView.init(frame: .zero, isSmall: false)
                    if let thisVideoMuteViewBig = (self?.videoMuteViewBig) {
                        if let thisMainVideoView = self?.mainVideoView {
                            thisMainVideoView.addSubview(thisVideoMuteViewBig)
                            thisVideoMuteViewBig.snp.remakeConstraints({ (make) in
                                make.edges.equalTo(thisMainVideoView)
                            })
                        }
                    }
                    self?.smallVideoView.videMuteView.alpha = 0
                } else if self?.smallVideoType == .LvtLocal {
                    self?.mainScrollView?.isScrollEnabled = true
                    if self?.videoMuteViewBig != nil {
                        self?.videoMuteViewBig?.snp.removeConstraints()
                        self?.videoMuteViewBig?.removeFromSuperview()
                        self?.videoMuteViewBig = nil
                    }
                    self?.smallVideoView.videMuteView.alpha = 1
                    self?.videoMuteViewBig?.alpha = 0
                }
            } else {
                if self?.videoMuteViewBig != nil {
                    self?.videoMuteViewBig?.snp.removeConstraints()
                    self?.videoMuteViewBig?.removeFromSuperview()
                    self?.videoMuteViewBig = nil
                }
                self?.smallVideoView.videMuteView.alpha = 0
                self?.videoMuteViewBig?.alpha = 0
                if self?.mainScrollView != nil {
                    self?.mainScrollView?.isScrollEnabled = true
                }
            }
        }
    }
    
    func showInviteSheet() {
        if self.isViewLoaded && view.window != nil {
            let alertSheet = YLDailListSection(frame: .zero)
            alertSheet.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingInvieSheet
            UIApplication.shared.keyWindow?.addSubview(alertSheet)
            // Bundle Identifier SDK 判断
            if OpenSDK == false {
                let alertSheet = YLAlertActionSheet()
                let inviteContactSheet = YLAlertActionSheetItem.normalInstance(
                    YLSDKLanguage.YLSDKInviteContact,
                    action: {(item) in
                        CallServerInterface.sharedManager().click(EVENT_INVITE_CONTACT, respon: nil)
                })
                inviteContactSheet.textColor = UIColor.mainColorYL
                
                let inviteSip323Sheet = YLAlertActionSheetItem.normalInstance(
                    YLSDKLanguage.YLSDKInviteH323SIP,
                    action: {(item) in
                        CallServerInterface.sharedManager().click(EVENT_INVITE_IP, respon: nil)
                })
                inviteSip323Sheet.textColor = UIColor.mainColorYL
                
                let shareMeetingSheet = YLAlertActionSheetItem.normalInstance(
                    YLSDKLanguage.YLSDKSharingMeetingInformation,
                    action: {[weak self](item) in
                        guard let `self` = self else { return }
                        
                        guard let callProperty = getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId())) else { return }
                        
                        guard let profile = YLLogicAPI.get_SipProfile(1) else { return }
                        
                        let server = profile.m_strServer
                        let outbound = profile.m_strOutboundServer
                        
                        var password = ""
                        if let p = callProperty.m_strJoinPassword, p.count > 0 {
                            password = p
                        }
                        
                        var shareString = String(format: "%@邀请您参与视频会议",
                                                 callProperty.m_dataMe.m_strName)
                        shareString += String(format: "\n主题：%@",
                                              callProperty.m_strSubject)
                        // TODO: 增加会议起止时间
                        shareString += String(format: "\n时间：%@",
                                              "")
                        shareString += String(format: "\n会议号码：%@",
                                              callProperty.m_strNumber)
                        shareString += String(format: "\n密码：%@",
                                              password)
                        
                        shareString += "\n\n入会方式："
                        shareString += "\n\n1) 登录Yealink桌面客户端或者手机移动客户端，如您已接收到会议邀请，可在设备上直接“一键入会”直接加入会议；"
                        shareString += String(format: "\n\n如你未接收到会议邀请，请拨打会议号码 %@并根据语音输入会议密码%@，并以#号键结束。",
                                              callProperty.m_strNumber,
                                              password)
                        var sipCall = ""
                        if let target = server, target.count > 0 {
                            sipCall += String(format: "%@**%@@%@",
                                              callProperty.m_strNumber,
                                              password,
                                              target)
                        }
                        if let target = outbound, target.count > 0 {
                            if sipCall.count > 0 {
                                sipCall += "或"
                            }
                            sipCall += String(format: "%@**%@@%@",
                                              callProperty.m_strNumber,
                                              password,
                                              target)
                        }
                        shareString += String(format: "\n\n2) 通过其他SIP终端，请拨打%@直接加入会议。",
                                              sipCall)
                        
                        var h232Call = ""
                        if let target = server, target.count > 0 {
                            h232Call += String(format: "%@##%@**%@",
                                               target,
                                               callProperty.m_strNumber,
                                               password)
                        }
                        if let target = outbound, target.count > 0 {
                            if h232Call.count > 0 {
                                h232Call += "或"
                            }
                            h232Call += String(format: "%@##%@**%@",
                                               target,
                                               callProperty.m_strNumber,
                                               password)
                        }
                        shareString += String(format: "\n\n3) 通过其他H.323终端，请拨打%@加入会议。",
                                              h232Call)
                        
                        if let target = server, target.count > 0 {
                            shareString += String(format: "\n\n4) 通过浏览器入会，请直接访问http://%@",
                                                  target)
                        }
                        else if let target = outbound, target.count > 0 {
                            shareString += String(format: "\n\n4) 通过浏览器入会，请直接访问http://%@",
                                                  target)
                        }
                        
                        let sdkRespon = YLSdkRespon.init()
                        sdkRespon.shareString = shareString
                        let res = CallServerInterface.sharedManager().click(EVENT_SHARE_CONFERENCE_INFO, respon: sdkRespon)
                        if let res = res, res.handleReuslt {
                            return
                        }
                        
                        YLSystemShareManager.shared.share(withItems: [shareString])
                })
                shareMeetingSheet.textColor = UIColor.mainColorYL
                
                alertSheet.addItem(inviteContactSheet)
                alertSheet.addItem(inviteSip323Sheet)
                if CallServerDataSource.getInstance.isConfience == true {
                    // 是会议才添加
                    alertSheet.addItem(shareMeetingSheet)
                }
                alertSheet.cancelItem = YLAlertActionSheetItem.cancelInstance(YLSDKLanguage.YLSDKCancel)
                alertSheet.show()
            } else {
                
                let alertSheet = YLAlertActionSheet()
                let inviteContactSheet = YLAlertActionSheetItem.normalInstance(
                    YLSDKLanguage.YLSDKInviteContact,
                    action: {(item) in
                        CallServerInterface.sharedManager().click(EVENT_INVITE_CONTACT, respon: nil)
                })
                inviteContactSheet.textColor = UIColor.mainColorYL
                alertSheet.addItem(inviteContactSheet)
                alertSheet.cancelItem = YLAlertActionSheetItem.cancelInstance(YLSDKLanguage.YLSDKCancel)
                alertSheet.show()
            }
        }
    }
    
    func showInviteNotice() {
        //锁屏
        if RotationManager.getInstance.openRotation == false { return }
        if self.isViewLoaded == true && (view.window != nil) {
            smallVideoView.isHidden = true
            if YLSDKAlertNoButtonViewManager.getInstance.residentView == nil {
                let attrTitle = NSMutableAttributedString.init(string: YLSDKLanguage.YLSDKConfOnlyOneperson + "\n" + YLSDKLanguage.YLSDKClickToInvite)
                let range = NSRange.init(location: YLSDKLanguage.YLSDKConfOnlyOneperson.count + 1 , length: YLSDKLanguage.YLSDKClickToInvite.count)
                attrTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.mainColorYL, range: range)
                attrTitle.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor.mainColorYL, range: range)
                attrTitle.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
                attrTitle.addAttribute(NSAttributedStringKey.link, value:URL(fileURLWithPath: ""), range: range)
                YLSDKAlertNoButtonView.showAttribute(attribute: attrTitle,
                                                     position: .resident,
                                                     touchBlock: nil,
                                                     block: {[weak self] (_) in
                                                        guard let `self` = self else { return }
                                                        if RotationManager.getInstance.openRotation == false { return }
                                                        self.showInviteSheet()
                                                        
                                                        
                })
            }
        }
    }
    
    func setMuteHoldNotice() {
        if isVideo == true {
            if muteNoticeView != nil {
                muteNoticeView?.removeFromSuperview()
                muteNoticeView?.snp.removeConstraints()
                muteNoticeView = nil
            }
            if muteBtn.isSelected == true  && isMute == true {
                muteNoticeView = UIImageView()
                muteNoticeView?.image = UIImage.init(named: "headPhone_mute")
                if mainVideoType == .LvtLocal {
                    if let thisMuteNoticeView = muteNoticeView {
                        view.addSubview(thisMuteNoticeView)
                        thisMuteNoticeView.snp.remakeConstraints({ (make) in
                            make.width.equalTo(30)
                            make.height.equalTo(30)
                            make.right.equalTo(view.snp.right).offset(-12)
                            make.top.equalTo(view).offset(80)
                        })
                    }
                } else if smallVideoType == .LvtLocal {
                    if let thisMuteNoticeView = muteNoticeView {
                        smallVideoView.addSubview(thisMuteNoticeView)
                        thisMuteNoticeView.snp.remakeConstraints({ (make) in
                            make.width.equalTo(15)
                            make.height.equalTo(15)
                            make.right.equalTo(smallVideoView.snp.right).offset(-4)
                            make.top.equalTo(smallVideoView).offset(4)
                        })
                    }
                }
            }
        }
    }
    
    // 普通模式 （非发言）
    func setMuteState() {
        DispatchQueue.global().async {[weak self] in
            if self == nil {
                return
            }
            if self?.muteBtn.isSelected == true {
                YLLogicAPI.mute()
                self?.isMute = true
                CallServerInterface.sharedManager().click(EVENT_AUDIO_MUTE, respon: nil)
            } else {
                YLLogicAPI.uMute()
                self?.isMute = false
                CallServerInterface.sharedManager().click(EVENT_AUDIO_UNMUTE, respon: nil)
            }
            DispatchQueue.main.async { [weak self] in
                if self == nil {
                    return
                }
                self?.setMuteHoldNotice()
            }
        }
    }
    func startbottomContainerHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(bottomContainerHide), object: nil)
        self.perform(#selector(bottomContainerHide), with: nil, afterDelay: 5.0)
    }
    
    /** 通话取消自动隐藏  */
    func cancleDismissMenu() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(bottomContainerHide), object: nil)
        bottomContainerShow()
    }
    
    /** 底部menu 隐藏  */
    @objc func bottomContainerHide() {
        if (isVideo == false) {
            return
        }
        if CallServerDataSource.getInstance.isAutoTest {
            return
        }
        if isTalkEstablish == false {
            return
        }
        if self.isViewLoaded == false || self.view.window == nil {
            return
        }
        bottomeMenuHide = true
        bottomContainerView.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
            titleLabel.isHidden =  true
            subTitleLabel.isHidden =  true
            titleLableEncryptImage.isHidden = true
            callinfoTimeView?.isHidden = true
            if RotationManager.getInstance.openRotation == true {
                lockScreemBtn.isHidden = true
            }
            changeScreemBtn.isHidden = true
            switchCamearBtn.isHidden = true
            UIApplication.shared.isStatusBarHidden = true
        } else {
            titleLabel.isHidden =  false
            subTitleLabel.isHidden =  false
            titleLableEncryptImage.isHidden = false
            callinfoTimeView?.isHidden =  false
            UIApplication.shared.isStatusBarHidden = false
            lockScreemBtn.isHidden = true
            changeScreemBtn.isHidden = true
            switchCamearBtn.isHidden = true
        }
        view.layoutIfNeeded()
    }
    
    /** 底部menu 显示  */
    func bottomContainerShow() {
        bottomeMenuHide = false
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                bottomContainerView.snp.remakeConstraints({ (make) in
                    make.height.equalTo(178)
                    make.left.right.bottom.equalTo(view)
                })
            } else {
                bottomContainerView.snp.remakeConstraints({ (make) in
                    make.height.equalTo(92)
                    make.left.right.bottom.equalTo(view)
                })
            }
        } else {
            bottomContainerView.snp.remakeConstraints { (make) in
                make.bottom.left.right.equalTo(view)
                make.height.equalTo(113)
            }
        }
        
        switchCamearBtn.isHidden = false
        titleLabel.isHidden =  false
        subTitleLabel.isHidden =  false
        titleLableEncryptImage.isHidden = false
        callinfoTimeView?.isHidden =  false
        changeScreemBtn.isHidden = false
        switchCamearBtn.isHidden = false
        if isVideo == true && (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
            lockScreemBtn.isHidden = false
            lockScreemBtnAutoHide()
        } else {
            lockScreemBtn.isHidden = true
        }
        UIApplication.shared.isStatusBarHidden = false
        view.layoutIfNeeded()
    }
    
    func lockScreemBtnAutoHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(lockScreemBtnHide), object: nil)
        lockScreemBtn.isHidden = false
        self.perform(#selector(lockScreemBtnHide), with: nil, afterDelay: 5.0)
    }
    
    @objc func lockScreemBtnHide() {
        if CallServerDataSource.getInstance.isAutoTest {
            return
        }
        lockScreemBtn.isHidden = true
    }
    
    func allHide() {
        bottomContainerHide()
        changeScreemBtn.isHidden = true
        switchCamearBtn.isHidden = true
        if shareNoticebtn != nil {
            shareNoticebtn?.isHidden = true
        }
    }
    func allshow() {
        bottomContainerShow()
        startbottomContainerHide()
        if shareNoticebtn != nil {
            shareNoticebtn?.isHidden = false
        }
        changeScreemBtn.isHidden = false
        switchCamearBtn.isHidden = false
    }
    
    func removeMainSmallVideoDisplay() {
        YLLogicAPI.removeLayout(mainVideoView, viewId: 0, eLayoutType: Int32(mainVideoType.rawValue))
        YLLogicAPI.removeLayout(smallVideoView.videoView, viewId: 0, eLayoutType: Int32(smallVideoType.rawValue))
    }
    
    @objc func setMainSmallVideoDisplay() {
        YLSDKDispatchManager.callQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            // 防止同话结束时还在setlayout
            if self?.timers == nil {
                return
            }
            if self?.isConficen == true {
                let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
                DispatchQueue.main.sync {
                    if callData?.m_listMember == nil || callData?.m_listMember.count == 0 {
                        self?.showInviteNotice()
                    } else {
                        self?.smallVideoView.isHidden = false
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    self?.smallVideoView.isHidden = false
                }
            }
            
            YLLogicAPI.setMyLayout(self?.mainVideoView, viewId: 0, eLayoutType: Int32((self?.mainVideoType.rawValue)!))
            YLSDKLOG.log("smallVideoView set layout")
            YLLogicAPI.setMyLayout(self?.smallVideoView.videoView, viewId: 0, eLayoutType: Int32((self?.smallVideoType.rawValue)!))
            if self?.isReceivedShareData == true {
                if self?.shareVideoView != nil {
                    YLLogicAPI.setMyLayout(self?.shareVideoView, viewId: 0, eLayoutType: Int32((self?.secondVideoType.rawValue)!))
                }
            }
        }
    }
    
    
    func smallVideoViewSet(width: Float, hight: Float) {
        smallVideoView.snp.remakeConstraints({ (make) in
            make.height.equalTo(hight)
            make.width.equalTo(width)
            make.right.equalTo(view)
            make.bottom.equalTo(bottomContainerView.snp.top)
        })
    }
    
    func smallVideoRealVideSet(width: Float, hight: Float) {
        smallVideoView.videoView.snp.remakeConstraints({ (make) in
            make.left.top.equalTo(smallVideoView)
            make.height.equalTo(hight)
            make.width.equalTo(width)
        })
    }
    func screenChange() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            changeScreemBtn.setImage(#imageLiteral(resourceName: "full_screen_nor"), for: .normal)
            changeScreemBtn.setImage(#imageLiteral(resourceName: "full_screen_pre"), for: .highlighted)
            
            lockScreemBtn.alpha = 0
            lockScreemBtn.isHidden = true
        } else {
            changeScreemBtn.setImage(#imageLiteral(resourceName: "exit_full_screen_nor"), for: .normal)
            changeScreemBtn.setImage(#imageLiteral(resourceName: "exit_full_screen_pre"), for: .highlighted)
            lockScreemBtn.alpha = 1
            lockScreemBtn.isHidden = false
            lockScreemBtnAutoHide()
            changeScreemBtn.isEnabled =  false
        }
        changeScreemBtn.isEnabled = true
    }
    
    func bgImageViewSetColorImage() {
        bgImageView.image = UIImage.init(named: "full_size_render")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5), resizingMode: .stretch)
    }
    func removeThisView(view: UIView) {
        view.snp.removeConstraints()
        view.removeFromSuperview()
    }
    
    //近场感应
    func distanceFeel() {
        if isVideo == true {
            UIDevice.current.isProximityMonitoringEnabled = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceProximityStateDidChange, object: nil)
        } else {
            UIDevice.current.isProximityMonitoringEnabled = true
            if (UIDevice.current.isProximityMonitoringEnabled == false) {
                YLSDKLogger.log("距离传感器不可用")
            }
        }
    }
    
    func removeDistanceFell() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    
    @objc func proximitySensorChange(notification: NSNotification) {
        //有插耳机直接返回
        if AudioRouteManager.getInstance.isHeadsetPluggedIn() {
            return
        }
        // IPAD 没有听筒不用调整
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            return
        }
        if isVideo == true {
            return
        }
        if UIDevice.current.proximityState == true {
            //接近
            YLSDKDispatchManager.callQueue.addOperation {
                AudioRouteManager.getInstance.setAudioMode2Handset()
            }
        } else {
            //远离
            YLSDKDispatchManager.callQueue.addOperation {
                AudioRouteManager.getInstance.setAudioModeOverride2Speaker()
            }
        }
    }
}

// MARK: - 👉UIScrollViewDelegate
extension CallManagerUIMethodVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isReceivedShareData ==  true {
            if scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width {
                if scrollView.contentOffset.x - historySharePointX > 20  &&         scrollView.tag == ScrollViewType.shareScroll.rawValue {
                    swipeLeft()
                }
            } else  if scrollView.contentOffset.x  <= 0 {
                if scrollView.tag == ScrollViewType.mainScroll.rawValue {
                    if historyMainPoinX - scrollView.contentOffset.x > 20 {
                        swipeRight()
                    }
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == ScrollViewType.mainScroll.rawValue {
            historyMainPoinX = scrollView.contentOffset.x
        } else if scrollView.tag == ScrollViewType.shareScroll.rawValue {
            historySharePointX = scrollView.contentOffset.x
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if isReceivedShareData ==  false {
            return mainVideoView
        } else {
            if control?.currentPage == 0 {
                return shareVideoView
            } else {
                return mainVideoView
            }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale >=  scrollView.maximumZoomScale {
        } else if scrollView.zoomScale <= scrollView.minimumZoomScale {
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        isZomming = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        isZomming =  false
        
        YLLogicAPI.setMyLayout(mainVideoView, viewId: 0, eLayoutType: Int32((mainVideoType.rawValue)))
        
        if isReceivedShareData == true {
            YLLogicAPI.setMyLayout(shareVideoView, viewId: 0, eLayoutType: Int32((secondVideoType.rawValue)))
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
    }
}
