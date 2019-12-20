//
//  YLCancelLongPressTextView.swift
//  Odin-YMS
//
//  Created by zlm on 2017/10/10.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit

class YLSDKCancelLongPressTextView: YLSDKTextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        self.isSelectable = false
        self.isSelectable = true
        return false
    }

}
