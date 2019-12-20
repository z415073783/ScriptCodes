//
//  CallManagerUIController.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class CallManagerUIController: UIViewController {

    /** 是否视频 */
    var isVideo: Bool = false
    /** 是非来电  false 表示去电， Yes 表示来电 */
    var isCallin: Bool = false
    /** 对方是否开启了摄像头 */
    var oppositeCamera: Bool = false
    /** 本地是否开启摄像头  */
    var localCamera: Bool = false
    /** 是否成功建立通话  */
    var isTalkEstablish: Bool = false
    /** 是否隐藏底部menuView */
    var bottomeMenuHide: Bool = false
    /** 是否收到辅助流*/
    var isReceivedShareData: Bool = false
    /** 是否会议*/
    var isConficen: Bool = false
    /** 是否正在缩放*/
    var isZomming: Bool =  false
    /** 是否正mute麦克风*/
    var isMute: Bool =  false
    
    // MARK: - 👉Property UI Area
    var historyMainPoinX: CGFloat = 0
    var historySharePointX: CGFloat = 0
    var onlySelfInMeetingShow: Bool =  true
    
    /** 语音聊天背景视图 */
    var bgImageView: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        imageView.isUserInteractionEnabled =  true
        return imageView
    }()
    
    var contentView: UIView?
    
    /** 大画面滚动UIScrollView */
    var mainScrollView: UIScrollView?
    
    /** 主要的视频画面 */
    var mainVideoView: VideoRenderIosView = {
        //这里执行操作代码
        let videoImageView = VideoRenderIosView.init(frame: UIScreen.main.bounds)
        videoImageView.backgroundColor = UIColor.talkFinishGroundColor()
        return videoImageView
    }()
    
    /** 对方的视频画面 */
    var smallVideoView: CallSmallVideoView  = {
        //这里执行操作代码
        let imageView = CallSmallVideoView.init(frame: UIScreen.main.bounds)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /** 大画面滚动UIScrollView */
    var shareScrollView: UIScrollView?
    
    var swipeLeftRecognizer: UISwipeGestureRecognizer?
    var swipeRightRecognizer: UISwipeGestureRecognizer?
    var control: UIPageControl?
    var shareNoticebtn: UIButton?
    // var smallVideoViewBtn: UIButton!
    
    /** 第二视频画面 */
    var shareVideoView: VideoRenderIosView = {
        //这里执行操作代码
        let videoImageView = VideoRenderIosView.init(frame: UIScreen.main.bounds)
        videoImageView.backgroundColor = UIColor.talkFinishGroundColor()
        return videoImageView
    }()
    
    /** mainVideoView 显示Video Type */
    var mainVideoType: LogicVideoType =  LogicVideoType.LvtUnknow
    /** smallVideoView 显示Video Type */
    var smallVideoType: LogicVideoType = LogicVideoType.LvtUnknow
    /** secondVideoView 显示Video Type */
    var secondVideoType: LogicVideoType = LogicVideoType.LvtUnknow
    
    /** 主标题 Label*/
    var titleLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.shadowColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        label.shadowOffset = CGSize.init(width: 1, height: 2)
        return label
    }()
    
    var titleLableEncryptImage: UIImageView = {
        let image = UIImageView.init()
        image.image = #imageLiteral(resourceName: "call_encrypt")
        return image
    }()
    
    /** 小标题 Label*/
    var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    /** 动画 UIImageView*/
    var animationImage: UIImageView = {
        let image = UIImageView.init()
        return image
    }()
    
    var moreView: CallMoreView?
    var moreAngeleView: CallAngleView?
    
    var dtmfView: CallDtmfView?
    var showNoticeCountTimer: Int = 0
    
    var videoMuteViewBig: CallLocalVideoMuteView?
    
    var coverView: UIView?
    var presentVC: UIViewController?
    /** 接听挂断 静音等的按钮容器 UIlabel*/
    var upperContainerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled =  true
        return view
    }()
    
    /** 挂断 UIButton*/
    var hungUpBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "hungup_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "hungup_sel"), for: [.highlighted, .selected])
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingHunagupBtn
        return btn
    }()
    
    /** 挂断 文字提示*/
    var hungUpLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKHungUp
        return label
    }()
    
    
    /** 接听 amswerButton*/
    var answerBtn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "CallControlInviteNor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "CallControlInvitePre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingInviteBtn
        return btn
    }()
    
    
    /** 接听 文字提示*/
    var answerLabel: UILabel = {
        
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKInvite
        return label
    }()
    
    /** 邀请 inviteButton*/
    var bottmInviteBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage( #imageLiteral(resourceName: "CallControlInviteNor"), for: .normal)
        btn.setImage( #imageLiteral(resourceName: "CallControlInvitePre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingInviteBtn
        return btn
    }()
    
    /** 邀请 文字提示*/
    var inviteLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKInvite
        return label
    }()
    
    /** 会议成员 bottmMemberListBtn*/
    var bottmMemberListBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "CallControlMemberListNor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "CallControlMemberListPre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingMemberListBtn
        return btn
    }()
    
    /** 会议成员 文字提示*/
    var memberListLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKMeetingMemberTitle
        return label
    }()
    
    /** 转音频 changeAudioBtn*/
    var changeAudioBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "CallControlChangeAudioNor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "CallControlChangeAudioPre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingChangeAudioBtn
        return btn
    }()
    
    /** 转音频 文字提示*/
    var changeAudioLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKChangeAudio
        return label
    }()
    
    /** 静音 UIButton*/
    var muteBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "mute_headphone_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "mute_headphone_click"), for: .highlighted)
        btn.setImage(#imageLiteral(resourceName: "mute_headphone_sel"), for: .selected)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingMuteBtn
        return btn
    }()
    /** 静音 UIlabel*/
    var muteLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKMute
        return label
    }()
    
    var handUpButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "state_sel"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "state_sel"), for: .highlighted)
        btn.setImage(#imageLiteral(resourceName: "state_nor"), for: .selected)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingMuteBtn
        btn.isHidden = true
        return btn
    }()
    
    /** 静音 UIlabel*/
    var handUpLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKHandUp
        label.isHidden = true
        return label
    }()
    
    var muteNoticeView: UIImageView?
    var holdNOticeView: UIImageView?
    
    
    
    /** 计时器 YLTimer*/
    var timers: YLTimer?
    /** 计时器 TimeInterval*/
    var talkTimeStartInterval: TimeInterval?
    var talkstatistics: TalkStatistics?
    
    /** yealink 切换摄像头 UIButton*/
    var switchCamearBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "swithc_camear_nor"), for: .normal)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingSwitchCameraBtn
        return btn
    }()
    
    /** yealink 改变屏幕方向 UIButton*/
    var changeScreemBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "full_screen_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "full_screen_pre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingChangeScreemBtn
        return btn
    }()
    
    /** yealink 锁屏 UIButton*/
    var lockScreemBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "lock_screen_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "lock_screen_pre"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingLockScreemBtn
        btn.alpha = 0
        return btn
    }()
    
    // 底部工作区通话过程中 UI  模块
    
    /** 接听, 通话时间长度 label ，挂断 静音等的按钮容器 */
    var bottomContainerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled =  true
        return view
    }()
    
    /** 接听,挂断 静音等的按钮容器， 有背景色彩 */
    var bottomBtnContainerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled =  true
        return view
    }()
    
    /** 计时 UIlabel*/
    var timeLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(15)
        return label
    }()
    
    let btnWH =  Int(56)
    /** 摄像头*/
    var bottmCamearBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "mute_camear_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "mute_camear_click"), for: .highlighted)
        btn.setImage(#imageLiteral(resourceName: "mute_camear_sel"), for: .selected)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingBottmCamearBtn
        btn.tag = 0
        return btn
    }()
    var bottmCamearLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKCamera
        return label
    }()
    
    
    /** 静音*/
    var bottmMuteBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "mute_headphone_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "mute_headphone_sel"), for: .highlighted)
        return btn
    }()
    
    var bottmMuteLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKMute
        return label
    }()
    
    /** 更多*/
    var bottmMoreBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "dtmf_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "dtmf_sel"), for: [.highlighted, .selected])
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingBottmMoreBtn
        return btn
    }()
    
    var bottmMoreLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKDialKeyboard
        return label
    }()
    // 更对的弹出View
    //    var moreSelectView: CallMoreSelectionView?
    /** 扬声器*/
    var bottmSpeakerBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "speaker_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "speaker_click"), for: .highlighted)
        btn.setImage(#imageLiteral(resourceName: "speaker_sel"), for: .selected)
        return btn
    }()
    
    var bottmSpeakerLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKSpeaker
        return label
    }()
    
    /** DTMF*/
    var bottmDtmfBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "dtmf_nor"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "dtmf_sel"), for: [.highlighted, .selected])
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingBottmDtmfBtn
        return btn
    }()
    
    var bottmDtmfLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(12)
        label.text = YLSDKLanguage.YLSDKDialKeyboard
        return label
        
    }()
    
    /** 静音View */
    var muteSpeakerImageView: UIImageView = {
        //这里执行操作代码
        //        let imageView = UIImageView.init(image: UIImage.init(named: "silence_icon"))
        let imageView = UIImageView.init()
        return imageView
    }()
    var muteSpeakerState: Int = 0
    //    var muteCamearState: Int = 0
    var muteHeaderPhoneState: Int = 0
    
    var isAddNewDevice: Bool = false
    
    /** 远端是否hold */
    var isRemoteHold = false
    
    /**  摄像头View */
    var muteCamearImageView: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "noVideo_icon"))
        return imageView
    }()
    
    /** 话筒View */
    var muteHeaderPhoneImageView: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init(image: UIImage.init(named: "header_phone_mute_big"))
        return imageView
    }()
    
    /** 静音View */
    var bigImageViewOne: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        return imageView
    }()
    
    /**  摄像头View */
    var bigImageViewTwo: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        return imageView
    }()
    
    /** 话筒View */
    var bigImageViewThree: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        return imageView
    }()
    
    /** 话筒View */
    var holdImageView: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "hold_big")
        return imageView
    }()
    
    var audioHoldCover: UIView = {
        //这里执行操作代码
        let view = UIView.init()
        view.backgroundColor = UIColor.black
        view.alpha = 0.4
        return view
    }()
    
    var holdView: CallHoldView?
    var callinfoTimeView: CallInfoAndTimeView?
    
    var doubleMainTap: UITapGestureRecognizer?
    var singleMainTap: UITapGestureRecognizer?
    
    var doubleShareTap: UITapGestureRecognizer?
    var singleShareTap: UITapGestureRecognizer?
}


