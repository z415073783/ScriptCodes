//
//  CallInvitePersonDataModel.swift
//  Odin-YMS
//
//  Created by Apple on 01/07/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallInvitePersonDataModel: NSObject {

    var name: String = ""
    var _number: String = ""
    var inviteState: Int = 0  //0 inviteIng, 1 succeed, -1 failed

    var number: String {
        set {
            _number = newValue
            name = YLContactAPI.searchCloudName(byNumber: _number)
        }
        get {
            return _number
        }
    }

}
