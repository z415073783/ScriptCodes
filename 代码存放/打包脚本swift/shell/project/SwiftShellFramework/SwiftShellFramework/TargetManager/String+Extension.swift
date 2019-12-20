//
//  String+Extension.swift
//  AutoBuildScrpit
//
//  Created by zlm on 2018/7/2.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
extension String {
    public func split(_ separator: Character) -> [String] {
        return self.split { $0 == separator }.map(String.init)
    }
}
