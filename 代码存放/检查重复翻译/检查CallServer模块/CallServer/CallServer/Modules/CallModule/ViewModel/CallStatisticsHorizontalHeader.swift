//
//  CallStatisticsHorizontalHeader.swift
//  Odin-UC
//
//  Created by Apple on 30/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

class CallStatisticsHorizontalHeader: UIView {

    /** 左侧发送 */
    var sendLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.textBlackColorYL
        label.font = UIFont.fontWithHelvetica(17)
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        return label
    }()

    /** 右侧接受 */
    var receivedLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.textBlackColorYL
        label.font = UIFont.fontWithHelvetica(17)
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        return label
    }()

    /** 底部分割线 */
    var splitLineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.5)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CallStatisticsHorizontalHeader {
    func updateHeaderView(sendTitle: String, receiveTitle: String) {
        self.addSubview(sendLabel)
        self.addSubview(receivedLabel)
        self.addSubview(splitLineView)

        sendLabel.text = sendTitle
        receivedLabel.text = receiveTitle

        receivedLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(2)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
        }

        sendLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(receivedLabel.snp.left)
            make.top.equalTo(self.snp.top).offset(2)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
        }

        splitLineView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }

    }

}
