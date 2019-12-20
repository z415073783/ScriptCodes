//
//  RegisterManager.swift
//  CallServer
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import AVFoundation

@objc class RegisterManager: NSObject {
    @objc static let getInstance: RegisterManager = RegisterManager.init()

    @objc open func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRegisterChange), name: kAccountStateChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloudRegisterChange), name: keyCloudAccountChangeNotification, object: nil)
    }
    
    @objc open func removeListener() {
        NotificationCenter.default.removeObserver(self, name: kAccountStateChangeNotification, object: nil)
    }
    
    @objc func handleRegisterChange(note:NSNotification) {
        let flag =  CallServer.sipRegisterState()
        if let state = note.userInfo?[keyAccountState] as? Int {
            YLSDKLogger.log("log state:" + String(state) + "isregister Sip:" + String(flag))

        }
        CallServerInterface.sharedManager().registerChange()
    }
    
    @objc open func handleCloudRegisterChange() {
        CallServerInterface.sharedManager().registerChange()
    }
}
