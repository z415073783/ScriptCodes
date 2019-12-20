//
//  CallOutGoingView.swift
//  Odin-YMS
//
//  Created by Apple on 25/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
typealias hungUpActionBlock = () -> Void

class CallOutGoingAudioView: UIView {

    /** block*/
    var hungUpActionFunc: hungUpActionBlock?
    /** 语音聊天背景视图 */
    lazy var bgImageView: UIImageView = {
        //这里执行操作代码
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "full_size_render")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5), resizingMode: .stretch)

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
        return label
    }()

    /** 此标题 Label*/
    lazy var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.fontWithHelvetica(13)
        return label
    }()

    /** 此标题 Label*/
    lazy var animationImage: UIImageView = {
        let image = UIImageView.init()
        return image
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

    var myAnimatedTimer: YLTimer!
    var myAnimatedRepeat: NSInteger = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgImageView)
        self.addSubview(inComeLabel)

        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(animationImage)
        self.addSubview(hungupBtn)
        self.addSubview(hungupLabel)

        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        inComeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(60)
            make.left.right.equalTo(self)
            make.height.equalTo(20)
        }

        animationImage.image = UIImage.init(named: "call_out_animation0")
        myAnimatedTimer = Timer.scheduledTimerYL(withTimeInterval: 0.2, repeats: true, block: { [weak self] (_)  in
            self?.setNextImage()
        })

        hungupLabel.text = YLSDKLanguage.YLSDKHungUp

        hungupBtn.setImage(UIImage.init(named: "hungup_nor"), for: .normal)
        hungupBtn.setImage(UIImage.init(named: "hungup_sel"), for: .highlighted)

        hungupBtn.addTarget(self, action: #selector(hungupBtnClick), for: .touchUpInside)
        statusBarOrientationDidChange()
        addListener()
        //EventStatisticsManager.getInstance.startEvent(event: .showOutgo)
    }

    @objc func statusBarOrientationDidChange() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {

            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self).offset(120)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(42)

            })

            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(22)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
            })

            animationImage.snp.remakeConstraints { (make) in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(52)
                make.centerX.equalTo(bgImageView.snp.centerX)
                make.width.equalTo(293)
                make.height.equalTo(40)
            }

            hungupLabel.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp.bottom).offset(-60)
                make.left.right.equalTo(self)
            }

            hungupBtn.snp.remakeConstraints { (make) in
                make.width.equalTo(60)
                make.height.equalTo(60)
                make.centerX.equalTo(self)
                make.bottom.equalTo(hungupLabel.snp.top).offset(-8)
            }

        } else {

            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self).offset(120)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(42)

            })

            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(22)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
            })

            animationImage.snp.remakeConstraints { (make) in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(52)
                make.centerX.equalTo(bgImageView.snp.centerX)
                make.width.equalTo(293)
                make.height.equalTo(40)
            }

            hungupLabel.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp.bottom).offset(-30)
                make.left.right.equalTo(self)
            }

            hungupBtn.snp.remakeConstraints { (make) in
                make.width.equalTo(60)
                make.height.equalTo(60)
                make.centerX.equalTo(self)
                make.bottom.equalTo(hungupLabel.snp.top).offset(-8)
            }
        }
    }
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)

    }
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }

    func setNextImage() {
        myAnimatedRepeat = myAnimatedRepeat % 7
        let imageName = "call_out_animation" + String(myAnimatedRepeat)
        animationImage.image = UIImage.init(named:imageName)
        myAnimatedRepeat = myAnimatedRepeat + 1

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
        subTitleLabel.text = CallServerDataSource.getInstance.getCallIPOrName()
        if let username = YLContactAPI.searchContactName(byNumber:  CallServerDataSource.getInstance.getCallIPOrName(), isCloud: true) {
            if (username.characters.count) > 0 {
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

    deinit {
        myAnimatedTimer.invalidate()
        removeListener()
        //EventStatisticsManager.getInstance.endEvent(event: .showOutgo)
    }

}
