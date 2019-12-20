//
//  WholeDefine.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation

func getImformationStringValue(key: String) -> String {
    let value = getImformationValue(key: key)
    guard let newValue = value as? String else {
        YLLOG.error("Any transform String error: key = \(key),value = \(value)")
        return ""
    }

    return newValue
}
func getImformationValue(key: String) -> Any {
    let path: Any? = DataManager.getInstance.imformationList[key]
    YLLOG.info("key = \(key),value = \(String(describing: path))")

    guard path != nil else {
        YLLOG.error("数据获取错误: key = \(key),value = \(String(describing: path))")
        return ""
    }
    return path ?? ""
}




//plist文件路径
let kPropertyPlistName = "plist/PropertyList"
let kExportOptionsPlistName = "plist/PropertyList"
//初始路径 需要根据脚本位置改为相对路径
let kShellPath = Bundle.main.bundlePath
let kPropertyPlistPath = kShellPath + "/" + kPropertyPlistName + ".plist"
let kExportOptionsPlistPath = kShellPath + "/" + kExportOptionsPlistName + ".plist"

//工程路径
var kProjectPath: String {
    return kShellPath + "/" + getImformationStringValue(key: "Project Path")
}

//工程info路径
var kInfoPath: String {
    return kProjectPath + "/" + getImformationStringValue(key: "Project Info List")
}

//工程名
var kProjectName: String {
    return getImformationStringValue(key: "ProjectName")
}
//需要跟踪的分支名
var kBranchName: String {
    return getImformationStringValue(key: "Branch Name")
}
// 获取workspace工程路径
var kXcworkspacePath: String {
    return kProjectPath + "/" + getImformationStringValue(key: "Project Workspace Path")
}
// 是否debug
var kIsDebug: Bool {
    get {
        let isTest = getImformationStringValue(key: "isDebug")
        if isTest == "true" {
            return true
        }else {
            return false
        }
    }
}
//打包版本 Debug,Release
var kBuildConfigType: String {
    get {
        if kIsDebug {
            return "Debug"
        } else {
            return "Release"
        }
    }
}
// 需要显示的版本号 //拉取工程版本
var kVersionNumber: String {
    let version = kInfoData.value(forKey: "CFBundleVersion")
    return version as? String ?? ""
//    return getImformationStringValue(key: "VersionNumber")
}

var kIPAPath: String {
    return kProjectPath + "/" + getImformationStringValue(key: "IPAPath")
}

var kCertificate: String {
    return getImformationStringValue(key: "Certificate")
}

var kUploadUrlTypeDic: NSDictionary {
    guard let dic = getImformationValue(key: "Upload URL Type") as? NSDictionary else {
        YLLOG.error("Upload URL Type数据获取失败")
        return NSDictionary()
    }
    return dic
}
var kFirNeedUpdate: Bool {
    let needUpdate = kUploadUrlTypeDic.value(forKey: "fir") as? Bool
    return needUpdate ?? false
}
var kPgyerNeedUpdate: Bool {
    let needUpdate = kUploadUrlTypeDic.value(forKey: "pgyer") as? Bool
    return needUpdate ?? false
}
//fir token
var kFirToken: String {
    return getImformationStringValue(key: "Fir Token")
}
//pgyer user key
var kPgyerUserKey: String {
    return getImformationStringValue(key: "Pgyer User key")
}
//pgyer api key
var kPgyerAPIKey: String {
    return getImformationStringValue(key: "Pgyer API Key")
}
var kBundleID: String {
    return getImformationStringValue(key: "Bundle ID")
}

var kInfoData: NSDictionary {
    return NSDictionary(contentsOfFile: kInfoPath) ?? NSDictionary()
}

//根据包名获取exportOptions文件名
//func getExportOptionsPlistByPackage() -> String {
//    return "plist/PropertyList"
//    //        guard let plist = packagePropertyPlist[packageName] as? NSMutableDictionary, let exportOptionsPlistName = plist["exportOptions"] as? String else {
//    //            return ""
//    //        }
//    //        return exportOptionsPlistName
//}
