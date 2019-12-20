//
//  LocalPushManager.swift
//  Odin-YMS
//
//  Created by zlm on 2017/6/24.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit
import UserNotifications

let pushKey = "identifier"
class YLLocalPushManager: NSObject {

    static let getInstance = YLLocalPushManager()
    var notificationList: [String: UILocalNotification] = [:] //通知列表
    var isCalling: Bool = false  //是否正在通话
//    func enterBackgroundAndGetPushData() {
//
//        let list = ScheduleManager.getInstance.getScheduleInfoList()
//        var badge = 0
//        for i in 0 ..< list.count {
//
//            let item = list[i]
//
//            let body =  TimeManager.showMeetingScheduleDetailDate(item.beginTime, item.endTime)
//            let currentTime = Date().timeIntervalSince1970
//            var remindTime = item.beginTime
//            var preRemindTime = item.beginTime - TimeInterval(item.reminderMinutesBeforeStart * 60)
//            var distanceTime: TimeInterval = 1024
//
//            func push(time: TimeInterval) {
//                var curTime = time
//                if curTime < currentTime && item.endTime > currentTime {
//                    curTime = currentTime //立即提醒
//                }
//                var distanceTime = curTime - currentTime
//                if distanceTime <= 0 {
//                    distanceTime = 1
//                }
//                //已忽略,不提醒
//                if item.isIgnore {
//                    return
//                }
//                func sendNotification() {
//                    badge += 1
//                    registerLocalPushEvent(title: item.title, body: body, info: ["scheduleID": item.scheduleID, "meetingID": item.meetingID, "isIgnore": item.isIgnore ? 1 : 0], number: badge, distanceTime: distanceTime, item.scheduleID)
//                }
//                if #available(iOS 10.0, *) {
//                    let center = UNUserNotificationCenter.current()
//                    center.getDeliveredNotifications(completionHandler: { (notifications) in
//                        for notification in notifications {
//                            if notification.request.identifier == item.scheduleID {
//                                return
//                            }
//                        }
//                        sendNotification()
//                    })
//                } else {
//                    if notificationList[item.scheduleID] != nil {
//                        return
//                    }
//                    sendNotification()
//                }
//
//            }
//
//            if item.isIgnore == false {
//                push(time: preRemindTime)
//            }
//
////            if distanceTime > 1 {
////                if #available(iOS 10.0, *) {
////                    push(time: remindTime)
////                }else if item.isIgnore == true {
////                    push(time: remindTime)
////                }
////            }
//        }
//    }

    func registerLocalPushEvent(title: String?, body: String, info: [String: Any]? = [:], number: Int, distanceTime: TimeInterval, _ identifier: String = "identifier", _ sound: String? = UILocalNotificationDefaultSoundName) {
        var newTitle = title
        if title == nil || title?.characters.count == 0 {
            newTitle = kDisplayName as? String
        }

        var newDistanceTime = distanceTime

        var newInfo = info
        if newInfo == nil {
            newInfo = [:]
        }
        newInfo?[pushKey] = identifier
        if #available(iOS 10.0, *) {

            if newDistanceTime <= 0 {
                newDistanceTime = 1
            }
            let center = UNUserNotificationCenter.current()

                let content = UNMutableNotificationContent()
                content.title = newTitle!
                content.categoryIdentifier = identifier
                content.body = body

                if sound == UILocalNotificationDefaultSoundName {
                    content.sound = UNNotificationSound.default()
                } else if let sound = sound {
                    content.sound = UNNotificationSound(named: sound)
                }

                content.userInfo = newInfo!
                if number == 0 {
                    content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
                } else {
                    content.badge = number as NSNumber
                }

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: newDistanceTime, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if (error != nil) {
                        //print("error = \(error)")
                    }
                }
        } else {

            var localNotification: UILocalNotification? = notificationList[identifier]
            if localNotification != nil {
                UIApplication.shared.cancelLocalNotification(localNotification!)
            }

            localNotification = UILocalNotification()
            localNotification?.category = identifier
            localNotification?.fireDate = Date().addingTimeInterval(newDistanceTime)
            localNotification?.alertBody = body

            if #available(iOS 8.2, *) {
                localNotification?.alertTitle = newTitle!
            } else {
            }
            localNotification?.timeZone = NSTimeZone.default
            localNotification?.userInfo = newInfo
            localNotification?.alertAction = "open the app"
            localNotification?.soundName = sound
            notificationList[identifier] = localNotification
            if number == 0 {
                localNotification?.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            } else {
                localNotification?.applicationIconBadgeNumber = number
            }
            UIApplication.shared.scheduleLocalNotification(localNotification!)
        }
    }

//    func enterForegroundEndPush() {
//        //        清除个别推送
////        clearSelectNotification(identifity: kCallingStateIdentifity)
//
//        YLLOG.debug("enterForegroundEndPush")
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (sender) in
//                var removeList: [String] = []
//                for notification in sender {
//                    if notification.request.identifier == kCallingStateIdentifity {
//                        continue
//                    }
//                    removeList.append(notification.request.identifier)
//                }
//                if removeList.count > 0 {
//                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: removeList)
//                }
//            })
//            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        } else {
//            for (key, value) in notificationList {
//                if key == kCallingStateIdentifity {
//                    continue
//                }
//                UIApplication.shared.cancelLocalNotification(value)
//                notificationList[key] = nil
//            }
//        }
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
    //进入后台重新计算角标数量
//    func enterBackgroundEvent() {
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.getDeliveredNotifications(completionHandler: { (notifications) in
//                UIApplication.shared.applicationIconBadgeNumber = notifications.count
//            })
//        } else {
//            UIApplication.shared.applicationIconBadgeNumber = notificationList.count
//        }
//    }
    //关闭指定推送
//    func clearSelectNotification(identifity: String) {
//        YLLOG.debug("enterForegroundEndPush")
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (sender) in
//                for notification in sender {
//                    if notification.request.identifier == identifity {
//                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifity])
//                        break
//                    }
//                }
//            })
//        } else {
//            for (key, value) in notificationList {
//                if key == identifity {
//                    UIApplication.shared.cancelLocalNotification(value)
//                }
//                notificationList[key] = nil
//                break
//            }
//        }
//
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.getDeliveredNotifications(completionHandler: { (notifications) in
//                UIApplication.shared.applicationIconBadgeNumber = notifications.count
//            })
//        } else {
//            UIApplication.shared.applicationIconBadgeNumber = notificationList.count
//        }
//    }

    //添加通话中本地推送
//    func addCallingNotification() {
//
//        if isCalling == true {
//
//            if CallServerDataSource.getInstance.remoteName.characters.count > 0 {
//                registerLocalPushEvent(title: localized(key: "On call:") + CallServerDataSource.getInstance.remoteName, body: localized(key: "View details"), info: nil, number: 0, distanceTime: 1, kCallingStateIdentifity, nil)
//
//            } else {
//                registerLocalPushEvent(title: nil, body: localized(key: "On call"), info: nil, number: 0, distanceTime: 1, kCallingStateIdentifity, nil)
//            }
//        }
//    }

    func addMissCallNotification() {
        registerLocalPushEvent(title: nil, body: YLSDKLanguage.YLSDKYouHaveACall, info: nil, number: 0, distanceTime: 0, kCallCategory, nil)
    }

    //移除通话通知栏
//    func removeCallNotification() {
//        isCalling = false
//        clearSelectNotification(identifity: kCallingStateIdentifity)
//    }

}
