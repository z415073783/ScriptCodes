//
//  TimeManager.swift
//  UME
//
//  Created by zlm on 16/8/23.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit

class SDKTimeManager: NSObject {
    enum TimeManagerWeekNumber: Int {
        case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
        func getString() -> String {
            switch self {
            case .monday:
                return YLSDKLanguage.YLSDKMonday
            case .tuesday:
                return YLSDKLanguage.YLSDKTuesday
            case .wednesday:
                return YLSDKLanguage.YLSDKWednesday
            case .thursday:
                return YLSDKLanguage.YLSDKThursday
            case .friday:
                return YLSDKLanguage.YLSDKFriday
            case .saturday:
                return YLSDKLanguage.YLSDKSaturday
            case .sunday:
                return YLSDKLanguage.YLSDKSunday
            }
        }
    }

    //获取当前时间戳
    class func getCurrentTime() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    //标准时间  例:2016年1月1日
    class func standardTime() -> String {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "yyyy年MM月dd日"
        let currentDate = Date()
        let currentTime = dateMatter.string(from: currentDate)
        return currentTime
    }

    /**
     和当前时间相差多少天
     
     - parameter time: 需要判断的时间
     
     - returns: 当前的时间差(单位:天)
     */
    class func translateTime(_ time: Double) -> Int {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
         //传入时间
        let date = Date(timeIntervalSince1970: time)
        let getTime = dateMatter.string(from: date)
        let getArr = getTime.components(separatedBy: "-")

        //当前时间
        let currentDate = Date()
        let currentTime = dateMatter.string(from: currentDate)
        let currentArr = currentTime.components(separatedBy: "-")

        //间隔时间
        var dis = currentDate.timeIntervalSince1970 - time

        //计算是否是今天
        var isToday: Bool = true
        for i in 0...2 {
            if getArr[i] != currentArr[i] {
                isToday = false
                 break
            }
        }
        if isToday == true {
            //今天
            return 0
        }

        //如果不是今天,那么减去当前时间到凌晨的时间差
        dis = dis - Double(currentArr[3])!*60.0*60.0 - Double(currentArr[4])!*60.0 - Double(currentArr[5])!
        //相隔多少天
        let day = dis/(60*60*24)
        //返回相差天数
        return Int(day+1)
    }

    class func showPictureStandardDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "HH:mm:ss"
        let curDate = Date().timeIntervalSince1970

        let inWeek = SDKTimeManager.dayOfWeek(time: timeInterval)
        let curWeek = SDKTimeManager.dayOfWeek(time: curDate)

        //let inYear = SDKTimeManager.getYear(timeInterval: timeInterval)
        //let curYear = SDKTimeManager.getYear(timeInterval: curDate)

        let mouth = SDKTimeManager.getMouth(timeInterval: timeInterval)
        let curMouth = SDKTimeManager.getMouth(timeInterval: curDate)

        //let days = SDKTimeManager.translateTime(timeInterval)
        if curWeek == inWeek {
            return "最近7 天"
        } else if mouth == curMouth {
            return "最近一月"
        } else {
            dateFormatter.dateFormat = "yyyy/MM"
            return dateFormatter.string(from: date)
        }

    }

    class func showHHmmDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)

    }

    class func showDayStandardDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "HH:mm:ss"
        let curDate = Date().timeIntervalSince1970

        let inWeek = SDKTimeManager.dayOfWeek(time: timeInterval)
        let curWeek = SDKTimeManager.dayOfWeek(time: curDate)

        let inYear = SDKTimeManager.getYear(timeInterval: timeInterval)
        let curYear = SDKTimeManager.getYear(timeInterval: curDate)

        let days = SDKTimeManager.translateTime(timeInterval)
        if days == 0 {
            return YLSDKLanguage.YLSDKToday
        } else if days == 1 {
            return YLSDKLanguage.YLSDKYesterday
        } else if days <= 6 && curWeek > inWeek {
            return (TimeManagerWeekNumber(rawValue: inWeek)?.getString())!
        } else if inYear == curYear {
            dateFormatter.dateFormat = "MM/dd"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            return dateFormatter.string(from: date)
        }

    }

    class func representTodayOrTomorrowToFromDate(fromTime: TimeInterval) -> String {
        let inWeek = SDKTimeManager.dayOfWeek(time: fromTime)
        let inWeekString = (TimeManagerWeekNumber(rawValue: inWeek)?.getString())!
        let nowTime: TimeInterval = getCurrentTime()
        let tomorrowTime: TimeInterval = nowTime + TimeInterval(TIME_INTERVAL_ONE_DAY)
        let todayString = getYearMonthAndDay(nowTime)
        let tomorrowString = getYearMonthAndDay(tomorrowTime)
        let currentString = getYearMonthAndDay(fromTime)
        if currentString == todayString {
            
            return YLSDKLanguage.YLSDKToday + ", " + getYearMonthAndDay(fromTime) + ", " + inWeekString
        } else if currentString == tomorrowString {
            
            return YLSDKLanguage.YLSDKTomorrow + ", " + getYearMonthAndDay(fromTime) + ", " + inWeekString
        }
        return getYearMonthAndDay(fromTime) + ", " + inWeekString
    }

    //显示标准日期格式
    class func showStandardDate(timeInterval: TimeInterval) -> String {

        if timeInterval == 0 {
            return ""
        }
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "HH:mm:ss"
        let curDate = Date().timeIntervalSince1970

        let inWeek = SDKTimeManager.dayOfWeek(time: timeInterval)
        let curWeek = SDKTimeManager.dayOfWeek(time: curDate)

        let inYear = SDKTimeManager.getYear(timeInterval: timeInterval)
        let curYear = SDKTimeManager.getYear(timeInterval: curDate)

        let days = SDKTimeManager.translateTime(timeInterval)
        if days == 0 {
            return dateFormatter.string(from: date)
        } else if days == 1 {
            return "昨天"
        } else if days <= 6 && curWeek > inWeek {
            return (TimeManagerWeekNumber(rawValue: inWeek)?.getString())!
        } else if inYear == curYear {
            dateFormatter.dateFormat = "MM/dd"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            return dateFormatter.string(from: date)
        }
    }
    //显示标准日期格式+时间
    class func showStandardDateAndTime(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "HH:mm:ss"
        let curDate = Date().timeIntervalSince1970

        let inWeek = SDKTimeManager.dayOfWeek(time: timeInterval)
        let curWeek = SDKTimeManager.dayOfWeek(time: curDate)

        let inYear = SDKTimeManager.getYear(timeInterval: timeInterval)
        let curYear = SDKTimeManager.getYear(timeInterval: curDate)

        let days = SDKTimeManager.translateTime(timeInterval)
        if days == 0 {
            return dateFormatter.string(from: date)
        } else if days == 1 {
            return "昨天 " + dateFormatter.string(from: date)
        } else if days <= 6 && curWeek > inWeek {
            return (TimeManagerWeekNumber(rawValue: inWeek)?.getString())! + " " + dateFormatter.string(from: date)
        } else if inYear == curYear {
            dateFormatter.dateFormat = "MM/dd HH:mm:ss"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
    }
    //显示正常的时间格式 yyyy/MM/dd HH:mm:ss
    class func showNormalDate(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH时mm分ss秒"
        return dateFormatter.string(from: date)
    }

    //显示会议日程详情时间格式
    class func showMeetingScheduleDetailDate(_ fromTime: TimeInterval, _ toTime: TimeInterval) -> String {
        let nowTime: TimeInterval = getCurrentTime()
        let nowYear = getYear(timeInterval: nowTime)
        let fromYear = getYear(timeInterval: fromTime)
        let toYear = getYear(timeInterval: toTime)
        if fromYear == nowYear && toYear == nowYear {
            //都在今年
            let fromDay = getMonthAndDay(fromTime)
            let toDay = getMonthAndDay(toTime)
            if fromDay == toDay {
                //同一天
                let dateString = fromDay + " " + showHHmmDate(timeInterval: fromTime) + "~" + showHHmmDate(timeInterval: toTime)
                return dateString
            } else {
                //不同一天
                let dateString = fromDay + " " + showHHmmDate(timeInterval: fromTime) + "~" + toDay + " " + showHHmmDate(timeInterval: toTime)
                return dateString
            }
        } else {
            if fromYear == nowYear && toYear != nowYear {
                let fromDay = getMonthAndDay(fromTime)
                let toDay = getYearMonthAndDay(toTime)
                let dateString = fromDay + " " + showHHmmDate(timeInterval: fromTime) + "~" + toDay + " " + showHHmmDate(timeInterval: toTime)
                return dateString
            }
        }
        let fromDay = getYearMonthAndDay(fromTime)
        let toDay = getYearMonthAndDay(toTime)
        let dateString = fromDay + " " + showHHmmDate(timeInterval: fromTime) + "~" + toDay + " " + showHHmmDate(timeInterval: toTime)
        return dateString
    }

  //获取传入时间是星期几
    class func dayOfWeek(time: Double) -> Int {
        let fromDate: Date = Date(timeIntervalSince1970: time)
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        let unitFlags: NSCalendar.Unit = NSCalendar.Unit.weekday
        let dateComps = calendar.component(unitFlags, from: fromDate)
        var weekDay = dateComps - 1
        if weekDay == 0 {
            weekDay = 7
        }
        return weekDay
    }

    //获取传入时间转换为年月日
    class func getYearMonthAndDay(_ timeInterval: TimeInterval) -> String {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "yyyy/MM/dd"
        //传入时间
        let date = Date(timeIntervalSince1970: timeInterval)
        let getTime = dateMatter.string(from: date)
        return getTime
    }

    //获取传入时间转换为月日
    class func getMonthAndDay(_ timeInterval: TimeInterval) -> String {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "MM/dd"
        //传入时间
        let date = Date(timeIntervalSince1970: timeInterval)
        let getTime = dateMatter.string(from: date)
        return getTime
    }

    //    获取传入时间是哪月
    class func getMouth(timeInterval: TimeInterval) -> String {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "yyyy/MM"
        //传入时间
        let date = Date(timeIntervalSince1970: timeInterval)
        let getTime = dateMatter.string(from: date)
        let array  = getTime.components(separatedBy: "/")

        let returnTime = array.last
        return returnTime!
    }

//    获取传入时间是哪年
    class func getYear(timeInterval: TimeInterval) -> String {
        let dateMatter = DateFormatter()
        dateMatter.dateStyle = DateFormatter.Style.full
        dateMatter.dateFormat = "yyyy"
        //传入时间
        let date = Date(timeIntervalSince1970: timeInterval)
        let getTime = dateMatter.string(from: date)
        return getTime
    }

    // 通话计时 时 分 秒
    class func getTalkTimerLength(timeInterval: TimeInterval) -> String {
        let nowTime = Date.init().timeIntervalSince1970
        let differTime = (nowTime - timeInterval) as Double
        let differTimeInt = Int (differTime)

        let hour = (differTimeInt / TIME_INTERVAL_ONE_HOUR)

        let minitue = ((differTimeInt - hour * TIME_INTERVAL_ONE_HOUR)/TIME_INTERVAL_ONE_MINUTE)

        let second = (differTimeInt - hour * TIME_INTERVAL_ONE_HOUR - minitue * TIME_INTERVAL_ONE_MINUTE)

        let timeStr = NSString.localizedStringWithFormat("%02d:%02d:%02d", hour, minitue, second) as String

        return timeStr
    }

    class func getTalkTimerLengthFromZero(timeInterval: TimeInterval) -> String {

        let differTimeInt = Int (timeInterval)

        let hour = (differTimeInt / TIME_INTERVAL_ONE_HOUR)

        let minitue = ((differTimeInt - hour * TIME_INTERVAL_ONE_HOUR)/TIME_INTERVAL_ONE_MINUTE)

        let second = (differTimeInt - hour * TIME_INTERVAL_ONE_HOUR - minitue * TIME_INTERVAL_ONE_MINUTE)

        let timeStr = NSString.localizedStringWithFormat("%02d:%02d:%02d", hour, minitue, second) as String

        return timeStr
    }

    // 通话计时 把秒数转换为 时分秒类型 

    class func getTalkTimerDuration(durationTimeInt: Int) -> String {

        let hour = (durationTimeInt / TIME_INTERVAL_ONE_HOUR)

        let minitue = ((durationTimeInt - hour * TIME_INTERVAL_ONE_HOUR)/TIME_INTERVAL_ONE_MINUTE)

        let second = (durationTimeInt - hour * TIME_INTERVAL_ONE_HOUR - minitue * TIME_INTERVAL_ONE_MINUTE)

        var timeStr = ""

        if hour > 0 {
            timeStr = NSString.localizedStringWithFormat("%d时%d分%d秒", hour, minitue, second) as String
        } else if (minitue > 0) {
            timeStr = NSString.localizedStringWithFormat("%d分%d秒", minitue, second) as String
        } else {
            timeStr = NSString.localizedStringWithFormat("%d秒", second) as String
        }
        return timeStr

    }

}
