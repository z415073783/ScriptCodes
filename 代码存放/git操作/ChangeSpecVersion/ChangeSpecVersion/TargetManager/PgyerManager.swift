//
//  PgyerManager.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/8/1.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
class PgyerResultModel: Codable {
    var code = 0
    var message = ""
    var data: PgyerResultData?
}
class PgyerResultData: Codable {
    var appKey = ""
    var userKey = ""
    var appType = ""
    var appIsLastest = ""
    var appFileSize = ""
    var appName = ""
    var appVersion = ""
    var appVersionNo = ""
    var appBuildVersion = ""
    var appIdentifier = ""
    var appIcon = ""
    var appDescription = ""
    var appUpdateDescription = ""
    var appScreenshots = ""
    var appShortcutUrl = ""
    var appCreated = ""
    var appUpdated = ""
    var appQRCodeURL = ""
}



