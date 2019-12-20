//
//  PgyerManager.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/8/1.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public class PgyerResultModel: Codable {
    public var code = 0
    public var message = ""
    public var data: PgyerResultData?
}
public class PgyerResultData: Codable {
    public var appKey = ""
    public var userKey = ""
    public var appType = ""
    public var appIsLastest = ""
    public var appFileSize = ""
    public var appName = ""
    public var appVersion = ""
    public var appVersionNo = ""
    public var appBuildVersion = ""
    public var appIdentifier = ""
    public var appIcon = ""
    public var appDescription = ""
    public var appUpdateDescription = ""
    public var appScreenshots = ""
    public var appShortcutUrl = ""
    public var appCreated = ""
    public var appUpdated = ""
    public var appQRCodeURL = ""
}



