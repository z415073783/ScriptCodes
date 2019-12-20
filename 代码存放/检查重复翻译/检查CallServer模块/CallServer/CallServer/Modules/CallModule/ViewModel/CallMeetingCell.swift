//
//  CallMeetingCell.swift
//  CallServer
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class CallMeetingCell: UITableViewCell {
    typealias CallMeetingCellFunc = (_ requestType: meetRequestType) -> Void

    var cellClickBlcok: CallMeetingCellFunc?
    
    /** 头像 */
    var userIcon: UIImageView = {
        let icon = UIImageView.init()
        return icon
    }()

    /** 标题  线高24 */
    var titleLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(16)
        label.textColor = UIColor.textBlackColorYL
        label.textAlignment = .left
        return label
    }()
    
    /** 负标题  线高18 */
    var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(14)
        label.textColor = UIColor.textGrayColorYL
        label.textAlignment = .left
        return label
    }()
    
    /** 负标题  线高28 * 28 内切距离12 */
    var moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMore"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMoreHighlight"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlMoreBtn
        return btn
    }()
    
    /** s摄像头 */
    var muteVideoNormalBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberCamera"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    /** s摄像头 */
    var muteVideoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberCameraForbidden"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberCameraForbiddenHighlight"), for: .highlighted)
        btn.isHidden = true
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlMuteVideoBtn
        return btn
    }()
    
    var muteVideoCloseBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberCameraClose"), for: .normal)
        btn.isHidden = true
//        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlUnMuteVideoBtn
        return btn
    }()
    
    var muteAudioNoramlBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMic") , for: .normal)
        btn.isHidden = true
        return btn
    }()
    var muteAudioBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMicForbidden") , for: .normal)
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMicForbiddenHighlight"), for: .highlighted)
        btn.isHidden = true
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlMuteAudioBtn
        return btn
    }()
    
    var muteAudioCloseBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMicClose") , for: .normal)
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberMicCloseHighlight"), for: .highlighted)
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlUnMuteAudioBtn
        btn.isHidden = true
        return btn
    }()
    
    var muteHandUpBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberHandUp") , for: .normal)
        btn.setImage(#imageLiteral(resourceName: "MeetingMemberHandUpHighlight"), for: .highlighted)
        btn.isHidden = true
        btn.accessibilityIdentifier = YLSDKAutoTestIDs.YLMeetingControlHandUpBtn
        return btn
    }()
    
    var downline: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.1)
        return view
    }()
    var myAnimatedTimer: YLTimer!
    var myAnimatedRepeat: NSInteger = 0
    var cellDataModel:CallMeetingCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        budSubView()
    }
    
    func updateCellByModel(model:CallMeetingCellModel, requestBlock:CallMeetingCellFunc?  = nil ) {
        cellDataModel = model
        cleanCell()
        cellClickBlcok = requestBlock

        print("model.userRoalStateType = \(model.userRoalStateType)")
        switch model.userRoalStateType {
        case .host:
            if let image = model.userIconImage {
                userIcon.image = image
            } else {
                userIcon.image = #imageLiteral(resourceName: "MeetingMemberAvatarHost")
            }
            break;
        case .visitor:
            if let image = model.userIconImage {
                userIcon.image = image
            } else {
                userIcon.image = #imageLiteral(resourceName: "MeetingMemberAvatarVisitor")
            }
            break;
        case .hostSpeaking:
            if let images = model.userIconAnimationImages {
                iconAnimation(images: images)
            } else {
                let images = [#imageLiteral(resourceName: "MeetingMemberAvatarHostSpeaking1"),#imageLiteral(resourceName: "MeetingMemberAvatarHostSpeaking2"),#imageLiteral(resourceName: "MeetingMemberAvatarHostSpeaking3"),#imageLiteral(resourceName: "MeetingMemberAvatarHostSpeaking4")]
                iconAnimation(images: images)
            }
            moreBtn.isHidden = false
            break;
            
        case .visitorSpeaking:
            if let images = model.userIconAnimationImages {
                iconAnimation(images: images)
            } else {
                let images = [#imageLiteral(resourceName: "MeetingMemberAvatarVisitorSpeaking1"),#imageLiteral(resourceName: "MeetingMemberAvatarVisitorSpeaking2"),#imageLiteral(resourceName: "MeetingMemberAvatarVisitorSpeaking3"),#imageLiteral(resourceName: "MeetingMemberAvatarVisitorSpeaking4")]
                iconAnimation(images: images)
            }
            moreBtn.isHidden = true
            break;
        default: break
        }
        titleLabel.text =  model.title
        subTitleLabel.text = model.subTitle
        // 主席模式会议且自己是主持人
        if CallServerDataSource.getInstance.confModel == "3" && CallServerDataSource.getInstance.userRole == "1" {
            if model.sourceDataModel.bMuteVideoByServer == true {
                muteVideoBtn.isHidden = false
            } else {
                //个人 角色为主持人
                if (CallServerDataSource.getInstance.userRole == "1") {
                    muteVideoCloseBtn.isHidden = false
                } else {
                    muteVideoNormalBtn.isHidden = false
                }
            }
            
            if model.sourceDataModel.bRequestSpeak == true {
                muteHandUpBtn.isHidden = false
            } else if model.sourceDataModel.bMuteByServer == true {
                muteAudioBtn.isHidden = false
            } else if model.sourceDataModel.bMuteByServer == false {
                if model.sourceDataModel.bAudioMute == true {
                    muteAudioBtn.isHidden = false
                } else {
                    muteAudioCloseBtn.isHidden = false
                }
            } else {
                muteAudioNoramlBtn.isHidden = false
            }
            
            
            YLSDKLOG.log("[CallServer] [SelfUserRole]" + CallServerDataSource.getInstance.userRole )
            if (CallServerDataSource.getInstance.userRole == "1") {
                moreBtn.isHidden = false
            } else {
                moreBtn.isHidden = true
            }
            
            muteVideoBtn.addTarget(self, action: #selector(muteVideoBtnClick), for: .touchUpInside)
            muteVideoCloseBtn.addTarget(self, action: #selector(muteVideoCloseBtnClick), for: .touchUpInside)
            
            muteAudioBtn.addTarget(self, action: #selector(muteAudioBtnClick), for: .touchUpInside)
            muteAudioCloseBtn.addTarget(self, action: #selector(muteAudioCloseBtnClick), for: .touchUpInside)
            muteHandUpBtn.addTarget(self, action: #selector(handUpBtnClick), for: .touchUpInside)
            moreBtn.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        } else {
            if model.sourceDataModel.bMuteVideoByServer == true {
                muteVideoBtn.isHidden = false
            } else {
                muteVideoNormalBtn.isHidden = false
            }
            
            if  model.sourceDataModel.bMuteByServer == true {
                muteAudioBtn.isHidden = false
            } else {
                muteAudioNoramlBtn.isHidden = false
            }
            
        }
       
    }
    
    @objc func muteAudioCloseBtnClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.mute)
        }
    }
    
    @objc func muteAudioBtnClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.unmute)
        }
    }
    
    @objc func muteVideoCloseBtnClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.muteVideo)
        }
    }
    @objc func muteVideoBtnClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.unmuteVideo)
        }
    }
    
    @objc func muteAudiobuttonClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.mute)
        }
    }
    
    @objc func muteVideobuttonClick() {
        if let cellClickBlcok = cellClickBlcok {
            cellClickBlcok(.muteVideo)
        }
    }
    @objc func handUpBtnClick() {
        let alertSheet = YLAlertActionSheet()
        let allowSpeakItem = YLAlertActionSheetItem.normalInstance(
            YLSDKLanguage.YLSDKMeetingMemberAllowSpeaking,
            action: {[weak self] (item) in
                guard let `self` = self else { return }
                if let cellClickBlcok = self.cellClickBlcok {
                    cellClickBlcok(.allowHandUp)
                }
        })
        allowSpeakItem.textColor = UIColor.mainColorYL
        let disAllowSpeakItem = YLAlertActionSheetItem.normalInstance(
            YLSDKLanguage.YLSDKMeetingMemberRejectSpeaking,
            action: {[weak self] (item) in
                guard let `self` = self else { return }
                
                if let cellClickBlcok = self.cellClickBlcok {
                    cellClickBlcok(.disallowHandUP)
                }
                
        })
        disAllowSpeakItem.textColor = UIColor.mainColorYL
        alertSheet.addItem(allowSpeakItem)
        alertSheet.addItem(disAllowSpeakItem)
        alertSheet.cancelItem = YLAlertActionSheetItem.cancelInstance(YLSDKLanguage.YLSDKCancel)
        alertSheet.show()
    }
    
    @objc func moreBtnClick() {
        let alertSheet = YLAlertActionSheet()
        var  setAsSpeakerOrCancelTitle = ""
        if cellDataModel?.sourceDataModel.bLecturer == true {
            setAsSpeakerOrCancelTitle = YLSDKLanguage.YLSDKCancelTheLecture
        } else {
            setAsSpeakerOrCancelTitle = YLSDKLanguage.YLSDKSetAsALecturer
        }
        let setAsSpeakerOrCancel = YLAlertActionSheetItem.normalInstance(
            setAsSpeakerOrCancelTitle,
            action: {[weak self] (item) in
                guard let `self` = self else { return }
                if let cellClickBlcok = self.cellClickBlcok {
                    if self.cellDataModel?.sourceDataModel.bLecturer == true {
                        cellClickBlcok(.removeLecturerRight )
                    } else {
                        cellClickBlcok(.bLecturer)
                    }
                }
        })
        setAsSpeakerOrCancel.textColor = UIColor.mainColorYL
        
        var setAsHostOrGusterTitle = ""
        if cellDataModel?.sourceDataModel.roleUser == PRESENTER {
            setAsHostOrGusterTitle = YLSDKLanguage.YLSDKSetAsAGuest
        } else if cellDataModel?.sourceDataModel.roleUser == ATTENDEE {
            setAsHostOrGusterTitle = YLSDKLanguage.YLSDKSetAsAModerator
        }
        let setAsHostOrGuster = YLAlertActionSheetItem.normalInstance(
            setAsHostOrGusterTitle,
            action: {[weak self] (item) in
                guard let `self` = self else { return }

                if let cellClickBlcok = self.cellClickBlcok {
                     if self.cellDataModel?.sourceDataModel.roleUser == PRESENTER {
                        cellClickBlcok(.removeHostRight)
                     } else if self.cellDataModel?.sourceDataModel.roleUser == ATTENDEE {
                        cellClickBlcok(.bHost)
                    }
                }
        })
        setAsHostOrGuster.textColor = UIColor.mainColorYL

        let removeItem = YLAlertActionSheetItem.normalInstance(
            YLSDKLanguage.YLSDKRemove,
            action: { (item) in
                if let cellClickBlcok = self.cellClickBlcok {
                    cellClickBlcok(.removeOutConference)
                }
        })
        removeItem.textColor = UIColor.mainColorYL

        let cancelItme = YLAlertActionSheetItem.cancelInstance(YLSDKLanguage.YLSDKCancel)
        
        if cellDataModel?.sourceDataModel.bDataMe == true {
            alertSheet.addItem(setAsSpeakerOrCancel)
        } else {
            alertSheet.addItem(setAsSpeakerOrCancel)
            alertSheet.addItem(setAsHostOrGuster)
            alertSheet.addItem(removeItem)
        }
        alertSheet.cancelItem = cancelItme
        alertSheet.show()
    }
    
    func iconAnimation(images:Array<UIImage>) {
        userIcon.image = nil
        userIcon.animationDuration = 0.25
        userIcon.animationRepeatCount = 0
        userIcon.animationImages = images
        userIcon.startAnimating()
    }
    
    func cleanCell() {
        cellClickBlcok = nil
        userIcon.startAnimating()
        userIcon.image = nil
        userIcon.animationImages = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
        downline.alpha = 1
        
        muteVideoNormalBtn.isHidden = true
        muteVideoBtn.isHidden = true
        muteVideoCloseBtn.isHidden = true
        
        muteAudioNoramlBtn.isHidden = true
        muteAudioBtn.isHidden = true
        muteAudioCloseBtn.isHidden = true
        muteHandUpBtn.isHidden = true
        moreBtn.isHidden = true
        if myAnimatedTimer != nil {
            myAnimatedTimer.invalidate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeDownLine() {
        downline.alpha = 0
    }
}

extension CallMeetingCell {
    func budSubView() {
        contentView.addSubview(userIcon)
        userIcon.snp.remakeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.left.equalTo(self).offset(12)
            make.centerY.equalTo(self)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(11)
            make.left.equalTo(self).offset(58)
            make.width.equalTo(140)
            make.height.equalTo(24)
        }
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(self).offset(58)
            make.width.equalTo(140)
            make.height.equalTo(18)
        }
        
        contentView.addSubview(moreBtn)
        moreBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-12)
            make.centerY.equalTo(self)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        contentView.addSubview(muteVideoNormalBtn)
        contentView.addSubview(muteVideoBtn)
        contentView.addSubview(muteVideoCloseBtn)
        muteVideoNormalBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(moreBtn.snp.left).offset(-12)
            make.centerY.equalTo(self)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        muteVideoBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(muteVideoNormalBtn)
        }
        muteVideoCloseBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(muteVideoNormalBtn)
        }
        muteVideoNormalBtn.isHidden = false
        
        contentView.addSubview(muteAudioNoramlBtn)
        contentView.addSubview(muteAudioBtn)
        contentView.addSubview(muteAudioCloseBtn)
        contentView.addSubview(muteHandUpBtn)
        
        muteAudioNoramlBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(muteVideoNormalBtn.snp.left).offset(-12)
            make.centerY.equalTo(self)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        muteAudioBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(muteAudioNoramlBtn)
        }
        muteAudioCloseBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(muteAudioNoramlBtn)
        }
        muteHandUpBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(muteAudioNoramlBtn)
        }
        muteAudioNoramlBtn.isHidden = false
        
        contentView.addSubview(downline)
        downline.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
