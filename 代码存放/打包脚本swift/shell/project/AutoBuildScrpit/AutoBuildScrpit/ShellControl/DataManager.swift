//
//  DataManager.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
class DataManager {
    static let getInstance = DataManager()

    func getInfoData() ->NSMutableDictionary {
        guard let data = NSMutableDictionary(contentsOf: URL(fileURLWithPath: kInfoPath)) else {
            YLLOG.error("工程info路径错误")
            return NSMutableDictionary()
        }
        print("project plist data:\(String(describing: data)) kInfoPath = \(kInfoPath)")
        return data
    }
    func getBuildVersion() -> String? {
        let data = getInfoData()
        let buildVersion = data["CFBundleVersion"]
        print("---buildVersion:\(String(describing: buildVersion))---")
        return buildVersion as? String
    }

    //获取需要打包的app版本号
    func getNeedGitVersionBransh() -> String {
        if let app = imformationList["app"] as? String {
            return app
        }
        
        guard let vn = imformationList["VersionNumber"] as? String else {
            return kBranchName
        }
        if vn.count == 0 {
            return kBranchName
        }

        return vn
    }
    func writePackageVersion() {
        //        let needWriteData = NSMutableDictionary(contentsOf: imformationURL)
        guard let vn = imformationList["app"] as? String else {
            return
        }
        if vn.count == 0 {
            return
        }
        let data = getInfoData()
        data["CFBundleVersion"] = imformationList["app"]
        data.write(to: URL(fileURLWithPath: kInfoPath ), atomically: true)
    }
    //获取所有替换信息
    class func getAllReplaceData() -> [String: [String: String]]? {
        //        print("getInstance.imformationList = \(getInstance.imformationList)")
        return getInstance.imformationList["ReplaceData"] as? [String: [String: String]]
    }
    //写入特定版本号
    @discardableResult class func writeVersionNumber(key: String, value: String) -> Bool {
        guard var replaceData = getInstance.imformationList["ReplaceData"] as? [String: [String: String]] else {
            return false
        }
        if replaceData[key] == nil {
            return false
        }
        replaceData[key]!["VersionNumber"] = value
        getInstance.imformationList["ReplaceData"] = replaceData
        //        print("getInstance.imformationList = \(getInstance.imformationList)")

        return true
    }

    var packageName: String = ""
    //读取配置文件
    var packagePropertyPlist: NSMutableDictionary {
        let path = Bundle.main.path(forResource: "ProjectProperty", ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)!
        return dic["packages"] as! NSMutableDictionary
    }

    //读取初始imfor数据
    var _imformationList: NSMutableDictionary?
    var imformationList: NSMutableDictionary {
        if let _imformationList = _imformationList {
            return _imformationList
        }
        //获取本地文件
        _imformationList = NSMutableDictionary(contentsOfFile: kPropertyPlistPath)
        YLLOG.info("初始化property数据 imformationList = \(String(describing: _imformationList))")
//        if let path = Bundle.main.path(forResource: kPropertyPlistName, ofType: "plist") {
//            _imformationList = NSMutableDictionary(contentsOfFile: path)
//            YLLOG.info("初始化property数据 imformationList = \(String(describing: _imformationList))")
//        } else {
//            YLLOG.error("未获取到propertyPlist文件 kPropertyPlistName = \(kPropertyPlistName)")
//        }
        guard let _imformationList = _imformationList else {
            YLLOG.error("_imformationList为空")
            return [:]
        }
        return _imformationList
    }

//    class func initImformation() {
//        let path = Bundle.main.path(forResource: kPropertyPlistName, ofType: "plist")
//        getInstance.imformationList = NSMutableDictionary(contentsOfFile: path!)
//        print("getInstance.imformationList = \(getInstance.imformationList)")
//    }
    //获取ExportOptions路径
//    func getExportOptionPlistPath() -> String {
//        guard let path = Bundle.main.path(forResource:
//            kExportOptionsPlistName, ofType: "plist") else {
//                print("ExportOptions文件获取失败")
//                return ""
//        }
//        print("ExportOptions路径: \(path)")
//        return path
//    }


    //写入imfor数据
    class func writeImformation(key: String, value: String) {
        if key.hasPrefix("app") {
            getInstance.imformationList["app"] = value
            return
        }
        if getInstance.imformationList[key] == nil {
            return
        }

        getInstance.imformationList[key] = value
        //        print("getInstance.imformationList =\(getInstance.imformationList)")
    }
    //保存imfor数据
    class func saveImformation(path: String) {
        getInstance.imformationList.write(to: URL(fileURLWithPath: path), atomically: true)
    }


}






