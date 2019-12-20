//
//  UIFont+Extension.swift
//  UME
//
//  Created by zlm on 16/7/22.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit
public extension UIFont {

    /// 默认字体
    class func fontWithHelvetica(_ fontSize: CGFloat, _ isAutoSize: Bool? = false) -> UIFont {
        var autoSize = fontSize
        if kScreenWidth == 320 {
            //小屏幕

        } else {
            autoSize = fontSize + 2
        }
        return UIFont(name: kFontTextDefault, size: autoSize)!
    }

    class func fontWithHelveticaBold(_ fontSize: CGFloat, _ isAutoSize: Bool? = false) -> UIFont {
        var autoSize = fontSize
        if kScreenWidth == 320 {
            //小屏幕

        } else {
            autoSize = fontSize + 2
        }
        return UIFont(name: kFontTextDefaultBold, size: autoSize)!
    }

    class func fontWithHelveticaLight(_ fontSize: CGFloat, _ isAutoSize: Bool? = false) -> UIFont {
        var autoSize = fontSize
        if kScreenWidth == 320 {
            //小屏幕

        } else {
            autoSize = fontSize + 2
        }
        return UIFont(name: kFontTextDefaultLight, size: autoSize)!
    }

}
