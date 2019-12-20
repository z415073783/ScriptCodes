//
//  MeetingMemberMessageEmptyView.swift
//  Odin-YMS
//
//  Created by soft7 on 2017/11/2.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework

class MeetingMemberMessageEmptyView: YLBasicView {

    // MARK: - 👉 init
    override func viewDidInit() {
        super.viewDidInit()
        
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview().offset(38)
            make.height.equalTo(24)
        }
        
        addSubview(emptyImageView)
        emptyImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }
    
    lazy var emptyImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.accessibilityIdentifier = "emptyImageView"
        view.contentMode = .center
        view.image = #imageLiteral(resourceName: "GeneralEmptyData")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.accessibilityIdentifier = "titleLabel"
        view.font = UIFont.fontWithHelvetica(13)
        view.textColor = UIColor.textHintColorYL
        view.textAlignment = .center
        view.text = YLSDKLanguage.YLSDKMeetingMemberNoMessage
        return view
    }()
}
