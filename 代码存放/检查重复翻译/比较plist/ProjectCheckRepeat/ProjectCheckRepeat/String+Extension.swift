//
//  String+Extension.swift
//  CheckRepeat
//
//  Created by zlm on 2017/12/4.
//  Copyright © 2017年 zlm. All rights reserved.
//

import Foundation
extension String {
    func regularExpressionData(pattern:String) -> [NSTextCheckingResult] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let res = regex.matches(in: self, options: .reportProgress, range: NSMakeRange(0, (self.count)))
            return res
        } catch  {
            return []
        }
    }
}
