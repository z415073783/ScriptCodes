//
//  TypeEnum.swift
//  zlm_commit
//
//  Created by zlm on 2018/12/28.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation
enum CommitType: String {
    case fea = "fea",
    res = "res",
    cho = "cho",
    ref = "ref",
    tes = "tes",
    per = "per",
    for_ = "for",
    bug = "bug",
    none = ""


    func getType() -> String {
        switch self {
        case .fea:
            return "【Feat】"
        case .res:
            return "【Res】"
        case .cho:
            return "【Chore】"
        case .ref:
            return "【Refactor】"
        case .tes:
            return "【Test】"
        case .per:
            return "【Perf】"
        case .for_:
            return "【Format】"
        case .bug:
            return "【Fix】"
        case .none:
            return ""
        }
    }

}
