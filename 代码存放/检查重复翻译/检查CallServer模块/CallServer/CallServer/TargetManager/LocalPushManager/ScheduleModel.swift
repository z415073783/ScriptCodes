//
//  ScheduleModel.swift
//  Odin-YMS
//
//  Created by zlm on 2017/6/24.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit

class ScheduleModel: NSObject {

    var scheduleID: String = ""
    var meetingID: String = ""
    var title: String = ""
    var beginTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var isIgnore: Bool = false
    var reminderMinutesBeforeStart: Int = 0 //提前提醒x分钟提醒

}
