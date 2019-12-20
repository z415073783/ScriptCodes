//
//  CallInfoAndTimeView.swift
//  Odin-YMS
//
//  Created by Apple on 26/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
typealias clickTalkInfoBlock = () -> Void

class CallInfoAndTimeView: UIView {
    /** block*/
    var talkInfoActionFunc: clickTalkInfoBlock?

    var clickSelfBtn: UIButton!
    var singelImage: UIImageView!
    var timeLabel: UILabel!

    init(frame: CGRect, block: @escaping clickTalkInfoBlock) {
        super.init(frame: frame)
        talkInfoActionFunc = block
        clickSelfBtn = UIButton()
        self.addSubview(clickSelfBtn)
        clickSelfBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        clickSelfBtn.addTarget(self, action: #selector(clickSelf), for: .touchUpInside)

        singelImage = UIImageView()
        singelImage.image = UIImage.init(named: "signal4")
        self.addSubview(singelImage)

        singelImage.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(8)
        }

        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.fontWithHelvetica(12)
        timeLabel.text = "00:00:00"
        timeLabel.shadowColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        timeLabel.shadowOffset = CGSize.init(width: 1, height: 2)
        timeLabel.numberOfLines = 1
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(singelImage.snp.right).offset(4)
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func clickSelf() {
        if talkInfoActionFunc != nil {
            talkInfoActionFunc!()
        }
    }

}
