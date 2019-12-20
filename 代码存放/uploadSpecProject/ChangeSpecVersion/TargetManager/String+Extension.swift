//
//  String+Extension.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public extension String {
    public func split(_ separator: Character) -> [String] {
        return self.split { $0 == separator }.map(String.init)
    }
    /// 正则表达式查询
    ///
    /// - Parameters:
    ///   - pattern: 表达式
    /// - Returns: 结果列表
    public func regularExpressionFind(pattern: String) -> [NSTextCheckingResult] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)

            /// 在string中有emoji时，text.count在regex中的字符数不一致，text.utf16.count
            let textRange = NSRange(self.startIndex..., in: self)
            let res = regex.matches(in: self,
                                    options: .reportProgress,
                                    range: textRange)
            return res
        } catch {
            return []
        }
    }

    //使用正则表达式替换
    public func regularExpressionReplace(pattern: String, with: String,
                                  options: NSRegularExpression.Options = []) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: NSMakeRange(0, self.count),
                                                  withTemplate: with)
        } catch {
            YLLOG.error("正则表达式替换失败 pattern = \(pattern); with = \(with); self = \(self); error = \(error)")
            return nil
        }
    }

}
