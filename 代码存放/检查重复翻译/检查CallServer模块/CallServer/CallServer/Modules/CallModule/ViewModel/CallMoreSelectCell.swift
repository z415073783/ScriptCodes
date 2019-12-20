//
//  CallMoreSelectCell.swift
//  Odin-YMS
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallMoreSelectCell: YLSDKTableViewCell {

    //icon头图像
    var iconImageView: UIImageView!
    var iconLabel: UILabel!
    var separatorLine: UIView!

    private var _dataModel: CallMoreCellDataModel!
    var dataModel: CallMoreCellDataModel {
        get {
            return _dataModel
        }
        set {
           _dataModel = newValue
            if newValue.showSelectView == true {
                if _dataModel != nil {
                    if iconImageView == nil {return}
                    iconImageView.image = UIImage.init(named:_dataModel.iamgeSelName)
                }
                if _dataModel != nil {
                    if iconLabel == nil {return}
                    iconLabel.text = _dataModel.titleStrSel
                }
            } else {
                iconImageView.image = UIImage.init(named:_dataModel.imageNorName)
                iconLabel.text = _dataModel.titleStr
            }
        }
    }

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

    func clean() {
        separatorLine.isHidden = false
        iconImageView.image = nil
        iconLabel.text = ""
    }

    fileprivate func setupUI() {
        iconImageView = UIImageView.init()
        self.contentView.addSubview(iconImageView)
        iconImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.centerY.equalTo(self)
        }

        iconLabel = UILabel.init()
        iconLabel.numberOfLines = 1
        iconLabel.font = UIFont.fontWithHelvetica(14)
        iconLabel.textColor = UIColor.textBlackColorYL
        iconLabel.textAlignment = .left

        self.addSubview(iconLabel)
        iconLabel.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.right.equalTo(self).offset(-10)
        }

        separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.5)
        self.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
        }

    }
}
