//
//  SettingManager.swift
//  CallServer
//
//  Created by zlm on 2017/10/18.
//  Copyright © 2017年 yealink. All rights reserved.
//


@objc class SettingManager: NSObject {
    class func writeFile(file: String?, section: String?, key: String?, value: String?) -> Bool {
        if let thisfile = file  {
            return YLLogicAPI.setStringConfig(thisfile + ".ini", strSection: section, strKey: key, strDefault: value)
        }
        return false
    }
    class func readData(file: String, section: String, key: String) -> String {
        if file.characters.count == 0 {
            return ""
        }
        if let  result = YLLogicAPI.getStringConfig(file + ".ini", strSection: section, strKey: key, strDefault: "") as? String {
            return result
        }
        return ""
    }
    class func readDataInt(file: String, section: String, key: String) -> Int {
        if file.characters.count == 0 {
            return 0
        }
        let result: Int =
            Int(YLLogicAPI.getIntConfig(file + ".ini", strSection: section, strKey: key, nDefault: 0))
        return result
    }

    @objc class func unregisterSip() {
        let sipModel = SettingSipModel()
        sipModel.accountSwitch.setValue("0")
    }

    
    @objc class func writeSIPData(sender: regAccountProfile) {
        let sipModel = SettingSipModel()
        sipModel.accountSwitch.setValue(sender.m_bEnable == true ? "1" : "0")
        sipModel.userName.setValue(String(sender.m_strUserName))
        sipModel.registerName.setValue(String(sender.m_strRegisterName))
        sipModel.password.setValue(String(sender.m_strPassword))
        sipModel.serverAddress.setValue(String(sender.m_strServer))
        sipModel.port.setValue(String(sender.m_iPort))
        sipModel.transferProtocol.setValue(String(sender.m_iTransfer))
        sipModel.bfcp.setValue(sender.m_bBFCP == true ? "1" : "0")
        sipModel.proxyServerEnabled.setValue(sender.m_bEnableOutbound == true ? "1" : "0")
        sipModel.proxyPort.setValue(String(sender.m_iOutboundPort))
        sipModel.proxyServer.setValue(String(sender.m_strOutboundServer))
        sipModel.natType.setValue(String(sender.m_iNATType))
        sipModel.srtp.setValue(String(sender.m_iSRTP))
        sipModel.dtmfType.setValue(String(sender.m_iDTMFType))
        sipModel.dtmfInfoType.setValue(String(sender.m_iDTMFInfoType))
        sipModel.dtmfPayloadType.setValue(String(sender.m_iDTMFPayload))
    }

    @objc class func writeH323Data(sender: regAccountProfile) {
        let h323Model = SettingH323Model()
        h323Model.accountSwitch.setValue(String(""))
        h323Model.userName.setValue(String(""))
        h323Model.extensionNumber.setValue(String(""))
        h323Model.gkServer.setValue(String(""))
        h323Model.gkAuthentication.setValue(String(""))
        h323Model.gkUserName.setValue(String(""))
        h323Model.gkPassword.setValue(String(""))
        h323Model.h235Encryption.setValue(String(""))
        h323Model.h460Switch.setValue(String(""))
    }


}
