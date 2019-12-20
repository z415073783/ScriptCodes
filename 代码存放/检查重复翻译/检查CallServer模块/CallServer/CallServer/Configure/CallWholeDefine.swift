//
//  CallWholeDefine.swift
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

import Foundation

let kDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"]

let OpenSDK = false //SDK  配置开启

/** 时间常量  */
/** 1 minute  */
let TIME_INTERVAL_ONE_MINUTE: Int = (60 * 1)
/** 1 hour  */
let TIME_INTERVAL_ONE_HOUR: Int = (60 * 60 * 1)
/** 1 day  */
let TIME_INTERVAL_ONE_DAY: Int = (60 * 60 * 24)
/** 1 week  */
let TIME_INTERVAL_ONE_WEEK: Int = (60 * 60 * 24 * 7)
/** 1 month  */
let TIME_INTERVAL_ONE_MONTH: Int = (60 * 60 * 24 * 30)
/** 1 year  */
let TIME_INTERVAL_ONE_YEAR: Int = (60 * 60 * 24 * 365)

//来电的identifity
let kCallCategory = "call_category"
//本地通知identifity
let kCallingStateIdentifity = "kCallingStateIdentifity"

let FRONT_CAMERA_SPECIFIER: String = "Front Camera"
let BACK_CAMERA_SPECIFIER: String = "Back Camera"

// Log 相关
let openWriteLog = true
typealias YLSDKLOG = YLSDKLogger

// alert 相关
let YLAlertViewTag = 10001  //提示框tag
let YLAlertResidentViewTag = 10002 //常驻提示框tag

// MARK: 字体
/** 默认字体  */
let kFontTextDefault: String = "Helvetica"
/** 默认加粗字体  */
let kFontTextDefaultBold: String = "Helvetica-Bold"
/** 默认细体字体  */
let kFontTextDefaultLight: String = "HelveticaNeue-Light"

// MARK: 字体大小
/** 字体大小 10号  */
let kFontSizeSmallest: CGFloat = 10
/** 字体大小 12号  */
let kFontSizeSmall: CGFloat = 12
/** 字体大小 14号  */
let kFontSizeMedium: CGFloat = 14
/** 字体大小 16号  */
let kFontSizeLarge: CGFloat = 16
/** 字体大小 18号  */
let kFontSizeLargest: CGFloat = 18

/** 切换动画时间 0.2秒  */
let kActionDuration: Double = 0.2
/// 推出动画时间
let kNavigationPushActionDuration = 0.2

// 设备相关
/** 屏幕宽度  */
var kScreenWidth: Float {
    get {
        return Float(UIScreen.main.bounds.size.width)
    }
}

/** 屏幕高度  */
var kScreenHight: Float {
    get {
        return Float(UIScreen.main.bounds.size.height)
    }
}
/** 是否IphoneX  */
var isIphoneX: Bool {
    get {
        if kScreenHight == 812 {
            return true
        }
        return false
    }
}
// host 主持人角色
let PRESENTER = "CUR_PRESENTER"
// attende 参会者角色
let ATTENDEE = "CUR_ATTENDEE"


