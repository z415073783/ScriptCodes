//
//  RotationManager.swift
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

@objc class RotationManager: NSObject {
   @objc static let getInstance: RotationManager = RotationManager()

    // MARK: - --旋转控制---
    //是否开启旋转控制
    var openRotation: Bool = true
    //是否允许旋转
    private var _enableRotation: Bool = false
   @objc var enableRotation: Bool {
        get {
            if openRotation == false {
                return false
            }
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                return true
            } else {
                return _enableRotation
            }
        }
        set {
            _enableRotation = newValue
        }
    }
    //当前方向类型
   @objc var currentOrientationType: UIInterfaceOrientationMask = .portrait
    //设置当前方向类型
   @objc func setOrientationType(sender: UIInterfaceOrientation) {
        switch sender {
        case .portrait:
            currentOrientationType = .portrait
        case .landscapeRight, .landscapeLeft:
            currentOrientationType = [.landscapeRight, .landscapeLeft]
        case .portraitUpsideDown:
            currentOrientationType = .allButUpsideDown
        default:
            currentOrientationType = .all
        }
        UIDevice.current.setValue(sender.rawValue, forKey: "orientation")
    }

}
