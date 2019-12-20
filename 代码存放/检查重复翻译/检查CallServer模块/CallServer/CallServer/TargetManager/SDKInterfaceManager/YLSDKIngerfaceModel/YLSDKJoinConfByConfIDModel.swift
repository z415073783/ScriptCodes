//
//  YLSDKJoinConfByConfIDModel.swift
//  CallServer
//  加入会议接口
//  功能：
//  登陆或未登陆云账号的情况下根据会议id等信息加入会议
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit
import HandyJSON
import YLBaseFramework
/*参数说明：
 参数参见json格式说明，返回错误类型如下：
 enum MakeCallErrorE
 {
 ME_NETWORK_ERROR = -100,    //网络错误
 ME_UNKNOW_PROTOCOL,    //未知协议
 ME_INVALID_URL,    //不可用URL
 ME_CALL_OUTGOING, //存在呼出通话
 ME_CALL_INCOMING, //存在来电
 ME_SERVICE_STOPED, //协议线程退出
 ME_NO_USABLE_ACCOUNT, //没有可用账号
 ME_RESOURCE_EXCESSED, //会议通话数量超出
 ME_ALREADY_EXISTED, //已经存在通话或会议
 ME_CONFERENCE_FAILED, //加入会议失败
 ME_DATA_TYPE_ERROR, //数据类型错误
 ME_SIP_SERVICE_UNAVAILABLE, //sip线程退出
 ME_H323_SERVICE_UNAVAILABLE, //H323线程退出
 ME_BOTH_SERVICE_UNAVAILABLE, //sip和H323线程都退出
 //premise conference error
 ME_CONFERENCE_EXISTED, //已经存在会议
 ME_TALK_NOT_EXIST, //通话升级会议时提示通话不存在
 ME_UPDATE_CONFERENCE_FAILED, //通话升级会议失败
 ME_CONFERENCE_NOT_SUPORRT, //不支持会议
 };
 */
class YLSDKJoinConfByConfIDModel: NSObject {
    //    加入会议接口
    //命名规则 模块名 + 接口名 + Input
    struct InputData: HandyJSON {
        var strConfID: String = ""
        var strPassword: String = ""
        var strName: String = ""
        var strServer: String = ""
        var bOpenMic: Bool = true
        var bOpenCamera: Bool = true
    }
    
    // MARK: output
    //命名规则 模块名 + 接口名 + OutPut + 自定义名称
    struct OutPutInfo: HandyJSON {
        var result: Result!
        var body: Body!
    }
    
    struct Result: HandyJSON {
        var errorCode: Int = 0
        var errorDesc: String = ""
        var operateID: String = ""
        var type: String = ""
    }
    
    struct Body: HandyJSON {
        var callID: Int = 0
    }

}
