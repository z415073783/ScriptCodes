//
//  CallStatisticsCell.swift
//  Odin-UC
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

class CallStatisticsCell: UITableViewCell {

    /** 统计名字 */
    var leftLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(14)
        label.textColor = UIColor.textGrayColorYL
        label.textAlignment = .left
        return label
    }()

    /** 统计数值 */
    var rightLabel: UILabel = {
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

extension CallStatisticsCell {
    fileprivate func setupUI() {
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(splitLineView)
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left).offset(25)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }

        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right).offset(-25)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(leftLabel.snp.right)
        }
        splitLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-12)
            make.left.equalTo(self).offset(12)
            make.height.equalTo(0.5)
        }
    }

    public func updateUI(stringLeft: String, stringRight: String) {
        leftLabel.text = localizedSDK(key: stringLeft)
        rightLabel.text = stringRight
    }
}
