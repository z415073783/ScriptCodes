//
//  MeetingMemberMessageCell.swift
//  Odin-YMS
//
//  Created by soft7 on 2017/11/1.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework

class MeetingMemberMessageCell: YLBasicTableViewCell {
    
    // MARK: - 👉 init
    override func cellDidInit() {
        super.cellDidInit()
        
        backgroundHighLightColorYL = .clear
        
        initLayoutUI()
    }
    
    // MARK: - 👉 ui
    lazy var timeLabel: YLBasicLabel = {
        let view = YLBasicLabel(frame: .zero)
        view.accessibilityIdentifier = "MessageCellTimeView"
        
        view.textAlignment = .right
        view.font = UIFont.fontWithHelvetica(10)
        view.textColor = UIColor.colorWithHex(hexColor: "#666666", alpha: 1)
        return view
    }()
    
    lazy var dotView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityIdentifier = "MessageCellDot"
        
        view.layer.backgroundColor = UIColor.colorWithHex(hexColor: "#cccccc", alpha: 1).cgColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var dotLineView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityIdentifier = "MessageCellDotLine"
        
        view.layer.backgroundColor = UIColor.colorWithHex(hexColor: "#cccccc", alpha: 1).cgColor
        return view
    }()
    
    lazy var messageLabel: YLBasicLabel = {
        let view = YLBasicLabel(frame: .zero)
        view.accessibilityIdentifier = "MessageCellMessageView"
        
        view.numberOfLines = 0
        view.font = UIFont.fontWithHelvetica(12)
        view.textColor = UIColor.colorWithHex(hexColor: "#999999", alpha: 1)
        return view
    }()
    
    // MARK: - 👉 layout
    func initLayoutUI() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        contentView.addSubview(dotView)
        dotView.snp.remakeConstraints { (make) in
            make.leading.equalTo(timeLabel.snp.trailing).offset(6)
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.width.equalTo(dotView.layer.cornerRadius * 2)
            make.height.equalTo(dotView.snp.width)
        }
        
        contentView.addSubview(dotLineView)
        dotLineView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(dotView.snp.centerX)
            make.width.equalTo(1)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(messageLabel)
        messageLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(dotView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - 👉 datasource
    class func preferHeight(withTableView tableView: UITableView,
                            message: MeetingMemberMessage.Message,
                            maxTimeStr:String) -> CGFloat {
        let timeHeight: CGFloat = 20
        let maxTimeWidth: CGFloat = maxTimeStr.getStringWidth(withConstraintedHeight: timeHeight,
                                                              font: UIFont.fontWithHelvetica(10))
        var timeWidth: CGFloat = max(maxTimeWidth, 50)
        timeWidth = min(timeWidth, 80)
        
        var messageWidth: CGFloat = tableView.frame.size.width
        messageWidth -= 14 // messageLabel right margin
        messageWidth -= 6 // margin from messageLabel to dotView
        messageWidth -= 6 // dotView width
        messageWidth -= 6 // margin from dotView to timeLabel
        messageWidth -= timeWidth // timeLabel width
        let messageHeight: CGFloat = message.getMessage().getStringHeight(withConstrainedWidth: messageWidth,
                                                                          font: UIFont.fontWithHelvetica(12))
        
        return max(30, messageHeight + 10)
    }
    
}

// MARK: - 👉 Extensions
private typealias __Data = MeetingMemberMessageCell
extension __Data {
    
    func reload(withMessage message: MeetingMemberMessage.Message, maxTimeStr:String, isShowTime: Bool) {
        timeLabel.text = message.getTimeStr()
        timeLabel.isHidden = !isShowTime
        
        dotView.isHidden = !isShowTime
        
        messageLabel.text = message.getMessage()
        
        let maxTimeWidth = maxTimeStr.getStringWidth(withConstraintedHeight: contentView.frame.size.height,
                                                     font: timeLabel.font)
        var timeWidth = max(maxTimeWidth, 50)
        timeWidth = min(timeWidth, 80)
        timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(timeWidth)
        }
        
        dotLineView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(dotView.snp.centerX)
            make.width.equalTo(1)
            
            if isFirstCell() {
                make.top.equalTo(dotView.snp.centerY)
            }
            else {
                make.top.equalToSuperview()
            }
            
            if isLastCell() {
                make.bottom.equalTo(dotView.snp.centerY)
            }
            else {
                make.bottom.equalToSuperview()
            }
        }
        
    }
}
