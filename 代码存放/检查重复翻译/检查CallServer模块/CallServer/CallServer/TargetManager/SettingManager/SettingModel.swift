//
//  SettingModel.swift
//  CallServer
//
//  Created by zlm on 2017/10/18.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
enum SettingType: String {
    case sip = "sip", h323 = "h323"
}

class SettingNameModel: NSObject {
    var value: String = ""
    var name: String = ""
    var type: SettingType = .sip
    //保存数据
    func setValue(_ sender: String) {
        value = sender
        let path = Bundle.main.path(forResource: "InAppSettings", ofType: "bundle")
        let bundle = Bundle.init(path: path!)

        let bundlePath: String = (bundle!.path(forResource: "AccountConfig", ofType: "plist"))!
        guard let dic = NSDictionary(contentsOfFile: bundlePath) else {
            return
        }
        guard let sipData = dic[type.rawValue] as? NSDictionary else {
            return
        }
        guard let nameData = sipData[name] as? NSDictionary else {
            return
        }
        guard let arr = nameData["writeFileList"] as? NSArray else {
            return
        }
        for item in arr {
            guard let item = item as? NSDictionary else {
                continue
            }
            guard let file = item["file"] as? String else {
                continue
            }
            guard let section = item["section"]as? String else {
                continue
            }
            guard let key = item["key"]as? String else {
                continue
            }
            let _ = SettingManager.writeFile(file: file, section: section, key: key, value: value)
        }
    }
    convenience init(value: String, name: String, type: SettingType = .sip) {
        self.init()
        self.value = value
        self.name = name
        self.type = type
    }
}

class SettingSipModel: NSObject {
    var accountSwitch: SettingNameModel = SettingNameModel(value: "1", name: "SIPAccount")
    var userName: SettingNameModel = SettingNameModel(value: "", name: "UserName")
    var registerName: SettingNameModel = SettingNameModel(value: "", name: "RegisterName")
    var password: SettingNameModel = SettingNameModel(value: "", name: "Password")
    var serverAddress: SettingNameModel = SettingNameModel(value: "", name: "Server")
    var port: SettingNameModel = SettingNameModel(value: "", name: "Port")
    var transferProtocol: SettingNameModel = SettingNameModel(value: "", name: "TransferProtocol")
    var bfcp: SettingNameModel = SettingNameModel(value: "", name: "BFCP")
    var proxyServerEnabled: SettingNameModel = SettingNameModel(value: "", name: "ProxyServerEnabled")
    var proxyPort: SettingNameModel = SettingNameModel(value: "", name: "ProxyPort")
    var proxyServer: SettingNameModel = SettingNameModel(value: "", name: "ProxyServer")
    var natType: SettingNameModel = SettingNameModel(value: "", name: "ProxyServer")
    var srtp: SettingNameModel = SettingNameModel(value: "", name: "SRTP")
    var dtmfType: SettingNameModel = SettingNameModel(value: "", name: "DTMFType")
    var dtmfInfoType: SettingNameModel = SettingNameModel(value: "", name: "DTMFInfoType")
    var dtmfPayloadType: SettingNameModel = SettingNameModel(value: "", name: "DTMFPayloadType")

}

class SettingH323Model: NSObject {
    var accountSwitch: SettingNameModel = SettingNameModel(value: "1", name: "H.323", type: .h323)
    var userName: SettingNameModel = SettingNameModel(value: "", name: "UserName", type: .h323)
    var extensionNumber: SettingNameModel = SettingNameModel(value: "", name: "ExtensionNumber", type: .h323)
    var gkServer: SettingNameModel = SettingNameModel(value: "", name: "GKServer", type: .h323)
    var gkAuthentication: SettingNameModel = SettingNameModel(value: "", name: "GKAuthentication", type: .h323)
    var gkUserName: SettingNameModel = SettingNameModel(value: "", name: "GKUserName", type: .h323)
    var gkPassword: SettingNameModel = SettingNameModel(value: "", name: "GKPassword", type: .h323)
    var h235Encryption: SettingNameModel = SettingNameModel(value: "", name: "H.235Encryption", type: .h323)
    var h460Switch: SettingNameModel = SettingNameModel(value: "", name: "H.460Switch", type: .h323)
}
