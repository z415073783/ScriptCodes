//
//  CallLocalVideoMute.swift
//  Odin-YMS
//
//  Created by Apple on 07/07/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallLocalVideoMuteView: UIView {

    /** 关闭摄像头Image*/
    lazy var camearMuteBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.camearMuteBGColor()
        return view
    }()

    /** 关闭摄像头Image*/
    lazy var camearMuteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "camear_close_big")
        return imageView
    }()

    init(frame: CGRect, isSmall: Bool) {
        super.init(frame: frame)
        if isSmall == true {
            camearMuteImage.image = #imageLiteral(resourceName: "camear_close_small")
        } else {
            camearMuteImage.image = #imageLiteral(resourceName: "camear_close_big")
        }
        self.addSubview(camearMuteBGView)
        self.addSubview(camearMuteImage)

        camearMuteBGView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }

        camearMuteImage.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
