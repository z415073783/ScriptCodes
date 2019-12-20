//
//  CallFinishGroundView.swift
//  Odin-YMS
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

typealias clickActionBlock = () -> Void

class CallFinishGroundView: UIView {

    var detailActionFunc: clickActionBlock?
    var bgButton: UIButton!
    var mainTitle: UILabel!
    var subTitle: UILabel!

     init(frame: CGRect, block: @escaping clickActionBlock) {
        detailActionFunc = block
        super.init(frame: frame)
        self.backgroundColor = UIColor.talkFinishGroundColor()
        bgButton = UIButton()
        self.addSubview(bgButton)
        bgButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        bgButton.addTarget(self, action: #selector(clickSelf), for: .touchUpInside)

        mainTitle = UILabel()
        self.addSubview(mainTitle)
        mainTitle.textColor = UIColor.white
        mainTitle.font = UIFont.fontWithHelvetica(18)
        mainTitle.text = YLSDKLanguage.YLSDKCallFinished//
        mainTitle.numberOfLines = 2
        mainTitle.textAlignment = .center
        mainTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY).offset(-6)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
        }

        subTitle = UILabel()
        self.addSubview(subTitle)
        subTitle.textColor = UIColor.white
        subTitle.font = UIFont.fontWithHelvetica(16)
        subTitle.text = ""
        subTitle.numberOfLines = 2
        subTitle.textAlignment = .center

        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(6)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
        }
    }

    @objc func clickSelf() {
        if let thisBlock = detailActionFunc {
            thisBlock()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
