//
//  CallStatisticsHeaderCell.swift
//  Odin-UC
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

class CallStatisticsHeaderCell: UITableViewCell {

    /** 统计名字 */
    var leftLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.fontWithHelvetica(16)
        label.textColor = UIColor.textBlackColorYL
        label.textAlignment = .left
        return label
    }()
    /** 底部分割线 */
    var splitLineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.1)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CallStatisticsHeaderCell {
    fileprivate func setupUI() {
        self.addSubview(leftLabel)
        self.addSubview(splitLineView)
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left).offset(12)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        splitLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-12)
            make.left.equalTo(self).offset(12)
            make.height.equalTo(0.5)
        }
    }

    public func updateUI(stringLeft: String) {
        leftLabel.text =  localizedSDK(key: stringLeft)
    }
}
