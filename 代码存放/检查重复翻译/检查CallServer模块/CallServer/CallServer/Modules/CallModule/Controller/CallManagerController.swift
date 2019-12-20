//
//  CallManagerController.swift
//  Odin-YMS
//
//  Created by Apple on 25/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
// MARK: - 👉Struct define Area

protocol CallManagerControllerDelegate: NSObjectProtocol {
    func clickHungUp()
    func clickMuteRing(_ button: UIButton)
    func clickSendMessageBtn()
    func clickAnswer()
    func switchCamear()
}

typealias finisheCleanBlock = () -> Void

class CallManagerController: CallManagerUILayout {
    // MARK: - 👉Property Data Area

    weak var delegate: CallManagerControllerDelegate?

    var finishCleanActionFunc: finisheCleanBlock?

    /** dtmf View */
    //    var dtmfView: DtmfView?
    //    var volumeView : MPVolumeView?
    // MARK: - 👉View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.addSubview(bgImageView)

        bgImageView.snp.remakeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
        isTalkEstablish = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        YLSDKLogger.log("CallManagerController - deinit")
    }
    /** 隐藏顶部NavigationBar */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        CallServerInterface.sharedManager().click(EVENT_SHOW_TALK, respon: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moreBtnLocation()
        setMainSmallVideoDisplay()
        startbottomContainerHide()
        distanceFeel()
    }

    /** 取消顶部NavigationBar */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeInviteNotice()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(bottomContainerHide), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        removeDistanceFell()
    }
}

extension CallManagerController {

    // MARK: - 👉PubliC Method
    func  changeYMSNumber(ymsNumber: String) {
        if coverView == nil {
            return
        }
        if let thisCoverView = coverView as? CallOutGoingVideoView {
            thisCoverView.updateConfNumber(subtitle: ymsNumber)
        } else if let thisCoverView = coverView as? CallOutGoingAudioView {
            thisCoverView.updateConfNumber(subtitle: ymsNumber)
        }
    }

    // 使用
    func callOutConf(isVideoCall: Bool ) {
        isCallin = false
        isVideo = isVideoCall
        let currNumber: String? = YLLogicAPI.get_CurrentNumber() 
        var currName = ""
        if currNumber != nil {
            currName = YLContactAPI.searchCloudName(byNumber: currNumber)
        }
        if isVideo == true {
            let outGoingView = CallOutGoingVideoView.init(frame: .zero)
            
            outGoingView.updateYMSCallinfo(title: currName + YLSDKLanguage.YLSDKSVideoConfidence, subtitle: "")
            outGoingView.hungUpActionFunc = {
                YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
            }
            coverView = outGoingView
        } else {
            let outGoingView = CallOutGoingAudioView.init(frame: .zero)
            outGoingView.updateInfo()
            outGoingView.updateYMSCallinfo(title: currName + YLSDKLanguage.YLSDKSVideoConfidence, subtitle: "")

            outGoingView.hungUpActionFunc = {
                YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
            }
            coverView = outGoingView
        }

        CallServerDeviceSource.getInstance.addCamearRoteListener()
        if let thisCoverView = coverView {
            bgImageView.addSubview(thisCoverView)
            thisCoverView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view.snp.edges)
            }
        }
    }

    // 使用
    func callOutPhone(isVideoCall: Bool ) {
        isCallin = false
        isVideo = isVideoCall
        if isVideo == true {
            let outGoingView = CallOutGoingVideoView.init(frame: .zero)
            outGoingView.updateInfo()
            outGoingView.hungUpActionFunc = {
                YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
            }
            coverView = outGoingView
        } else {
            let outGoingView = CallOutGoingAudioView.init(frame: .zero)
            outGoingView.updateInfo()
            outGoingView.hungUpActionFunc = {
                YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
            }
            coverView = outGoingView
        }

        CallServerDeviceSource.getInstance.addCamearRoteListener()
        if let thisCoverView = coverView {
            bgImageView.addSubview(thisCoverView)
            thisCoverView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view.snp.edges)
            }
        }
    }

    /** 通话来电 并判断是IP 来电 还是用户名来电 */
    func callIn() {
        isVideo = false
        let callInView = CallInVideoView.init(frame: .zero)
        callInView.updateInfo()
        callInView.hungUpOrAnswerFunc = { (_ isAnswerFlag) in
            if isAnswerFlag == true {
                YLLogicAPI.answer(Int32(CallServerDataSource.getInstance.getCallId()))
            } else {
                YLLogicAPI.hangUp(Int32(CallServerDataSource.getInstance.getCallId()))
            }
        }
        coverView = callInView
        if let thisCoverView = coverView {
            bgImageView.addSubview(thisCoverView)
            thisCoverView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view.snp.edges)
            }
        }
    }
    func smallVideoViewClickSet() {
        smallVideoView.clickHideOrShowBtnFunc = {[weak self] (result) in
            if self == nil {
                return
            }
            if RotationManager.getInstance.openRotation == false { return }
            if result == true {
                if let thisView = (self?.view) {
                    if let thisBottomContainerView = self?.bottomContainerView {
                        self?.smallVideoView.snp.remakeConstraints({ (make) in
                            make.height.equalTo(30)
                            make.width.equalTo(30)
                            make.right.equalTo(thisView)
                            make.bottom.equalTo(thisBottomContainerView.snp.top)
                        })
                    }
                }
                if self?.smallVideoType == .LvtLocal && self?.muteNoticeView != nil {
                    self?.muteNoticeView?.alpha = 0
                }
                CallServerInterface.sharedManager().click(EVENT_HIDE_SMALL_WINDOWN, respon: nil)
            } else {
                if self?.muteNoticeView != nil {
                    self?.muteNoticeView?.alpha = 1
                }

                if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                    if self?.smallVideoType == .LvtRemote {
                        self?.smallVideoViewSet(width: 160, hight: 90)
                    } else {
                        self?.smallVideoViewSet(width: 90, hight: 160)
                    }
                } else {
                    self?.smallVideoViewSet(width: 160, hight: 90)
                }
                CallServerInterface.sharedManager().click(EVENT_SHOW_SMALL_WINDOWN, respon: nil)
            }

            if self?.moreView != nil {
                var updateArray = self?.moreView?.elementArray
                if let lastObj = updateArray?.last {
                    if let thisResult = result {
                        lastObj.showSelectView = thisResult
                    }
                    updateArray?.removeLast()
                    updateArray?.append(lastObj)
                    if let thisUpdateArray = updateArray {
                        self?.moreView?.updateCellForModelArray(newArray: thisUpdateArray)
                    }
                }
            }
        }
    }

    func talkEstablish() {
        if hungUpBtn.isEnabled ==  false {
            return
        }
        isVideo = CallServerDataSource.getInstance.getTkData().m_isVideoTalking
        YLSDKLogger.log("handleVOIPNotification isVideo________" + String(isVideo))
        talkEstblishSetSpeak()
        if coverView != nil {
            if let thisCoverView = coverView as? CallOutGoingVideoView {
                thisCoverView.removeLayout()
            } else if let thisCoverView = coverView as? CallInVideoView {
                thisCoverView.removeLayout()
            }
            coverView?.snp.removeConstraints()
            coverView?.removeFromSuperview()
            coverView = nil
        }

        if contentView != nil {
            if let thisDoubleMainTap = doubleMainTap {
                mainScrollView?.removeGestureRecognizer(thisDoubleMainTap)
            }
            if let thisContendView = contentView {
                removeThisView(view: thisContendView)
            }

            removeThisView(view: mainVideoView)
            if let thisMainScrollView = mainScrollView {
                removeThisView(view: thisMainScrollView)
            }
            if let videoMuteViewBig = videoMuteViewBig {
                removeThisView(view: videoMuteViewBig)
            }

            removeThisView(view: switchCamearBtn)
            removeThisView(view: changeScreemBtn)
            removeThisView(view: lockScreemBtn)
            removeThisView(view: titleLabel)
            removeThisView(view: smallVideoView)
            removeThisView(view: bottomContainerView)
            removeThisView(view: bottmMoreBtn)
            removeThisView(view: bottmCamearBtn)
            removeThisView(view: bottmSpeakerBtn)
            removeThisView(view: bottmDtmfBtn)
            removeThisView(view: bottmInviteBtn)
            removeThisView(view: inviteLabel)
            removeThisView(view: bottmMemberListBtn)
            removeThisView(view: memberListLabel)
            removeThisView(view: muteBtn)
            removeThisView(view: muteLabel)
            removeThisView(view: handUpButton)
            removeThisView(view: handUpLabel)
        } else {
            bgImageView.image = nil
            removeThisView(view: titleLabel)
            removeThisView(view: bottomContainerView)
            removeThisView(view: bottmDtmfBtn)
            removeThisView(view: muteBtn)
            removeThisView(view: muteLabel)
            removeThisView(view: bottmSpeakerBtn)
            removeThisView(view: bottmSpeakerLabel)
            removeThisView(view: bottmDtmfLabel)
            removeThisView(view: bottmInviteBtn)
            removeThisView(view: inviteLabel)
            removeThisView(view: bottmMemberListBtn)
            removeThisView(view: memberListLabel)
            removeThisView(view: handUpButton)
            removeThisView(view: handUpLabel)
        }
        addstatusBarOrientationChangeListener()
        if timers == nil {
            talkTimeStartInterval =  SDKTimeManager.getCurrentTime()
            timers = Timer.scheduledTimerYL(withTimeInterval: 0.5, repeats: true, block: {[weak self] (_) in
                if self == nil {
                    return
                }
                self?.keepTalkTime()
            })
            if let thisTimer = (timers?.timer) {
                RunLoop.main.add(thisTimer, forMode: .commonModes)
            }
        }
        let conficenData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))

        if conficenData?.m_iConferencePattern != 0 {
            isConficen = true
            CallServerDataSource.getInstance.isConfience = true
            
            if let confModel = conficenData?.m_iConferencePattern {
                CallServerDataSource.getInstance.confModel = String.init(format: "%d", confModel)
            }
            
            if let userRole = conficenData?.m_dataMe.m_iRoleUser {
                CallServerDataSource.getInstance.userRole =  String.init(format: "%d", userRole)
            }
        } else {
            isConficen = false
            CallServerDataSource.getInstance.isConfience = false
        }

        if isVideo == true {
            videoCallAndConfUI()
        } else {
            if isConficen == true {
                audioConfUI()
                if conficenData?.m_listMember == nil || conficenData?.m_listMember.count == 0 {
                    showInviteNotice()
                }
            } else {
                audioCallUI()
            }
        }

        // 名字匹配 
        if conficenData?.m_iConferencePattern != 0 {
            isConficen = true
            //是会议
            if conficenData?.m_iConferencePattern  == 1 {
                if let thisOrganizer = (conficenData?.m_strOrganizer) {
                    titleLabel.text = thisOrganizer + YLSDKLanguage.YLSDKSVideoConfidence
                }
            } else {
                titleLabel.text = conficenData?.m_strSubject
            }
            subTitleLabel.text = conficenData?.m_strNumber
        } else {
            isConficen = false
            // 普通通话
            if let username = YLContactAPI.searchContactName(byNumber:  CallServerDataSource.getInstance.tkData.m_strRemoteUserName, isCloud: CallServerDataSource.getInstance.tkData.m_iAccountID == 1) {
                if (username.count) > 0 {
                    titleLabel.text = username
                } else {
                    titleLabel.text = CallServerDataSource.getInstance.getTkData().m_strRemoteDisplayName
                }
                subTitleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteUserName
            }
        }
        if let thisTitle = titleLabel.text {
            CallServerDataSource.getInstance.remoteName = thisTitle
        }

        if callinfoTimeView == nil {
            callinfoTimeView = CallInfoAndTimeView.init(frame: .zero, block: {[weak self] in
                if self == nil {
                    return
                }
                CallServerInterface.sharedManager().click(EVENT_SHOW_STATISTIC, respon: nil)
                let callStaticVC = CallStatisticsController()
                self?.presentVC = callStaticVC
                let nav = UINavigationController.init(rootViewController: callStaticVC)
                self?.present(nav, animated: true, completion: nil)
            })
        }
        callinfoTimeView?.removeFromSuperview()
        if let thisCallinfoTimeView = callinfoTimeView {
            view.addSubview(thisCallinfoTimeView)
            thisCallinfoTimeView.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(bottomContainerView.snp.top)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(34)
            })
        }

        // 如果更多已经点击
        if moreAngeleView != nil {
            moreAngeleView?.removeFromSuperview()
            if let thisMoreAngeleView = moreAngeleView {
                bottomContainerView.addSubview(thisMoreAngeleView)
                thisMoreAngeleView.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize.init(width: 15, height: 6))
                    make.top.equalTo((bottomContainerView))
                    make.centerX.equalTo(bottmMoreBtn)
                }
            }
        }

        moreBtnLocation()
        muteBtn.addTarget(self, action: #selector(muteBtnClick), for: .touchUpInside)
        handUpButton.addTarget(self, action: #selector(handUpBtnClick), for: .touchUpInside)
        checkTalkDataIfMute()
        setMuteHoldNotice()

        hungUpBtn.addTarget(self, action: #selector(hungUpBtnClick), for: .touchUpInside)
        
        addlisterForSpeaker()
        distanceFeel()
        audioRoteChange()
        isTalkEstablish = true
        if isReceivedShareData == true {
                YLLogicAPI.removeLayout(shareVideoView, viewId: 0, eLayoutType: Int32(secondVideoType.rawValue))
            shareReceived()
        }
    }
    
    func talkFinish(block:@escaping finisheCleanBlock) {
        CallServerInterface.sharedManager().click(EVENT_CALL_FINISH, respon: nil)
        removeListener()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(bottomContainerHide), object: nil)

        if coverView != nil {
            if let thisCoverView = coverView as? CallOutGoingVideoView {
                thisCoverView.removeLayout()
            } else if let thisCoverView = coverView as? CallInVideoView {
                thisCoverView.removeLayout()
            }
            
            coverView?.snp.removeConstraints()
            coverView?.removeFromSuperview()
            coverView = nil
        }

        if moreView != nil {
            moreView?.cellClickActionFunc = nil
            moreView?.removeFromSuperview()
            moreView?.snp.removeConstraints()
            moreView = nil
        }
        if self.presentedViewController != nil {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        if self.presentingViewController != nil {
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        if contentView != nil {
            contentView?.removeFromSuperview()
            contentView = nil
        }
        if mainScrollView != nil {
            if let thisDoubleMainTap = doubleMainTap {
                mainScrollView?.removeGestureRecognizer(thisDoubleMainTap)
            }
            mainScrollView?.removeFromSuperview()
            mainScrollView = nil

        }
        if shareScrollView != nil {
            shareScrollView?.removeFromSuperview()
            shareScrollView = nil
        }
        finishCleanActionFunc = block
        timers?.invalidate()
        timers = nil
        
        if moreAngeleView != nil {
            moreAngeleView?.removeFromSuperview()
            moreAngeleView = nil
        }
        // 必须要先removeLayout
        if isVideo == true {
            YLLogicAPI.removeLayout(mainVideoView, viewId: 0, eLayoutType: Int32(mainVideoType.rawValue))
            YLLogicAPI.removeLayout(smallVideoView.videoView, viewId: 0, eLayoutType: Int32(smallVideoType.rawValue))
        }
        if let thisFinishBlock = finishCleanActionFunc {
            // 这段方法一定要放在removelayou 以后
            thisFinishBlock()
        }
        isTalkEstablish = false
        isConficen = false
        RotationManager.getInstance.openRotation = true
        YLSDKDispatchManager.callQueue.cancelAllOperations();
    }

    func shareReceived() {
        
        if  isVideo == false {
            return
        }
        isReceivedShareData = true

        control = UIPageControl()
        control?.numberOfPages = 2
        control?.currentPage = 0
        control?.currentPageIndicatorTintColor = UIColor.white
        control?.pageIndicatorTintColor = UIColor.whiteColorAlphaYL(alpha: 0.5)

        shareNoticebtn = UIButton()
        shareNoticebtn?.backgroundColor = UIColor.clear
        shareNoticebtn?.setTitle(YLSDKLanguage.YLSDKViewVideo, for: .normal)
        shareNoticebtn?.setTitleColor(UIColor.white, for: .normal)
        shareNoticebtn?.addTarget(self, action: #selector(swipeLeft), for: .touchUpInside)
        shareNoticebtn?.titleLabel?.font = UIFont.fontWithHelvetica(14)
        shareNoticebtn?.contentHorizontalAlignment = .left

        if RotationManager.getInstance.openRotation == false {
            shareNoticebtn?.isHidden = true
        }
        if let thisConTrol = control {
            view.addSubview(thisConTrol)
            thisConTrol.snp.remakeConstraints { (make) in
                make.bottom.equalTo(bottomContainerView.snp.top)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(30)
            }
            
            callinfoTimeView?.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(thisConTrol.snp.top)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(26)
            })
        }
        
        if let thisShareNoticebtn = shareNoticebtn {
            view.addSubview(thisShareNoticebtn)
            thisShareNoticebtn.snp.remakeConstraints { (make) in
                make.bottom.equalTo(bottomContainerView.snp.top)
                make.left.equalTo(view).offset(4)
                make.width.lessThanOrEqualTo(150)
                make.height.equalTo(30)
            }
        }

        if let control = control {
            callinfoTimeView?.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(control.snp.top)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(26)
            })
        }
        

        shareScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: Int(kScreenHight)))
        shareScrollView?.tag = ScrollViewType.shareScroll.rawValue
        shareScrollView?.minimumZoomScale = 1
        shareScrollView?.maximumZoomScale = 3
        shareScrollView?.isScrollEnabled =  true
        shareScrollView?.bounces = true
        shareScrollView?.decelerationRate=1.0;//减速倍率（默认倍率）
        if let thisShareScrollView = shareScrollView {
            contentView?.addSubview(thisShareScrollView)
        }
        shareScrollView?.delegate =  self
        shareScrollView?.snp.remakeConstraints { (make) in
            make.edges.equalTo(view)
        }

        if let thisShareView = shareScrollView {
            mainScrollView?.snp.remakeConstraints { (make) in
                make.top.bottom.equalTo(thisShareView)
                make.width.equalTo(thisShareView)
                make.left.equalTo(thisShareView.snp.right)
            }
        }
        shareScrollView?.delegate =  self

        shareScrollView?.addSubview(shareVideoView)
        shareVideoView.frame = view.frame

        swipeLeftRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeLeft))
        swipeLeftRecognizer?.direction = .left
        if let thisSwipeLeftRecognizer = swipeLeftRecognizer {
            shareScrollView?.addGestureRecognizer(thisSwipeLeftRecognizer)
        }

        swipeRightRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeRight))
        if let thisSwipeRightRecognizer = swipeRightRecognizer {
            mainScrollView?.addGestureRecognizer(thisSwipeRightRecognizer)
        }
        //mainScrollView.alpha = 0

        doubleShareTap = UITapGestureRecognizer.init(target: self, action:  #selector(doubleShareScrollTapView(_:)))
        doubleShareTap?.numberOfTapsRequired =  2
        if let thisDoubleShareTap = doubleShareTap {
            shareScrollView?.addGestureRecognizer(thisDoubleShareTap)
            thisDoubleShareTap.isEnabled =  true
        }
        secondVideoType = .LvtShareRecv
        YLLogicAPI.setMyLayout(shareVideoView, viewId: 0, eLayoutType: Int32(secondVideoType.rawValue))



        _ = YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKReceivedStream, position: .top, block: nil)
        CallServerInterface.sharedManager().click(EVENT_OPEN_SHARE_SCREEN, respon: nil)
    }

    func shareReset() {
        if isReceivedShareData == true {
            if shareScrollView != nil {
                YLLogicAPI.setMyLayout(shareVideoView, viewId: 0, eLayoutType: Int32((secondVideoType.rawValue)))
            }
        }
    }

    func shareStoped() {
        if  isVideo == false {
            return
        }
        isReceivedShareData = false
        mainScrollView?.alpha = 1

        callinfoTimeView?.snp.remakeConstraints({ (make) in
            make.bottom.equalTo(bottomContainerView.snp.top)
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(34)
        })
        mainScrollView?.snp.remakeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }

        if (control != nil) {
            control?.snp.removeConstraints()
            control?.removeFromSuperview()
            control = nil
        }

        if (shareNoticebtn != nil) {
            shareNoticebtn?.snp.removeConstraints()
            shareNoticebtn?.removeFromSuperview()
            shareNoticebtn = nil
        }

        YLLogicAPI.removeLayout(shareVideoView, viewId: 0, eLayoutType: Int32(secondVideoType.rawValue))

        secondVideoType = .LvtUnknow

        shareVideoView.snp.removeConstraints()
        shareVideoView.removeFromSuperview()

        if shareScrollView != nil {

            shareScrollView?.snp.removeConstraints()
            shareScrollView?.removeFromSuperview()

            shareScrollView?.removeGestureRecognizer(swipeLeftRecognizer!)
            shareScrollView?.removeGestureRecognizer(doubleShareTap!)
//            shareScrollView.removeGestureRecognizer(singleShareTap)


            shareScrollView = nil
        }

        if let thisSwipeRightRecognizer = swipeRightRecognizer {
            mainScrollView?.removeGestureRecognizer(thisSwipeRightRecognizer)
        }
        CallServerInterface.sharedManager().click(EVENT_CLOSE_SHARE_SCREEN, respon: nil)

    }

    func muteorUnmuteNoteChange(ismute: Bool) {
        if (muteBtn.isSelected != ismute) {
            muteBtn.isSelected = ismute
            setMuteState()
        }
        setMuteHoldNotice()
    }

    func holdOrUnHold() {
        if CallServerDataSource.getInstance.isHold == true {
            holdView = CallHoldView()
            if let thisHoldView = holdView {
                view.addSubview(thisHoldView)
                thisHoldView.snp.remakeConstraints({ (make) in
                    make.width.equalTo(120)
                    make.height.equalTo(120)
                    make.center.equalTo(view)
                })
            }
        } else {
            if holdView != nil {
                holdView?.snp.removeConstraints()
                holdView?.removeFromSuperview()
                holdView = nil
            }
        }
    }

    func updateDisplayName() {
        if let thisCoverView = coverView as? CallOutGoingVideoView {
            thisCoverView.updateCallOutDisplay()
        } else if let  thisCoverView = coverView as? CallOutGoingAudioView {
            thisCoverView.updateCallOutDisplay()
        }
    }

    func muteButtonViewUpdate() {
        if CallServerDataSource.getInstance.getCallId() == 0 {
            return
        }
        let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))

        if callData != nil && callData?.m_dataMe != nil && callData?.m_iConferencePattern == 3 && callData?.m_dataMe.m_iRoleUser == 2 && callData?.m_dataMe.m_bMuteByServer == true  {
            //主席模式 角色为参会人
            handUpButton.isHidden = false
            handUpLabel.isHidden = false
            muteBtn.isHidden = true
            muteLabel.isHidden = true
            if callData?.m_dataMe.m_bRequestSpeak == true {
                handUpButton.isSelected = false
                handUpLabel.text = YLSDKLanguage.YLSDKCancel
            } else {
                handUpButton.isSelected = true
                handUpLabel.text = YLSDKLanguage.YLSDKHandUp
            }
        } else {
            // 普通 通话，讨论会议， 主席会议角色为主持人 
            handUpButton.isHidden = true
            handUpLabel.isHidden = true
            muteBtn.isHidden = false
            muteLabel.isHidden = false
            if callData?.m_dataMe != nil {
                if callData?.m_dataMe.m_bMuteByServer == true {
                    muteBtn.isSelected = true
                    if let audioMute = callData?.m_dataMe.m_bAudioMute {
                        isMute = audioMute
                    }
                } else {
                    if let audioMute = callData?.m_dataMe.m_bAudioMute {
                        if audioMute == true {
                            muteBtn.isSelected = true
                        } else {
                            muteBtn.isSelected = false
                        }
                    } else {
                        muteBtn.isSelected = isMute
                    }
                }
            } else {
                muteBtn.isSelected = isMute
            }
        }
    }

    func inOrRejectUpdate() {
        YLSDKDispatchManager.callQueue.addOperation {[weak self] in
            if self == nil { return }
            if self?.isConficen == true && self?.isVideo ==  true {
                let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
                if callData?.m_listMember == nil || callData?.m_listMember.count == 0 {
                    // 没人在会时需要变更视频的位置
                    YLSDKLogger.log("只有一人的显示")
                    self?.mainVideoType = .LvtLocal
                    self?.smallVideoType = .LvtRemote
                    self?.onlySelfInMeetingShow = true
                } else if self?.onlySelfInMeetingShow == true {
                    self?.onlySelfInMeetingShow = false
                    YLSDKLogger.log("多人且小窗口隐藏的显示")                    
                    self?.mainVideoType = .LvtRemote
                    self?.smallVideoType = .LvtLocal
                    DispatchQueue.main.syncYL {
                        self?.removeInviteNotice()
                        if self?.bottmCamearBtn.isSelected == true  {
                            self?.muteVideoViewSet()
                        }
                        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                            if self?.smallVideoView.videoHideShowBtn.isSelected == false {
                                self?.smallVideoViewSet(width: 90, hight: 160)
                            }
                            self?.smallVideoRealVideSet(width: 90, hight: 160)
                        } else {
                            if self?.smallVideoView.videoHideShowBtn.isSelected == false {
                                self?.smallVideoViewSet(width: 160, hight: 90)
                            }
                            self?.smallVideoRealVideSet(width: 160, hight: 90)
                        }
                    }
                }
            }
            if self?.isVideo == true {
                self?.setMainSmallVideoDisplay()
            }
        }

    }
    
    
    // MARK: - 👉Private Method
    /** 音频通话彩色背景图 */
   
    func removeInviteNotice() {
        YLSDKAlertNoButtonViewManager.getInstance.removeView()
    }
    

    func videoCallAndConfUI() {
        CallServerDeviceSource.getInstance.addCamearRoteListener()

        bgImageView.image = nil
        contentView = UIView()
        contentView?.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingMainView
        if let thisContentView = contentView {
            view.addSubview(thisContentView)
            thisContentView.snp.makeConstraints({ (make) in
                make.edges.equalTo(view)
            })
        }

        mainScrollView =  UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: Int(kScreenHight)))
        mainScrollView?.tag = ScrollViewType.mainScroll.rawValue
        mainScrollView?.minimumZoomScale = 1
        mainScrollView?.maximumZoomScale = 3
        mainScrollView?.isScrollEnabled =  true
        mainScrollView?.bounces = true
        mainScrollView?.decelerationRate = 1.0
        if let thisMainScrollView = mainScrollView {
            contentView?.addSubview(thisMainScrollView)
            thisMainScrollView.snp.remakeConstraints { (make) in
                make.edges.equalTo(view.snp.edges)
            }
        }
        

        mainVideoView.isUserInteractionEnabled = true
        mainVideoView.alpha = 1
        mainVideoView.frame = view.frame
        mainScrollView?.addSubview(mainVideoView)
        mainScrollView?.delegate = self

        view.addSubview(switchCamearBtn)
        switchCamearBtn.addTarget(self, action: #selector(switchCamearBtnClick), for: .touchUpInside)
        switchCamearBtn.snp.remakeConstraints({ (make) in
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(30)
            make.width.equalTo(30)
            if isIphoneX && (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                make.top.equalTo(view).offset(48)
            } else {
                make.top.equalTo(view).offset(24)
            }
            
        })

        view.addSubview(changeScreemBtn)
        changeScreemBtn.addTarget(self, action:  #selector(changeScreemBtnClick), for: .touchUpInside)
        changeScreemBtn.snp.remakeConstraints({ (make) in
            make.right.equalTo(switchCamearBtn.snp.left).offset(-8)
            make.height.equalTo(30)
            make.width.equalTo(30)
            if isIphoneX {
                make.top.equalTo(view).offset(48)
            } else {
                make.top.equalTo(view).offset(24)
            }
        })

        view.addSubview(lockScreemBtn)
        lockScreemBtn.addTarget(self, action: #selector(lockScreemBtnClick), for: .touchUpInside)
        lockScreemBtn.snp.remakeConstraints({ (make) in
            make.height.equalTo(44)
            make.width.equalTo(44)
            make.left.equalTo(view).offset(12)
            make.centerY.equalTo(view)
        })
        lockScreemBtn.isHidden = true

        view.addSubview(titleLabel)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.fontWithHelvetica(18)
        titleLabel.snp.remakeConstraints({ (make) in
            if isIphoneX && (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                make.top.equalTo(view).offset(48)
            } else {
                make.top.equalTo(view).offset(24)
            }
            make.left.equalTo(view).offset(16)
            make.right.lessThanOrEqualTo(view).offset(-120)
        })

        if CallServerDataSource.getInstance.getTkData().m_isCallEncrypt == true {
            view.addSubview(titleLableEncryptImage)
            titleLableEncryptImage.snp.remakeConstraints({ (make) in
                make.width.equalTo(20)
                make.height.equalTo(20)
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right).offset(4)
            })
        }

        view.addSubview(subTitleLabel)
        subTitleLabel.textAlignment = .left
        subTitleLabel.font = UIFont.fontWithHelvetica(12)
        subTitleLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-100)
            make.height.equalTo(17)
        })
        contentView?.addSubview(smallVideoView)

        view.addSubview(bottomContainerView)
        if UIApplication.shared.applicationState == .active {
            // 底部摄像头状态
            let cameraState = YLLogicAPI.get_CameraState()
            if cameraState == 2 {
                bottmCamearBtn.isSelected = true
            } else {
                bottmCamearBtn.isSelected = false
            }
        } else {
            bottmCamearBtn.isSelected =  CallServerDataSource.getInstance.outgoingCloseCamera
        }

        // 是否可以发言状态判断
        muteButtonViewUpdate()
        bottomContainerView.addSubview(muteBtn)
        bottomContainerView.addSubview(muteLabel)
        bottomContainerView.addSubview(handUpButton)
        bottomContainerView.addSubview(handUpLabel)
        bottomContainerView.addSubview(bottmCamearBtn)
        bottomContainerView.addSubview(bottmCamearLabel)
        bottomContainerView.addSubview(bottmMoreBtn)
        bottomContainerView.addSubview(bottmMoreLabel)
        bottomContainerView.addSubview(hungUpBtn)
        bottomContainerView.addSubview(hungUpLabel)
        bottomContainerView.addSubview(bottmInviteBtn)
        bottomContainerView.addSubview(inviteLabel)
        bottomContainerView.addSubview(bottmMemberListBtn)
        bottomContainerView.addSubview(memberListLabel)
        bottmInviteBtn.isHidden = !isConficen
        inviteLabel.isHidden = !isConficen
        bottmMemberListBtn.isHidden = !isConficen
        memberListLabel.isHidden = !isConficen
        
        bottomContainerView.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.3)
        bottmCamearBtn.addTarget(self, action: #selector(bottmCamearBtnClick), for: .touchUpInside)
        bottmInviteBtn.addTarget(self, action: #selector(bottmInviteBtnClick), for: .touchUpInside)
        bottmMemberListBtn.addTarget(self, action: #selector(bottmMemberListBtnClick), for: .touchUpInside)
        // 判断是否是发言模式

        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            videoCallForIphone()
        } else {
            videoCallForIpad()
        }

        doubleMainTap = UITapGestureRecognizer.init(target: self, action:  #selector(doubleMainScrollTapView(_:)))
        doubleMainTap?.numberOfTapsRequired = 2
        if let thisDoubleMainTap = doubleMainTap {
            mainScrollView?.addGestureRecognizer(thisDoubleMainTap)
            thisDoubleMainTap.isEnabled = true
        }

        bottomeMenuHide = false
        singleMainTap = UITapGestureRecognizer.init(target: self, action:  #selector(singleMainScrollTapView(_:)))

        contentView?.addGestureRecognizer(singleMainTap!)
        singleMainTap?.numberOfTapsRequired =  1
        // 小视频点击
        smallVideoView.clickSmallVideoBtnFunc = {[weak self](btn) in
            if self == nil {
                return
            }
            self?.smallVideoViewBtnClick()
            self?.muteVideoViewSet()
            CallServerInterface.sharedManager().click(EVENT_CLICK_SMALL_WINDOW, respon: nil)
        }
        startbottomContainerHide()
        if  isConficen ==  false {
            if mainVideoType == .LvtUnknow && smallVideoType == .LvtUnknow {
                mainVideoType = .LvtRemote
                smallVideoType = .LvtLocal
            }
        } else if isConficen == true {
            let callData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
            if let thisListMemberCount = (callData?.m_listMember?.count) {
                if callData?.m_listMember != nil && thisListMemberCount > 0 {
                    // 会议且加入人数大于1
                    mainVideoType = .LvtRemote
                    smallVideoType = .LvtLocal
                } else {
                    // 会议且只有一人的情况, 隐藏小窗口
                    mainVideoType = .LvtLocal
                    smallVideoType = .LvtRemote
                    smallVideoView.isHidden = true
                }
            }
        }

        setMainSmallVideoDisplay()
        smallVideoViewClickSet()
        muteVideoViewSet()
        screenChange()
    }

    func audioCallUI() {
        bgImageViewSetColorImage()
        CallServerDeviceSource.getInstance.removeCamearRoteListener()
        bgImageView.snp.remakeConstraints({ (make) in
            make.edges.equalTo(view)
        })

        bgImageView.addSubview(titleLabel)
        titleLabel.font = UIFont.fontWithHelvetica(30)
        titleLabel.textAlignment = .center

        bgImageView.addSubview(subTitleLabel)
        subTitleLabel.font = UIFont.fontWithHelvetica(18)
        subTitleLabel.textAlignment = .center

        bgImageView.addSubview(bottomContainerView)
        bottomContainerView.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.3)

        bottomContainerView.addSubview(muteBtn)
        bottomContainerView.addSubview(muteLabel)
        
        bottomContainerView.addSubview(handUpButton)
        bottomContainerView.addSubview(handUpLabel)

        bottomContainerView.addSubview(bottmDtmfBtn)
        bottomContainerView.addSubview(bottmDtmfLabel)

        bottomContainerView.addSubview(bottmSpeakerBtn)
        bottomContainerView.addSubview(bottmSpeakerLabel)

        bottomContainerView.addSubview(hungUpBtn)
        bottomContainerView.addSubview(hungUpLabel)
        
        bottmDtmfBtn.addTarget(self, action: #selector(bottmDtmfBtnClick), for: .touchUpInside)
        bottmSpeakerBtn.addTarget(self, action: #selector(bottmSpeakerBtnClick), for: .touchUpInside)
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            audioCallConfForIphoneLayout()
        } else {
            audioCallConfForIpadLayout()
        }
    }

    func audioConfUI() {
        bgImageViewSetColorImage()
        CallServerDeviceSource.getInstance.removeCamearRoteListener()
        bgImageView.snp.remakeConstraints({ (make) in
            make.edges.equalTo(view)
        })

        bgImageView.addSubview(titleLabel)
        titleLabel.font = UIFont.fontWithHelvetica(30)
        titleLabel.textAlignment = .center

        bgImageView.addSubview(subTitleLabel)
        subTitleLabel.font = UIFont.fontWithHelvetica(18)
        subTitleLabel.textAlignment = .center

        bgImageView.addSubview(bottomContainerView)
        bottomContainerView.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.3)

        bottomContainerView.addSubview(muteBtn)
        bottomContainerView.addSubview(muteLabel)
        
        bottomContainerView.addSubview(handUpButton)
        bottomContainerView.addSubview(handUpLabel)

        bottomContainerView.addSubview(bottmSpeakerBtn)
        bottomContainerView.addSubview(bottmSpeakerLabel)

        bottomContainerView.addSubview(bottmDtmfBtn)
        bottomContainerView.addSubview(bottmDtmfLabel)

        bottomContainerView.addSubview(hungUpBtn)
        bottomContainerView.addSubview(hungUpLabel)
        
        bottomContainerView.addSubview(bottmInviteBtn)
        bottomContainerView.addSubview(inviteLabel)
        
        bottomContainerView.addSubview(bottmMemberListBtn)
        bottomContainerView.addSubview(memberListLabel)
        
        bottmInviteBtn.isHidden = !isConficen
        inviteLabel.isHidden = !isConficen
        bottmMemberListBtn.isHidden = !isConficen
        memberListLabel.isHidden = !isConficen

        bottmDtmfBtn.addTarget(self, action: #selector(bottmDtmfBtnClick), for: .touchUpInside)
        bottmSpeakerBtn.addTarget(self, action: #selector(bottmSpeakerBtnClick), for: .touchUpInside)
        
        bottmInviteBtn.addTarget(self, action: #selector(bottmInviteBtnClick), for: .touchUpInside)
        
        bottmMemberListBtn.addTarget(self, action: #selector(bottmMemberListBtnClick), for: .touchUpInside)

        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            audioCallConfForIphoneLayout()
        } else {
            audioCallConfForIpadLayout()
        }
    }

    // 是否被mute
    func checkTalkDataIfMute() {
        if  CallServerDataSource.getInstance.tkData != nil {
            if CallServerDataSource.getInstance.tkData.m_bAudioConfMute {
                muteBtn.isSelected = true
                setMuteState()
            }
        }
    }


    func keepTalkTime() {
        if let starTime = talkTimeStartInterval {
            let timeLast: TimeInterval = SDKTimeManager.getCurrentTime() - starTime
            let time = SDKTimeManager.getTalkTimerLengthFromZero(timeInterval: timeLast)
            YLSDKLOG.log(time)
            DispatchQueue.main.syncYL {[weak self] in
                if self == nil {
                    return
                }
                self?.callinfoTimeView?.timeLabel.text = time
            }
            keepWatchCallData()
        }
    }
    
    func keepWatchCallData() {
        DispatchQueue.global().async {[weak self] in
            if self == nil {
                return
            }

            self?.talkstatistics = YLLogicAPI.getCallStatistics(Int32(CallServerDataSource.getInstance.getCallId()))
            if self?.talkstatistics != nil {
                if CallServerDataSource.getInstance.getCallType() == .video {
                    if (self?.talkstatistics?.m_strVideoLostPercentSend == nil) {
                        return
                    }

                    if let videoLostPercentSend = self?.talkstatistics?.m_strVideoLostPercentSend as NSString? {
                        if let  videoLostPercentRecv = self?.talkstatistics?.m_strVideoLostPercentRecv as NSString? {
                            if let resultSend = Int(videoLostPercentSend.substring(to: videoLostPercentSend.length - 1)) {
                                if let resultRecv = Int(videoLostPercentRecv.substring(to: videoLostPercentRecv.length - 1)) {
                                    if resultSend > resultRecv {
                                        CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultSend)
                                    } else {
                                        CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultRecv)
                                    }
                                }
                            }
                        }
                    }
                } else if CallServerDataSource.getInstance.getCallType() == .voice {
                    if let audioLostPercentSend = self?.talkstatistics?.m_strAudioLostPercentSend as NSString? {
                        if let audioLostPercentRecv = self?.talkstatistics?.m_strAudioLostPercentRecv as NSString? {
                            if let resultSend = Int(audioLostPercentSend.substring(to: audioLostPercentSend.length - 1)) {
                                if let resultRecv = Int(audioLostPercentRecv.substring(to: audioLostPercentRecv.length - 1)) {
                                    if resultSend > resultRecv {
                                        CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultSend)
                                    } else {
                                        CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultRecv)
                                    }
                                }
                            }
                        }
                    }
                }

                let singleCount = CallServerDataSource.getInstance.getSingleCount()

                if CallServerDataSource.getInstance.lostPercentDataInt > 20 && self?.showNoticeCountTimer == 0 {
                    self?.showNoticeCountTimer = 55
                    DispatchQueue.main.async {[weak self] in
                        if self == nil {
                            return
                        }
                        _ = YLSDKAlertNoButtonView.show(YLSDKLanguage.YLSDKTheNetworkSignalIsPoor, position: .top, block: nil)
                    }
                }
                if let showNoticeCount = (self?.showNoticeCountTimer) {
                    if showNoticeCount > 0 {
                        self?.showNoticeCountTimer = showNoticeCount - 1
                    }
                }
                DispatchQueue.main.syncYL {[weak self] in
                    if self == nil {
                        return
                    }
                    if singleCount == 1 {
                        self?.callinfoTimeView?.singelImage.image = #imageLiteral(resourceName: "signal1")
                    } else if singleCount == 2 {
                        self?.callinfoTimeView?.singelImage.image = #imageLiteral(resourceName: "signal2")
                    } else if singleCount == 3 {
                        self?.callinfoTimeView?.singelImage.image = #imageLiteral(resourceName: "signal3")
                    } else if singleCount == 4 {
                        self?.callinfoTimeView?.singelImage.image = #imageLiteral(resourceName: "signal4")
                    } else if singleCount == 0 {
                        self?.callinfoTimeView?.singelImage.image = #imageLiteral(resourceName: "signal0")
                    }
                }
            }
        }
    }
}
