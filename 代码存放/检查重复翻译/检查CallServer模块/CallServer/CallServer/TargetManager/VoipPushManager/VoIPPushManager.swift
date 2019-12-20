//
//  VoIPPushManager.swift
//  Odin-YMS
//
//  Created by soft7 on 2017/7/11.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import Foundation
import PushKit
import YLBaseFramework
import UserNotifications

@objc class VoIPPushManager: NSObject {

    @objc static let `default` = VoIPPushManager()

    var callingID: String?
    var callingNotification: UILocalNotification?
    var callingNotificationIdentifier: String?

    var token: String? {
        didSet {
            tryUploadToken()
        }
    }

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(sender:)),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
    }
}

private typealias __Publics = VoIPPushManager
extension __Publics {
   @objc func registerVoIPNotification() {
        let registry = PKPushRegistry(queue: .main)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]

        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                              categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }

    /// 是否显示过本地通知（收到来电推送时处于后台）
    func isPushedLocalNotification () -> Bool {
        let result = callingNotification != nil || callingNotificationIdentifier != nil
        YLSDKLOG.debug("VoIPPushManager isPushedLocalNotification \(result)")
        return result
    }

    func notifyCallTake() {
        ExecuteOnMainThread { [weak self] in
            guard UIApplication.shared.applicationState != .background else { return }
            YLSDKLOG.debug("VoIPPushManager notifyCallTake")
            self?.callingNotificationIdentifier = nil
            self?.callingNotification = nil
        }
        
    }

    func notifyCallFinish() {
        ExecuteOnMainThread {[weak self] in
            guard UIApplication.shared.applicationState != .background else { return }
            YLSDKLOG.debug("VoIPPushManager notifyCallFinish")
            self?.callingID = nil
            self?.callingNotificationIdentifier = nil
            self?.callingNotification = nil
        }
    }
}

private typealias __Privates = VoIPPushManager
extension __Privates {

    fileprivate func tryUploadToken() {
        YLSDKDispatchManager.interfaceOperatorQueue.addOperation {[weak self] in
            guard let `self` = self else { return }
            guard let token = self.token else { return }

            YLLogicAPI.setDeviceToken(token)
        }
    }
}

private typealias __Actions = VoIPPushManager
extension __Actions {
    @objc func applicationWillEnterForeground(sender: Notification) {
    }
}

private typealias __PKPushRegistryDelegate = VoIPPushManager
extension __PKPushRegistryDelegate: PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let tokenData = NSData(data: credentials.token)
        var token: String = String(tokenData.description)
        token = token.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        YLSDKLOG.debug("VoIPPushManager get PKPushType.voIP token success:\(token)")
        self.token = token
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {

        YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith type \(type)")
        YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith payload: \(payload.dictionaryPayload)")

        guard type == PKPushType.voIP else {
            return
        }

        guard
            let callID: String = payload.dictionaryPayload["callid"] as? String,
            let state: Int = payload.dictionaryPayload["state"] as? Int,
            let aps: [AnyHashable : Any] = payload.dictionaryPayload["aps"] as? [AnyHashable : Any]
            else {
                return
        }

        let incomingCall = 0 // 来电
        let cancelCall = 1 // 挂断

        // 忽略同一个callID的来电推送（服务器会在被叫时发送多次推送，解决app被杀死数秒内无法收到推送问题）
        if callingID == callID && state == incomingCall {
            YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith same callID incoming already")
            return
        }

        if state == incomingCall {
            YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith notify logic incoming")
            callingID = callID
            YLServiceAPI.setRegisterAccount(callID)
            //setRegisterAccount(callID)
        } else if state == cancelCall {
            YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith notify logic cancel call")
            YLServiceAPI.setRegisterAccount("")
            callingID = nil
        }

        if UIApplication.shared.applicationState == .background {

            let soundName = "voIP.wav"

//            let title = "Yealink VC Mobile"
            var body = ""
            if let alert: [AnyHashable : String] = aps["alert"] as? [AnyHashable : String] {
                // title = alert["title"] ?? ""
                body = alert["body"] ?? ""
            }

            if state == incomingCall {
                body = String(format: YLSDKLanguage.YLSDKIncomingCallFrom, body)
            } else if state == cancelCall {
                body = String(format: YLSDKLanguage.YLSDKMissingCall, body)
            }

            if #available(iOS 10.0, *) {
                // 使用不同的identifier防止第二次相同callID来电时，第一次来电的通知被替换
                let identifier = callID + String(Date().timeIntervalSince1970)

                if state == incomingCall {
                    YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith show incoming notification \(identifier)")
                    YLLocalPushManager.getInstance.registerLocalPushEvent(title: nil,
                                                                        body: body,
                                                                        info: nil,
                                                                        number: UIApplication.shared.applicationIconBadgeNumber + 1,
                                                                        distanceTime: 1,
                                                                        identifier,
                                                                        soundName)

                    callingNotificationIdentifier = identifier
                } else if state == cancelCall {
                    if let identifier = callingNotificationIdentifier {
                        YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith removeDeliveredNotifications \(identifier)")
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
                        callingNotificationIdentifier = nil
                    }

                    YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith show cancel call notification \(identifier)")
                    YLLocalPushManager.getInstance.registerLocalPushEvent(title: nil,
                                                                        body: body,
                                                                        info: nil,
                                                                        number: UIApplication.shared.applicationIconBadgeNumber,
                                                                        distanceTime: 1,
                                                                        identifier,
                                                                        nil)
                }
            } else {
                let notification = UILocalNotification()

                if state == incomingCall {
                    notification.alertBody = body
                    notification.soundName = soundName
                    notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1

                    YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith show incoming notification \(notification)")

                    UIApplication.shared.presentLocalNotificationNow(notification)

                    callingNotification = notification
                } else if state == cancelCall {
                    if let notification = callingNotification {
                        YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith cancelLocalNotification \(notification)")
                        UIApplication.shared.cancelLocalNotification(notification)
                        callingNotification = nil
                    }

                    notification.alertBody = body
                    notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber

                    YLSDKLOG.debug("VoIPPushManager didReceiveIncomingPushWith show cancel call notification \(notification)")

                    UIApplication.shared.presentLocalNotificationNow(notification)
                }
            }
        }

    }
}
