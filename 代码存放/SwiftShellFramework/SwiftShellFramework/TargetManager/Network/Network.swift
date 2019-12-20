//
//  Network.swift
//  SwiftShellFramework
//
//  Created by zlm on 2019/1/14.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case post = "POST", get = "GET"
}
class Network {
    class func getRequest(url: String, params: [String: String], httpMethod: HttpMethod = .get) -> ScriptOutput? {
        if httpMethod == .get {
            var dataStr = ""
            var index = 0
            for (key, value) in params {
                dataStr += (key + "=" + value)
                if index < params.count - 1 {
                    dataStr += "&"
                }
                index += 1
            }
            guard let allUrl = "\(url)?\(dataStr)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return nil
            }
            let result = YLScript.runScript(model: ScriptModel(path: kCurlPath, arguments: ["-i", allUrl], showOutData: true))
            let output = result.output
            return output
        }
        return nil
    }



}



