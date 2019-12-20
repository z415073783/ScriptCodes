//
//  DateManager.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
//用于打印日志的时间格式
public func showLogDate(timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
    return dateFormatter.string(from: date)
}
//显示正常的时间格式 yyyy/MM/dd HH:mm:ss
public func showNormalDate(timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
    return dateFormatter.string(from: date)
}
