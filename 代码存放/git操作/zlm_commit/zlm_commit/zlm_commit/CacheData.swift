//
//  CacheData.swift
//  zlm_commit
//
//  Created by zlm on 2018/12/29.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation
class CacheData {
    static let shared = CacheData()
    let data = ProcessInfo.processInfo.getDictionary()
    //获取需要合入的分支名
    class func getBranch() -> String {
        let branch: String = shared.data["b"] ?? "master"
        return branch
    }
    //获取帐号授权token
    class func getPrivateToken() -> String {
        let token: String = shared.data["token"] ?? "z5nmXsuK5KbZ79pSZu_R"
        return token
    }

    var newBranch: String?


}
