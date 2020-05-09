//
//  ScriptControl.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
class ScriptControl {
    class func ExecuteShell() {

        YLLOG.info("检查路径: kShellPath脚本所在路径 = \(kShellPath)")
        YLLOG.info("检查路径: kProjectPath工程根目录路径 = \(kProjectPath)")

        DataManager.getInstance.imformationList.setValue(kVersionNumber, forKey: "app")
        // 更新pod
        if PodManager.checkPodsIsExist() {
            PodManager.removeAllHistoryFiles()
        }
        YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["install"], scriptRunPath: kProjectPath))
//        YLScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["update"], scriptRunPath: kProjectPath))
        //#路径
        var date = showNormalDate(timeInterval: Date().timeIntervalSince1970)

        let numberList: [String] = kVersionNumber.split(".")
        var newVersionNumber = ""
        for item in numberList {
            if newVersionNumber.count == 0 {
                newVersionNumber = item
            }else {
                newVersionNumber = newVersionNumber + "_" + item
            }
        }
        date = newVersionNumber + "(" + date + ")"

        let ipaPath = kIPAPath + "/autoBuildIPA/" + date

        let ipaName = kProjectName + ".ipa"
        let xcarchive = ipaPath + "/" + kProjectName + ".xcarchive"
        YLLOG.info("xcarchive生成路径 = \(xcarchive)")
        YLScript.runScript(path: kCodebuildPath, arguments: ["-workspace", kXcworkspacePath,
                                                                "-scheme", kProjectName,
                                                                "-configuration", kBuildConfigType,
                                                                "clean",
                                                                "-archivePath", xcarchive,
                                                                "archive",
                                                                "-quiet",
                                                                "-jobs", "8"])


        //打包api
        if kCertificate.count > 0 {
            //            ipaPath + "/" + kProjectName + ".xcarchive/info.plist",
            YLScript.runScript(path: kCodebuildPath, arguments: ["-exportArchive", "-exportOptionsPlist", kExportOptionsPlistPath, "-archivePath", ipaPath + "/" + kProjectName + ".xcarchive", "-exportPath", ipaPath + "/", "CODE_SIGN_IDENTITY", kCertificate, "-allowProvisioningUpdates"])
        }else {
            //            ipaPath + "/" + kProjectName + ".xcarchive/info.plist",
            YLScript.runScript(path: kCodebuildPath, arguments: ["-exportArchive", "-exportOptionsPlist", kExportOptionsPlistPath, "-archivePath", ipaPath + "/" + kProjectName + ".xcarchive", "-exportPath", ipaPath + "/", "-allowProvisioningUpdates"])
        }

        DataManager.saveImformation(path: ipaPath + "/PropertyList.plist")
        
        if kFirNeedUpdate {
            print("login fir account")

            YLScript.runScript(path: kFirPath, arguments: ["login", kFirToken])
            print("begin uploading .ipa file to fir.im")
            YLScript.runScript(path: kFirPath, arguments: ["p", ipaPath + "/" + ipaName])
            YLScript.runScript(path: kCurlPath, arguments: ["-X", "PUT", "--data", "changelog=", "http://fir.im/api/v2/app/" + kBundleID + "?token=" + kFirToken])
        }

        if kPgyerNeedUpdate {
            print("begin uploading to pgyer")
            YLScript.runScript(path: kCurlPath, arguments: ["-F", "file=@" + ipaPath + "/" + ipaName, "-F", "uKey=" + kPgyerUserKey, "-F", "_api_key=" + kPgyerAPIKey, "https://qiniu-storage.pgyer.com/apiv1/app/upload"])
        }

    }
}

