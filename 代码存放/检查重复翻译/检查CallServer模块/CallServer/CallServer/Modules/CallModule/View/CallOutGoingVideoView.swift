//
//  CallOutGoingVideoView.swift
//  Odin-YMS
//
//  Created by Apple on 26/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallOutGoingVideoView: UIView {
    /** block*/
    var hungUpActionFunc: hungUpActionBlock?
    /** 语音聊天背景视图 */
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
        label.text = YLSDKLanguage.YLSDKoutGoing

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

    /** 次标题 Label*/
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
    lazy var switchCamearBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "swithc_camear_nor"), for: .normal)
        return button
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
        imageView.image = #imageLiteral(resourceName: "camear_close_big")
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
        label.text = ""
        label.alpha = 0
        return label
    }()

    deinit {
        removeListener()
//        EventStatisticsManager.getInstance.endEvent(event: .showOutgo)
    }

    func removeLayout() {
        YLLogicAPI.removeLayout(self.bgImageView, viewId: 0, eLayoutType: Int32(LogicVideoType.LvtLocal.rawValue))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgImageView)

//        if LogicAPI.get_CameraState() == 0 {
//            camearMuteBGView.removeFromSuperview()
//            camearMuteImage.removeFromSuperview()
//            camearMuteLabel.removeFromSuperview()
//        } else {
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
//        }

        self.addSubview(inComeLabel)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(switchCamearBtn)
        self.addSubview(hungupBtn)
        self.addSubview(hungupLabel)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        switchCamearBtn.snp.makeConstraints { (make) in
            if isIphoneX  && (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                make.top.equalTo(self).offset(48)
            } else {
                make.top.equalTo(self).offset(24)
            }
            
            make.right.equalTo(self).offset(-12)
            make.width.equalTo(30)
            make.height.equalTo(30)
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

        hungupLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-60)
            make.left.right.equalTo(self)
        }
        hungupLabel.text = YLSDKLanguage.YLSDKHungUp

        hungupBtn.setImage(UIImage.init(named: "hungup_nor"), for: .normal)
        hungupBtn.setImage(UIImage.init(named: "hungup_sel"), for: .highlighted)
        hungupBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.centerX.equalTo(self)
            make.bottom.equalTo(hungupLabel.snp.top).offset(-8)
        }
        switchCamearBtn.addTarget(self, action: #selector(switchCamearBtnClick), for: .touchUpInside)
        hungupBtn.addTarget(self, action: #selector(hungupBtnClick), for: .touchUpInside)
        YLSDKDispatchManager.videoEngineQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            let state = YLLogicAPI.get_CameraState()
            DispatchQueue.main.syncYL {
                if self == nil {
                    return
                }
                if state == 0 {
                    self?.camearMuteBGView.alpha = 0
                    self?.camearMuteImage.alpha = 0
                    self?.camearMuteLabel.alpha = 0
                    self?.switchCamearBtn.isEnabled = true
                    CallServerDataSource.getInstance.outgoingCloseCamera = false
                } else {
                    self?.camearMuteBGView.alpha = 1
                    self?.camearMuteImage.alpha = 1
                    self?.camearMuteLabel.alpha = 1
                    self?.switchCamearBtn.isEnabled = false
                    CallServerDataSource.getInstance.outgoingCloseCamera = true
                }
                YLLogicAPI.setMyLayout(self?.bgImageView, viewId: 0, eLayoutType: Int32(LogicVideoType.LvtLocal.rawValue))
            }
        }
        addstatusBarOrientationChangeListener()
//        EventStatisticsManager.getInstance.startEvent(event: .showOutgo)
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
        if let thisBlock = hungUpActionFunc {
            thisBlock()
        }
    }

    func updateConfNumber(subtitle: String) {
        subTitleLabel.text = subtitle
    }

    func updateYMSCallinfo (title: String, subtitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subtitle
    }

    func updateInfo() {
        titleLabel.text = CallServerDataSource.getInstance.getCallIPOrName()

        if let username = YLContactAPI.searchContactName(byNumber:  CallServerDataSource.getInstance.getCallIPOrName(), isCloud: true) {
            if (username.count) > 0 {
                titleLabel.text = username
                subTitleLabel.text = CallServerDataSource.getInstance.getCallIPOrName()
            }
        }
    }

    func updateCallOutDisplay() {
        titleLabel.text = CallServerDataSource.getInstance.getTkData().m_strRemoteDisplayName
        if let username = YLContactAPI.searchContactName(byNumber:  CallServerDataSource.getInstance.tkData.m_strRemoteUserName, isCloud: CallServerDataSource.getInstance.tkData.m_iAccountID == 1) {
            if (username.count) > 0 {
                titleLabel.text = username
                CallServerDataSource.getInstance.remoteName = username
                subTitleLabel.text = CallServerDataSource.getInstance.tkData.m_strRemoteUserName
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
