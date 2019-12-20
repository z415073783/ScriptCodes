//
//  CallServerDeviceSource.swift
//  Odin-YMS
//
//  Created by Apple on 09/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

typealias clickfinishFunc = () -> Void

@objc class CallServerDeviceSource: NSObject {

   @objc static let getInstance: CallServerDeviceSource = CallServerDeviceSource()
    /** 摄像头强后判断 */
    var cameraSpecifier: String = FRONT_CAMERA_SPECIFIER

    /** 切换前镜头*/
    func setFontCamera () {
        YLSDKDispatchManager.videoEngineQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            self?.cameraSpecifier =  FRONT_CAMERA_SPECIFIER
            YLLogicAPI.switchCamear(self?.cameraSpecifier)
        }

    }
    func setbackCamera() {
        YLSDKDispatchManager.videoEngineQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            self?.cameraSpecifier =  BACK_CAMERA_SPECIFIER
            YLLogicAPI.switchCamear(self?.cameraSpecifier)
        }

    }

    /** 切换摄像头 */
   @objc open func switchCamear(block: clickfinishFunc?) {
    YLSDKLogger.debug("switchCamear camear name" + cameraSpecifier)

    YLSDKDispatchManager.videoEngineQueue.addOperation {[weak self] in
            if self == nil {
                return
            }
            if self?.cameraSpecifier == FRONT_CAMERA_SPECIFIER {
                self?.cameraSpecifier = BACK_CAMERA_SPECIFIER
                YLLogicAPI.switchCamear(self?.cameraSpecifier)
            } else if self?.cameraSpecifier == BACK_CAMERA_SPECIFIER {
                self?.cameraSpecifier = FRONT_CAMERA_SPECIFIER
                YLLogicAPI.switchCamear(self?.cameraSpecifier)
            }
            if let thisBlock = block {
                thisBlock()
            }
        }
    }

    func addCamearRoteListener() {
        removeCamearRoteListener()
        NotificationCenter.default.addObserver(self, selector: #selector(captureOrientationDidChange(note:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }

    @objc func captureOrientationDidChange(note: NSNotification) {
        self.perform(#selector(self.delayUpdateCaptureOrientation), with: nil, afterDelay: 0.35)
    }
    func removeCamearRoteListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }

    /** 通话 设置摄像头 和视频layout */
    @objc func delayUpdateCaptureOrientation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayUpdateCaptureOrientation), object: nil)
        DispatchQueue.main.syncYL {
            UIApplication.shared.setStatusBarHidden(false, with: .none)
        }
        DispatchQueue.main.async {[weak self] in
            if self == nil {
                return
            }
            if (UIApplication.shared.statusBarOrientation == .portrait) {
                if self?.cameraSpecifier == FRONT_CAMERA_SPECIFIER {
                    YLLogicAPI.updateCaptureOrientation(270)
                } else {
                    YLLogicAPI.updateCaptureOrientation(90)
                }
            } else if (UIApplication.shared.statusBarOrientation == .portraitUpsideDown) {
                if self?.cameraSpecifier == FRONT_CAMERA_SPECIFIER {
                    YLLogicAPI.updateCaptureOrientation(90)
                } else {
                    YLLogicAPI.updateCaptureOrientation(270)
                }
            } else if (UIApplication.shared.statusBarOrientation == .landscapeLeft) {
                YLLogicAPI.updateCaptureOrientation(180)
            } else if (UIApplication.shared.statusBarOrientation == .landscapeRight) {
                YLLogicAPI.updateCaptureOrientation(0)
            }
        }
    }
    
    func iphoneDisableRoate(){
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
            RotationManager.getInstance.setOrientationType(sender: .portrait)
            RotationManager.getInstance.enableRotation = false
            RotationManager.getInstance.openRotation = true
            CallServerDeviceSource.getInstance.removeCamearRoteListener()
        }
    }
    
    func dissMisspresentView(){
        let vcs = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        if vcs != nil {
            vcs?.dismiss(animated: false, completion: {
            })
        }
    }
}
