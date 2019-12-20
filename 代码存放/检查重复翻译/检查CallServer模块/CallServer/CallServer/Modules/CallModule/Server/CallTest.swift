//
//  CallTest.swift
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

public class CallTest: NSObject {
   @objc static let getSharedInstance: CallTest =  CallTest.init()

   @objc public func createService() {
       let csm = CallStateMachine.init()
        csm.canFireEvent("1213")
        let mns = CallServer.init()
    }
}
