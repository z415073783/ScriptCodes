//
//  UIColor+YLColor.swift
//  UME
//
//  Created by zlm on 16/7/18.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit
extension UIColor {
    class func colorWithHex(hexColor: String, alpha: Float) -> UIColor {
        var hex = hexColor
        if hex.hasPrefix("#") {
            hex = hex.filter {$0 != "#"}
        }
        let hexVal = Int(hex, radix: 16)
        return UIColor._colorWithHex(hexColor: hexVal!, alpha: CGFloat(alpha))
    }

    class func _colorWithHex(hexColor: CLong, alpha: CGFloat) -> UIColor {
        let red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0
        let green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0
        let blue = ((CGFloat)((hexColor & 0xFF))/255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

// MARK: 程序主色调
    class var mainColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#1786d4", alpha: 1)
        }
    }

// MARK: 文字颜色
    /// 黑色文字
    class var textBlackColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#333333", alpha: 1)
        }
    }

    /// 浅灰色文字
    ///
    /// - Returns:
    class var textLightGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#cccccc", alpha: 1)
        }
    }

    /// 中灰色文字
    class var textMediumGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#b3b3b3", alpha: 1)
        }
    }

    /// 灰色文字
    class var textGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#999999", alpha: 1)
        }
    }
    /// 提示文字颜色 最浅颜色
    class var textHintColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#bbbbbb", alpha: 1)
        }
    }

    /// 绿色文字
    class var textGreenColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#08afa5", alpha: 1)
        }
    }

    ///蓝色文字
    class var textBlueColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#1786d4", alpha: 1)
        }
    }
    class func textBlueAlphaColorYL(_ alpha: Float? = 1) -> UIColor {
        return UIColor.colorWithHex(hexColor: "#1786d4", alpha: alpha!)
    }

    /// 红色文字
    class var textRedColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#fd3939", alpha: 1)
        }
    }

    ///金黄色文字
    class var textGoldenYellowColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#f7ba2a", alpha: 1)
        }
    }
    // MARK: 线条颜色

    /// 顶部提示框背景
    class var topAlertColor: UIColor {
        get {
            return UIColor(red: 253.0/255.0, green: 209.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        }
    }

    /// 线条 深灰
    class var lineDarkGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#b2b2b2", alpha: 1)
        }
    }
    /// 线条 中灰
    class var lineMediumGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#d8d8d8", alpha: 1)
        }
    }
    /// 线条 浅灰
    class var lineLightGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#e8e8e8", alpha: 1)
        }
    }
    class var lineColor: UIColor {
        return UIColor.colorWithHex(hexColor: "#000000", alpha: 0.1)
    }

// MARK: 背景色
    //最浅颜色背景
    class var backgackgroundTintColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#f5f7fa", alpha: 1)
        }
    }

    //亮灰色背景
    class var backgroundLightGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#f0f2f5", alpha: 1)
        }
    }

    //灰色背景
    class var backgroundGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#f4f5f6", alpha: 1)
        }
    }

    //按钮深蓝背景
    class var buttonBluePressColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#238bdb", alpha: 1.0)
        }
    }
//    //tableViewHeadTitle背景
    class var tableViewHeadTitleBackgroundColorYL: UIColor {
        return UIColor.colorWithHex(hexColor: "ff0000", alpha: 1)
    }
// MARK: 按钮颜色
    // 按钮主色调 背景 正常
    class var buttonColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#2ca7e5", alpha: 1)
        }
    }
    // 按钮主色调 点击态背景 高亮
    class var buttonHighLightColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#2793c9", alpha: 1)
        }
    }

    //红色按钮 正常
    class var buttonRedColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#ef3939", alpha: 1)
        }
    }
    //红色按钮 高亮
    class var buttonRedHighLightColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#ef3939", alpha: 1)
        }
    }
    // 蓝色按钮
    class var buttonBlueColorYL: UIColor {
        return dailHeaderBtnTextColor(alpha: 1)
    }
   //灰色按钮
    class var buttonGrayColorYL: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#8e8e8e", alpha: 1)
        }
    }// MARK: 辅色小面积使用，用于警示炒作和提醒
    class func mainNoticeColorYL(alpha: Float) -> UIColor {
        return UIColor.colorWithHex(hexColor: "#ff4949", alpha: alpha)
    }

    // 重要级文字信息， 内容标题信息
    class var importTitleColor: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#333333", alpha: 1)
        }
    }

    // 拨号按钮点击nor信息
    class var callBtnNorColor: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#13ce66", alpha: 1)
        }
    }

    // 拨号按钮点击sel信息
    class var callBtnSelColor: UIColor {
        get {
            return UIColor.colorWithHex(hexColor: "#11bd4e", alpha: 1)
        }
    }

    // MARK: 白色 alpha
    class func whiteColorAlphaYL(alpha: Float) -> UIColor {
        return UIColor(white: 1, alpha: CGFloat(alpha))
    }
    // MARK: 黑色 alpha

    class func blackColorAlphaYL(alpha: Float) -> UIColor {
        return UIColor.colorWithHex(hexColor: "#000000", alpha:alpha)
    }

    // 拨号键背景颜色普通
    class func dialPadBgColor() -> UIColor {
        return UIColor.white
    }

    // 拨号键背景颜色选中
    class func dialPadKeyClickBgColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "ebedf0", alpha: 1)
    }

    // 拨号键背景颜色选中
    class func dialBlackGroundColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "f5f7fa", alpha: 1)
    }

    // 通话详情header背景颜色
    class func dailDeatilHeaderGroundColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "f5f7fa", alpha: 1)
    }

    // 通话详情header背景颜色
    class func dailHeaderBtnTextColor(alpha: Float) -> UIColor {
        return UIColor.colorWithHex(hexColor: "2699f4", alpha: alpha)
    }

    // 通话详情header按下背景颜色
    class func dailHeaderBtnTextSelectColor(alpha: Float) -> UIColor {
        return UIColor.colorWithHex(hexColor: "1f92eb", alpha: alpha)
    }

    // 子标题背景颜色
    class func subTitleGroundColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "bfbfbf", alpha: 1)
    }

    // 子标题背景颜色
    class func talkFinishGroundColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "1b2330", alpha: 1)
    }

    // 背景颜色
    class func backgroundHighLightColorYL() -> UIColor {
        return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

    }
    // 摄像头关闭文字颜色
    class func camearMuteLabelColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "565b66", alpha: 1)
    }

    // 摄像头关闭文字颜色
    class func camearMuteBGColor() -> UIColor {
        return UIColor.colorWithHex(hexColor: "20252e", alpha: 1)
    }
    //组织架构搜索框背景色
    class var contectSearchBackgrounViewColor: UIColor {
        return UIColor.colorWithHex(hexColor: "edeef0", alpha: 1)
    }
    //标题背景色
    class var titleBackGroudColorYL: UIColor {
        return UIColor.colorWithHex(hexColor: "efefef", alpha: 1)
    }

}
