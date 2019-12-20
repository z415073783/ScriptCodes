//
//  ScheduleManager.swift
//  Odin-YMS
//
//  Created by zlm on 2017/6/24.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit

class ScheduleManager: NSObject {
    static let getInstance = ScheduleManager()

    func getScheduleInfoList() -> [ScheduleModel] {
        //获取日程列表
        var newList: [ScheduleModel] = []
        let list: NSMutableArray? = getMeetingScheduleInfoList()
        if list == nil {
            return []
        }
        for item in list! {
            let dic = item as! IMeetingScheduleInfo
            let model = ScheduleModel()
            let schedule: IMeetingSchedule = dic.m_tSchedule
            let descript: IMeetingDescript = dic.m_tDescript
            model.scheduleID = schedule.m_strScheduleId
            model.meetingID = schedule.m_strMeetingId
            model.title = descript.m_strSubject
            model.beginTime = TimeInterval(schedule.m_timeBegin)
            model.endTime = TimeInterval(schedule.m_timeEnd)
            model.reminderMinutesBeforeStart = Int(descript.m_nReminderMinutesBeforeStart)
            model.isIgnore = dic.m_tSchedule.m_bIgnoreShcedule
            newList.append(model)
        }
        newList.sort {
            $0.beginTime < $1.beginTime
        }
        return newList
    }
}
