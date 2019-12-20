//
//  CallMeetingSectionHeader.swift
//  CallServer
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
class CallMeetingSectionHeader: UITableViewHeaderFooterView {

    var titleLabel: UILabel!
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        buildSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSubView() {
        self.backgroundColor = UIColor.tableViewHeadTitleBackgroundColorYL
        initTitleLabel()
    }
    
    fileprivate func initTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.fontWithHelvetica(14.0)
        titleLabel.textColor = UIColor.textGrayColorYL
        
        titleLabel.backgroundColor = UIColor.clear
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(12)
            make.height.equalTo(20)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(self).offset(-5)
        }
    }
}
