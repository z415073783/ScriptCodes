//
//  CallHoldView.swift
//  Odin-YMS
//
//  Created by Apple on 15/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallHoldView: UIView {

    var holdImageView: UIImageView!
    var holdTextLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.7)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        holdImageView = UIImageView()
        holdImageView.image = UIImage.init(named: "hold_image")
        self.addSubview(holdImageView)

        holdTextLabel = UILabel()
        holdTextLabel.textColor = UIColor.white
        holdTextLabel.font = UIFont.fontWithHelvetica(14)
        holdTextLabel.text = "Hold"
        holdTextLabel.textAlignment = .center
        holdTextLabel.numberOfLines = 1
        self.addSubview(holdTextLabel)

        holdImageView.snp.remakeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(36)
        }

        holdTextLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-26)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
