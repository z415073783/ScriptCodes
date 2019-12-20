//
//  CallSmallVideoView.swift
//  Odin-YMS
//
//  Created by Apple on 15/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

// MARK: - 👉UI Area
// MARK: - 👉Setter and Getter Area
// MARK: - 👉View LifeCycle
// MARK: - 👉PubliC Method
// MARK: - 👉Private Method
// MARK: - 👉UI Struct Area
// MARK: - 👉UI GE Area
// MARK: - 👉NetRequest Area
// MARK: - 👉Data Struct Area
// MARK: - 👉Listener Area
// MARK: - 👉UITableViewDataSource
// MARK: - 👉UITableViewDelegate
// MARK: - 👉UIScrollViewDelegate

// MARK: - 👉Struct define Area
// true == hide ; false = show
typealias hideOrShowFunc = (_ result: Bool?) -> Void

typealias changeSmallFunc = (_ btn: UIButton?) -> Void
class CallSmallVideoView: UIView {
    // MARK: - 👉Data Area
    var clickHideOrShowBtnFunc: hideOrShowFunc?
    var clickSmallVideoBtnFunc: changeSmallFunc?
    // MARK: - 👉UI Area
    /** 对方的视频画面 */
    lazy var videoView: VideoRenderIosView  = {
        //这里执行操作代码
        let imageView = VideoRenderIosView.init(frame: UIScreen.main.bounds)
        return imageView
    }()

    lazy var videMuteView: CallLocalVideoMuteView = {
        let  view = CallLocalVideoMuteView.init(frame: .zero, isSmall: true)
        view.alpha = 0
        return view
    }()

   lazy var videoHideShowBtn: UIButton = {
       let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        return button
    }()

    var smallVideoViewBtn: UIButton = UIButton()

    // MARK: - 👉View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(videoView)
        videoView.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(160)
            make.width.equalTo(90)
        }

        videoView.addSubview(videMuteView)
        videMuteView.snp.remakeConstraints { (make) in
            make.edges.equalTo(videoView)
        }

        videoView.addSubview(smallVideoViewBtn)
        smallVideoViewBtn.addTarget(self, action: #selector(smallVideoViewBtnClick), for: .touchUpInside)

        smallVideoViewBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(videoView)
        }

        self.addSubview(videoHideShowBtn)
        videoHideShowBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 11)
        videoHideShowBtn.setImage(#imageLiteral(resourceName: "small_video_hide"), for: .normal)

        videoHideShowBtn.snp.remakeConstraints { (make) in
            make.left.top.equalTo(videoView)
            make.width.equalTo(30)
            make.width.equalTo(30)
        }
        videoHideShowBtn.addTarget(self, action: #selector(clickHideShowBtn(btn:)), for: .touchUpInside)
        videoView.layer.borderColor = UIColor.black.cgColor
        videoView.layer.borderWidth = 0.5
    }

    // MARK: - 👉UI GE Area

    @objc func clickHideShowBtn(btn: UIButton) {
        hideOrShowSmallVideo(isHide: !videoHideShowBtn.isSelected)
    }

    @objc func smallVideoViewBtnClick(btn: UIButton) {
        if let thisBlock = clickSmallVideoBtnFunc  {
            thisBlock(btn)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 👉PubliC Method
    func hideOrShowSmallVideo(isHide: Bool) {
        videoHideShowBtn.isSelected = isHide
        if videoHideShowBtn.isSelected == true {
            videoView.alpha = 0
            videoHideShowBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            videoHideShowBtn.setImage(#imageLiteral(resourceName: "small_video_show"), for: .normal)
            videoView.layer.borderWidth = 0
        } else {
            videoView.alpha = 1
            videoHideShowBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 11)

            videoHideShowBtn.setImage(#imageLiteral(resourceName: "small_video_hide"), for: .normal)
            videoView.layer.borderWidth = 1
        }
        
        if videoHideShowBtn.isSelected == true {
            clickHideOrShowBtnFunc?(true)
        } else {
            clickHideOrShowBtnFunc?(false)
        }
    }
}
