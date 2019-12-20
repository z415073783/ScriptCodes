//
//  InterfaceModel.swift
//  LanguageTranslate
//
//  Created by zlm on 2019/1/17.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
struct JSONBaiduTranslate: YLJSONCodable {
    var from: String?
    var to: String?
    var trans_result: [JSONBaiduTranslateResult]?
}
struct JSONBaiduTranslateResult: YLJSONCodable {
    var src: String?
    var dst: String?
}
