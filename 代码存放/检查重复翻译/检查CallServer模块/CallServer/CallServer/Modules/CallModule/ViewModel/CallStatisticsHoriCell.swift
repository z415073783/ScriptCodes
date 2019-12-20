//
//  CallStatisticsHoriCell.swift
//  Odin-UC
//
//  Created by Apple on 30/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

class CallStatisticsHoriCell: UITableViewCell {

    var viewleft: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }()

    /** 统计类名 */
    var classLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(14)
        label.textColor = UIColor.textGrayColorYL
        label.textAlignment = .left
        return label
    }()

    /** 统计发送 */
    var sendLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(14)
        label.textColor = UIColor.textGrayColorYL
        label.textAlignment = .left
        return label
    }()

    /** 统计接收 */
    var receiveLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(14)
        label.textColor = UIColor.textGrayColorYL
        label.textAlignment = .left
        return label
    }()

    /** 底部分割线 */
    var splitLineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.1)
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension CallStatisticsHoriCell {

    fileprivate func setupUI() {
        self.addSubview(viewleft)
        self.addSubview(classLabel)
        self.addSubview(sendLabel)
        self.addSubview(receiveLabel)
        self.addSubview(splitLineView)

        viewleft.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
        }

        classLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(viewleft)
            make.left.equalTo(viewleft.snp.left).offset(25)
        }

        sendLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(viewleft.snp.right)
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
        }

        receiveLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
        }

        splitLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-12)
            make.left.equalTo(self).offset(12)
            make.height.equalTo(0.5)
        }
    }

    public func updateUI(classString: String, sendString: String, receiveString: String) {
        classLabel.text =  localizedSDK(key: classString)
        sendLabel.text = sendString
        receiveLabel.text = receiveString
    }

}
