//
//  AudioRouteManager.swift
//  Odin-UC
//
//  Created by Apple on 01/03/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

import UIKit
import AVFoundation
@objc class AudioRouteManager: NSObject {
    
    @objc static let getInstance: AudioRouteManager = AudioRouteManager.init()
    
    var _audioOutputMode: String = ""
    var audioOutputMode: String {
        set {
            if audioOutputMode != newValue {
                _preOutMode = _audioOutputMode
                _audioOutputMode = newValue
                NotificationCenter.default.post(name: kAudioOutputModeChangedNotification, object: self, userInfo: ["audioOutputMode": _audioOutputMode])
            }
        }
        
        get {
            return _audioOutputMode
        }
    }
    var audioOutputs: NSArray = []
    var audioInputs: NSArray = []
    var audioRouteHasOverrided: Bool = false
    
    var _preOutMode: String = ""
    var _setupListener: Bool = false
    var _serviceInitFinish: Bool = false
    
    var  _ailableInputsCount: Int = 0
    var _inputDevUID: String = ""
    
    override init() {
        super.init()
        _serviceInitFinish = YLLogicAPI.isInitSucess()
    }
    @objc open func addListener() {
        _serviceInitFinish = YLLogicAPI.isInitSucess()
        
        if _serviceInitFinish == false {
            NotificationCenter.default.addObserver(self, selector: #selector(handleServiceInitFinish(note:)), name: NSNotification.Name(rawValue: keyServiceInitFinish), object: nil)
        }
        
        if !_setupListener {
            _setupListener = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleAudioRouteChange(note:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
            
        }
    }
    
    @objc open func removeListener() {
        _setupListener = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    @objc func handleServiceInitFinish(note: NSNotification) {
        let success =  note.userInfo?[keyInitResult] as? Bool
        if success == true {
            _serviceInitFinish = true
        }
    }
    
    @objc func handleAudioRouteChange(note: NSNotification) {
        if note.name == .AVAudioSessionRouteChange {
            let info =  note.userInfo
            let reason: Int? = info?[AVAudioSessionRouteChangeReasonKey] as? Int
            let routeDes: AVAudioSessionRouteDescription? = info?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
            
            if reason == nil && routeDes == nil && routeDes?.inputs == nil && routeDes?.outputs == nil && routeDes?.inputs.count == 0 && routeDes?.outputs.count == 0 {
                return
            }
            
            let session = AVAudioSession.sharedInstance()
            let currentRote =  session.currentRoute
            
            let availableInputs = session.availableInputs
            
            if _ailableInputsCount == 0 {
                if availableInputs != nil {
                    var inputCount: Int? = availableInputs?.count
                    if inputCount == nil {
                        inputCount = 0
                    }
                    if let thisInputCount = inputCount {
                        _ailableInputsCount = thisInputCount
                    }
                }
            }
            
            let intputs =  routeDes?.inputs
            let inputPort = intputs?.last
            
            let outputs = routeDes?.outputs
            let outPort = outputs?.last
            
            let currentInputs = currentRote.inputs
            let currentInputPort = currentInputs.last
            
            let currentOutputs = currentRote.outputs
            let currentOutPort = currentOutputs.last
            
            if  currentInputPort == nil && currentOutPort == nil {
                return
            }
            
            if (_inputDevUID == "") {
                if currentInputPort?.uid != nil {
                    if let thisUid = (currentInputPort?.uid)  {
                        _inputDevUID = thisUid
                    }
                }
            }
            
            audioOutputs = currentOutputs as NSArray
            audioInputs =  currentInputs as NSArray
            
            if (audioOutputMode == "") {
                if (reason == kAudioSessionRouteChangeReason_RouteConfigurationChange || reason == kAudioSessionRouteChangeReason_CategoryChange) {
                    audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray )
                    return
                }
            }
            
            if (reason == kAudioSessionRouteChangeReason_Override) {
                audioRouteHasOverrided = true
                //耳麦模式下要将扬声器模式切换为耳麦模式
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
            } else if (audioRouteHasOverrided && reason == kAudioSessionRouteChangeReason_CategoryChange) {
                audioRouteHasOverrided = false
                //                audioRouteHasOverrided = true
                //耳麦模式下要将耳麦模式切回扬声器模式
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
                
                //检查是否发生外设变动
                if let thisCurrentProt = currentOutPort {
                    if let thisOutProt = outPort {
                        if isOutputRouteModifiedDueToHeadset(currentOutput: thisCurrentProt, oldOutput:thisOutProt) == true {
                            let noteText = YLSDKLanguage.YLSDKYouHaveSwitchedToHeadset
                            noticeAlertView(noteText)
                        }
                        return
                    }
                    return
                }
                return
            } else {
                audioRouteHasOverrided = false
            }
            
            if (reason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
                let noteText = YLSDKLanguage.YLSDKYouHaveSwitchedToHeadset
                noticeAlertView(noteText)
                //YLNotificationManager.notification(withMessage: noteText)
                return
            } else if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
//                let noteText = YLSDKLanguage.YLSDKDeviceIsUnplugged
                YLCallServerManager.getInstance.checkIfVideoAndNeedSpeakOut()  //如果视频需要调整声道
                //noticeAlertView(noteText)
                //                YLNotificationManager.notification(withMessage: noteText)
                return
            }
            
            /**因为添加移除设备时,AudioSessionRouteChangeReason不一定是NewDeviceAvailable或者OldDeviceUnavailable
             因此下面设置两个检查点。1、先检查InputPort判断是否有麦克风之类的带有输入功能的设备接入或者移除。2、如果接入或者移除
             设备不带有麦克风功能则检查OutPort**/
            
            if (_serviceInitFinish && inputPort?.uid != currentInputPort?.uid) {
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
                if(currentInputPort?.uid != "Built-In Microphone") {
                    let noteText = YLSDKLanguage.YLSDKYouHaveSwitchedToHeadset
                    noticeAlertView(noteText)
                    // YLNotificationManager.notification(withMessage: noteText)
                } else {
                    if(audioRouteHasOverrided == false) {
                        if availableInputs != nil && (availableInputs?.count) != nil {
                            if let thisCount =  (availableInputs?.count){
                                _ailableInputsCount = thisCount
                            }
                        }
//                        let noteText = YLSDKLanguage.YLSDKDeviceIsUnplugged
                        //noticeAlertView(noteText)
                        //YLNotificationManager.notification(withMessage: noteText)
                    }
                }
                if currentInputPort?.uid != nil {
                    if let thisUid = (currentInputPort?.uid) {
                        _inputDevUID = thisUid
                    }
                }
                return
            }
            
            //排除程序初始化的情况,outPort和currentOutPort UID不能为 Built-In Receiver
            if (_serviceInitFinish && outPort?.uid != currentOutPort?.uid) {
                audioOutputMode = getOutputMode(outputs: currentOutputs as NSArray)
                if((currentOutPort?.uid != "Speaker") && (currentOutPort?.uid != "Built-In Receiver")) {
                    let noteText = YLSDKLanguage.YLSDKYouHaveSwitchedToHeadset
                    noticeAlertView(noteText)
                    //YLNotificationManager.notification(withMessage: noteText)
                } else {
                    if((outPort?.uid != "Speaker") && (outPort?.uid != "Built-In Receiver")) {
                        
//                        let noteText = YLSDKLanguage.YLSDKDeviceIsUnplugged
                        //                        noticeAlertView(noteText)
                        //YLNotificationManager.notification(withMessage: noteText)
                    }
                }
                return
            }
        }
    }
    
    func getOutputMode(outputs: NSArray) -> String {
        if (outputs.count > 0) {
            let port: AVAudioSessionPortDescription? = outputs.lastObject as? AVAudioSessionPortDescription
            if let thisPort = port {
                if (thisPort.uid == "Speaker") {
                    return  "Speaker"
                } else if (thisPort.uid == "Built-In Receiver") {
                    return "Built-In Receiver"
                } else if (thisPort.uid.contains("Headphone")) {
                    return "Headphone"
                } else if (thisPort.portType.contains("Bluetooth")) {
                    return "Headphone"
                }
            }
        }
        return ""
    }
    
    open func hasHeadsetPlugged() -> Bool {
        if hasMultipleInputs() {
            return true
        }
        
        if audioOutputs.count > 1 {
            return true
        }
        if audioOutputs.count == 0 {
            let route = AVAudioSession.sharedInstance().currentRoute
            audioOutputs = route.outputs as NSArray
        }
        
        if let p = audioOutputs.lastObject as? AVAudioSessionPortDescription {
            let isBuildInOutputDevice = (p.uid == "Built-In Receiver" || p.uid == "Speaker")
            return !isBuildInOutputDevice
        } else {
            return false
        }
    }
    open func hasMultipleInputs() -> Bool {
        if let thisCount = (AVAudioSession.sharedInstance().availableInputs?.count) {
            return thisCount > 1
        }
        return false
    }
    open func isSpeakerOutputMode() -> Bool {
        return audioOutputMode == "Speaker"
    }
    /**耳机 头戴设备*/
    
    open func setAudioMode2HandFree() {
        YLLogicAPI.setAudioMode(3)
    }
    /**听筒*/
    
    open func setAudioMode2Handset() {
        YLLogicAPI.setAudioMode(2)
        
    }
    /**免提*/
    
    open func setAudioModeOverride2Speaker() {
        YLLogicAPI.setAudioMode(1)
    }
    /**
     * 底层音频模式
     **/
    open func setAudioModeOverride2None() {
        YLLogicAPI.setAudioMode(0)
    }
    
    func isOutputRouteModifiedDueToHeadset(currentOutput: AVAudioSessionPortDescription, oldOutput: AVAudioSessionPortDescription) -> Bool {
        
        if (oldOutput.uid == "Built-In Receiver" || oldOutput.uid == "Speaker") && (currentOutput.uid == "Built-In Receiver" || currentOutput.uid == "Speaker") {
            return false
        }
        return true
        
    }
    
    func noticeAlertView(_ title: String) {
        DispatchQueue.main.asyncYL {
            _ = YLSDKAlertNoButtonView.show(title, position: .top, block: { (_) in
            })
        }
    }
    
    func isHeadsetPluggedIn() -> Bool {
        let route = AVAudioSession.sharedInstance().currentRoute
        for desc in route.outputs {
            if desc.portType == AVAudioSessionPortHeadphones {
                return true
            } else if desc.portType == "BluetoothHFP" {
                return true
            }
        }
        return false
    }
}
