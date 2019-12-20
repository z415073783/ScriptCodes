//
//  ExitErrorCode.swift
//  SwiftShellFramework
//
//  Created by zlm on 2018/12/28.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation

/// exit的错误码 最大值232
///
/// - normal: 正常退出
/// - paramsError: 入参错误
public enum ErrorCode: Int32 {
    case normal = 0,
    paramsError = 200
}
