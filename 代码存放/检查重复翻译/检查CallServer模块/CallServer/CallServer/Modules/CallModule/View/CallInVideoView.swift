//
//  CallInVideoView.swift
//  Odin-YMS
//
//  Created by Apple on 12/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import AVFoundation
import YLBaseFramework
typealias hungUpOrAnswerBlock = (_ isAnswerFlag: Bool) -> Void

class CallInVideoView: UIView {
    
    /** block*/
    var hungUpOrAnswerFunc: hungUpOrAnswerBlock?
    
    var startVolum:Float = 0
    
    /** 视频聊天背景视图 */
    lazy var bgImageView: VideoRenderIosView = {
        //这里执行操作代码
        let imageView = VideoRenderIosView.init()
        imageView.frame = CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: Int(kScreenHight))
        imageView.backgroundColor = UIColor.talkFinishGroundColor()
        imageView.isUserInteractionEnabled =  true
        return imageView
    }()
    
    /** 主标题 Label*/
    lazy var inComeLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.fontWithHelvetica(14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = YLSDKLanguage.YLSDKincoming
        //        label.shadowColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        //        label.shadowOffset = CGSize.init(width: 1, height: 2)
        return label
    }()
    
    /** 主标题 Label*/
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 1
        label.textAlignment = .center
        //        label.shadowColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        //        label.shadowOffset = CGSize.init(width: 1, height: 2)
        return label
    }()
    
    /** 此标题 Label*/
    lazy var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(14)
        //        label.shadowColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        //        label.shadowOffset = CGSize.init(width: 1, height: 2)
        return label
    }()
    
    /** 挂断 button*/
    lazy var hungupBtn: UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    /** 挂断 UILabel*/
    lazy var hungupLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(11)
        return label
    }()
    
    /** 挂断 button*/
    lazy var answerBtn: UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    /** 挂断 UILabel*/
    lazy var answerLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(11)
        return label
    }()
    
    /** 挂断 button*/
    lazy var switchCamearBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "swithc_camear_nor"), for: .normal)
        return button
    }()
    
    /** 关闭摄像头Image*/
    lazy var camearMuteBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.camearMuteBGColor()
        view.alpha = 0
        return view
    }()
    
    /** 关闭摄像头Image*/
    lazy var camearMuteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        return imageView
    }()
    
    /** 挂断 UILabel*/
    lazy var camearMuteLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.camearMuteLabelColor()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(15)
        label.text = YLSDKLanguage.YLSDKTheCameraHasClosed 
        label.alpha = 0
        return label
    }()
    
    
    
    /** 转为音频 button*/
    lazy var changeAudioBtn: UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    /** 转为音频 UILabel*/
    lazy var changeAudioLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(11)
        label.text = YLSDKLanguage.YLSDKChangeAudio
        return label
    }()
    
    func removeLayout() {
        YLLogicAPI.removeLayout(self.bgImageView, viewId: 0, eLayoutType: Int32(LogicVideoType.LvtLocal.rawValue))
    }
    
    deinit {
        removeListener()
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
        //        EventStatisticsManager.getInstance.endEvent(event: .showInCome)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        startVolum = AVAudioSession.sharedInstance().outputVolume
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
        self.addSubview(bgImageView)
        
        switchCamearBtn.isEnabled = false
        self.addSubview(camearMuteBGView)
        self.addSubview(camearMuteImage)
        self.addSubview(camearMuteLabel)
        
        camearMuteBGView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        camearMuteImage.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
        }
        camearMuteLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(camearMuteImage.snp.bottom).offset(8)
        }
        camearMuteBGView.alpha = 0
        camearMuteImage.alpha = 0
        camearMuteLabel.alpha = 0
        
        self.addSubview(inComeLabel)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(switchCamearBtn)
        
        self.addSubview(hungupBtn)
        self.addSubview(hungupLabel)
        self.addSubview(answerBtn)
        self.addSubview(answerLabel)
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        inComeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(60)
            make.left.right.equalTo(self)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(self).offset(100)
            make.left.right.equalTo(self)
            make.height.equalTo(42)
            
        })
        subTitleLabel.snp.remakeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        })
        
        switchCamearBtn.snp.makeConstraints { (make) in
            if isIphoneX && (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                make.top.equalTo(self).offset(48)
            } else {
                make.top.equalTo(self).offset(24)
            }
            make.right.equalTo(self).offset(-12)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        hungupBtn.setImage(UIImage.init(named: "hungup_nor"), for: .normal)
        hungupBtn.setImage(UIImage.init(named: "hungup_sel"), for: .highlighted)
        hungupBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.centerX.equalTo(self).offset(-70)
            make.bottom.equalTo(self).offset(-80)
        }
        
        hungupLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(hungupBtn)
            make.top.equalTo(hungupBtn.snp.bottom).offset(8)
            make.width.equalTo(120)
        }

        hungupLabel.text = YLSDKLanguage.YLSDKHungUp

        answerBtn.setImage(#imageLiteral(resourceName: "answer_nor"), for: .normal)
        answerBtn.setImage(#imageLiteral(resourceName: "answer_sel"), for: .highlighted)

        answerBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.centerX.equalTo(self).offset(70)
            make.bottom.equalTo(self).offset(-80)
        }
        
        answerLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(answerBtn)
            make.top.equalTo(answerBtn.snp.bottom).offset(8)
            make.width.equalTo(120)
        }

        answerLabel.text = YLSDKLanguage.YLSDKAnswer
        switchCamearBtn.addTarget(self, action: #selector(switchCamearBtnClick), for: .touchUpInside)
        hungupBtn.addTarget(self, action: #selector(hungupBtnClick), for: .touchUpInside)
        answerBtn.addTarget(self, action: #selector(answerBtnClick), for: .touchUpInside)

        self.addSubview(changeAudioBtn)
        self.addSubview(changeAudioLabel)
        changeAudioBtn.addTarget(self, action: #selector(changeAudioBtnClick), for: .touchUpInside)
        changeAudioLabel.text = YLSDKLanguage.YLSDKSwitchToAudio
        changeAudioBtn.setImage(#imageLiteral(resourceName: "call_change_audio_nor"), for: .normal)
        changeAudioBtn.setImage(#imageLiteral(resourceName: "call_change_audio_pre"), for: .highlighted)

        changeAudioBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.centerX.equalTo(self).offset(70)
            make.bottom.equalTo(self).offset(-168)
        }

        changeAudioLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(changeAudioBtn)
            make.top.equalTo(changeAudioBtn.snp.bottom).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(16)
        }
        
        YLSDKDispatchManager.videoEngineQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            let state = YLLogicAPI.get_CameraState()
            DispatchQueue.main.sync {
                if self == nil {
                    return
                }
                if state == 0 {
                    self?.camearMuteBGView.alpha = 0
                    self?.camearMuteBGView.alpha = 0
                    self?.camearMuteBGView.alpha = 0
                    self?.switchCamearBtn.isEnabled = true
                } else {
                    self?.camearMuteBGView.alpha = 1
                    self?.camearMuteBGView.alpha = 1
                    self?.camearMuteBGView.alpha = 1
                    self?.switchCamearBtn.isEnabled = false
                }
            }
            YLLogicAPI.setMyLayout(self?.bgImageView, viewId: 0, eLayoutType: Int32(LogicVideoType.LvtLocal.rawValue))
        }
        addstatusBarOrientationChangeListener()
    }
    
    func addstatusBarOrientationChangeListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    @objc func statusBarOrientationDidChange() {
        callResetLocatVideo()
    }
    func callResetLocatVideo() {
        Timer.scheduledTimerYL(withTimeInterval: 0.35, repeats: false) {[weak self] (_) in
            if self == nil {
                return
            }
            YLLogicAPI.setMyLayout(self?.bgImageView, viewId: 0, eLayoutType: Int32(LogicVideoType.LvtLocal.rawValue))
        }
    }
    
    @objc func switchCamearBtnClick() {
        switchCamearBtn.isEnabled = false
        
        CallServerDeviceSource.getInstance.switchCamear(block: {
            DispatchQueue.main.syncYL { [weak self] in
                if self == nil {
                    return
                }
                self?.switchCamearBtn.isEnabled = true
            }
        })
    }
    
    @objc func hungupBtnClick() {
        if let thisBlock = hungUpOrAnswerFunc  {
            thisBlock(false)
        }
    }
    
    @objc func answerBtnClick() {
        if let thisBlock = hungUpOrAnswerFunc {
            thisBlock(true)
        }
    }
    
    @objc func changeAudioBtnClick() {
        YLSDKAnswerChannelCall.InputDataInfo.init(nCallId: CallServerDataSource.getInstance.getCallId(), bVideo: false).getData(name: kSdkIFAnswerChannelCall, BodyClass: SdkInterfaceEmptyBody.self) { (body, result) in
            if result?.type == .success {
                YLSDKLOG.log("change audio answer succeed")
            } else {
                YLSDKAlertNoButtonView.show("Audio answer failed please try video Answer")
            }
        }
    }
    
    func updateInfo() {
        titleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteDisplayName
        subTitleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteUserName
        let conficenData = YLConfAPI.getConfCallProperty(Int32(CallServerDataSource.getInstance.getCallId()))
        if conficenData?.m_iConferencePattern != 0 {
            if conficenData?.m_iConferencePattern  == 1 {
                if let thisOrganizer = (conficenData?.m_strOrganizer) {
                    titleLabel.text = thisOrganizer + YLSDKLanguage.YLSDKSVideoConfidence
                }
            } else {
                titleLabel.text = conficenData?.m_strSubject
            }
            subTitleLabel.text = conficenData?.m_strNumber
            
        } else {
            titleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteDisplayName
            subTitleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteUserName
            print("result:\(CallServerDataSource.getInstance.tkData)")
            
            if let username = YLContactAPI.searchContactName(byNumber:  CallServerDataSource.getInstance.tkData.m_strRemoteUserName, isCloud: CallServerDataSource.getInstance.tkData.m_iAccountID == 1) {
                if (username.characters.count) > 0 {
                    titleLabel.text = username
                }
            }
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            let nowVolum = AVAudioSession.sharedInstance().outputVolume
            if nowVolum < startVolum {
                SoundPlayer.getInstance.cancelRing()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

