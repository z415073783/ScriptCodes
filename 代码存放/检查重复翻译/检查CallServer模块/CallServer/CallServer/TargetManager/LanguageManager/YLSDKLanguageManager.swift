//
//  LanguageManager.swift
//  Odin-UC
//
//  Created by zlm on 2016/11/24.
//  Copyright © 2016年 yealing. All rights reserved.
//

import UIKit
import YLBaseFramework

/** Bundle Language */
public let kLanguageBundle: Bundle  = {
    let path = Bundle.main.path(forResource: "YLSDKLanguage", ofType: "bundle")
    let bundle = Bundle.init(path: path!)
    if let returnBundle = bundle {
        return returnBundle
    }
    return Bundle.init()
}()

//public let kLanguagePath: String  = {
//    let bundlePath: String = (kLanguageBundle.path(forResource:  kCurrentLanguage as! String?, ofType: "lproj"))!
//    return bundlePath
//}()


/// 转换语言
///
/// - Parameter key: 默认语言
/// - Returns: 当前语言
func localizedSDK(key: String!, _ selectLanguage: LanguageType? = nil) -> String {
    return localized(key: key, selectLanguage)
}

@objc class YLSDKLanguageManager: NSObject {
    @objc class func getSystemLanguage() {
        LanguageManager.initLanguageData(path: kLanguageBundle.path(forResource: "YLSDKLanguage", ofType: "plist"))
    }
}
