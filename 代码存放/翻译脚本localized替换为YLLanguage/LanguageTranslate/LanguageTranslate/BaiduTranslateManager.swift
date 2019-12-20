//
//  BaiduTranslateManager.swift
//  LanguageTranslate
//
//  Created by zlm on 2019/1/14.
//  Copyright © 2019 zlm. All rights reserved.
//

import Foundation
typealias TranslateJSON = String

enum BaiduTranslateLanguage: String {
    case 中文 = "zh",
    英语 = "en",
    粤语 = "yue",
    文言文 = "wyw",
    日语 = "jp",
    韩语 = "kor",
    法语 = "fra",
    西班牙语 = "spa",
    泰语 = "th",
    阿拉伯语 = "ara",
    俄语 = "ru",
    葡萄牙语 = "pt",
    德语 = "de",
    意大利语 = "it",
    希腊语 = "el",
    荷兰语 = "nl",
    波兰语 = "pl",
    保加利亚语 = "bul",
    爱沙尼亚语 = "est",
    丹麦语 = "dan",
    芬兰语 = "fin",
    捷克语 = "cs",
    罗马尼亚语 = "rom",
    斯洛文尼亚语 = "slo",
    瑞典语 = "swe",
    匈牙利语 = "hu",
    繁体中文 = "cht",
    越南语 = "vie"
}


class BaiduTranslateManager {
    static let appID = "20171012000087775"
    static let secretKey = "Shi5z6GUP0wDTkQ6cT66"
    class func getEnglishTranslate(src: String, to: BaiduTranslateLanguage = .英语) -> TranslateJSON? {
        let time = String(Int(Date().timeIntervalSince1970))
        let needMd5 = "\(appID)\(src)\(time)\(secretKey)"
        YLLOG.info("needMd5 = \(needMd5)")
        let md5 = needMd5.MD5
        let output = Network.getRequest(url: "http://api.fanyi.baidu.com/api/trans/vip/translate", params: ["q":src, "from": "auto", "to": to.rawValue, "appid": appID, "salt": time, "sign": md5])

//        获取网络返回json
        let resultList = output?.regularExpressionFind(pattern: "\\{.*\\}")
        guard let first = resultList?.first, let _output = output as NSString? else {
            return nil
        }
        let json = _output.substring(with: first.range)
        return json
    }
    // 获取翻译值
    class func getTranslateResult(jsonStr: TranslateJSON) -> String? {
        let json = jsonStr.getJSONDataSync(JSONBaiduTranslate.self)
        return json?.trans_result?.first?.dst
    }


}
