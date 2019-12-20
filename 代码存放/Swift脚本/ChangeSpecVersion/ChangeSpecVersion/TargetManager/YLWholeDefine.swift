//
//  YLWholeDefine.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public let kGitShellPath = "/usr/bin/git"
public let kCocoapodsShellPath = "/usr/local/bin/pod"
public let kCodebuildPath = "/usr/bin/xcodebuild"
public let kCDPath = "/usr/bin/cd"
public let kFirPath = "/usr/local/bin/fir"
public let kCurlPath = "/usr/bin/curl"
public let kMkdirPath = "/bin/mkdir"
public let kMountPath = "/sbin/mount_smbfs"
public let kBashPath = "/bin/sh"
public let kScriptPath = "usr/bin/osascript"
public let kLsPath = "/bin/ls"


//初始路径 需要根据脚本位置改为相对路径 "/Users/zlm/Documents/Odin-iOS-UC0524/shell"
//let kShellPath = "/Users/zlm/Documents/VCM3.0 v26/Odin-YMS/YLRouter/YLRouter"
let kShellPath = Bundle.main.bundlePath
