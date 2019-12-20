//
//  CallServer.h
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CallServerObject.h"

@protocol CallServerProtocol <NSObject>
/**
 *  注册状态变更
 */
- (void)registerStateChange;

/**
 *  用通话中操作的回调
 *  setTalkListener 方法废弃，需要返回值 SDKCallServerReturnResult
 */
- (YLSdkReturnResult *)ylSdkListener:(iclickType)iType returnObject:(YLSdkRespon *) respon;

@end

@interface CallServer : NSObject

//SDK启动启动

/**
 *  开启服务
 */
+ (void)startTalkService;

/**
 *  关闭服务
 */
+ (void)stopTalkService;

/**
 *  设置SDK 回调代理
 *  @param delegate 代理
 */
+ (void)setDelegate:(id<CallServerProtocol>) delegate;

//SDK注册
/**
 *  注册SIP
 *  监听通知 AccountStateChangeNotify
 */
+ (void)registerSip:(regAccountProfile*)pfile;

/**
 *  注销SIP
 *  监听通知 AccountStateChangeNotify
 */
+(void)unRegisterSip;

/**
 *  获取SIP注册状态
 *  YES 表示注册成功，其它表示注册没有成功
 */
+(BOOL)sipRegisterState;


/**
 *  注册YMS
 *  监听通知 CloudContactAccountNotify
 */
+ (void)registerYms:(NSString *)username
           password:(NSString *)password
             server:(NSString *)server
        proxyServer:(NSString *)proxyServer;

/**
 *  注销YMS
 *  监听通知 CloudContactAccountNotify
 */
+(void)unRegisterYms;

/**
 *  获取YMS注册状态
 *  YES 表示注册成功，其它表示注册没有成功
 */
+(BOOL)ymsRegisterState;


/**
 *  注册cloud
 *  监听通知 CloudContactAccountNotify
 */
+ (void)registerCloud:(NSString *)username
             password:(NSString *)password
               server:(NSString *)server;

/**
 *  注册Cloud pinCode
 *  监听通知 CloudContactAccountNotify
 */
+ (void)registerCloudPinCode:(NSString *)pinCode
                      server:(NSString *)server;

/**
 *  注销Cloud pinCode
 *  监听通知 CloudContactAccountNotify
 */
+(void)unRegisterCloud;

/**
 *  获取Cloud注册状态
 *  YES 表示注册成功，其它表示注册没有成功
 */
+(BOOL)cloudRegisterState;

//SDK通话

/**
 *  呼叫 联系人或者会议号码
 *  @param number 帐号号码或者会议号码
 */
+ (void)call:(NSString*)number;

/**
 *  呼叫 联系人或者会议号码
 *  @param number 帐号号码或者会议号码
 *  @param callType 呼叫类型 音频或者视频
 */
+ (void)call:(NSString*)number type:(icallType)callType;

/**
 *  呼叫 联系人或者会议号码
 *  @param number 帐号号码或者会议号码
 *  @param callType 呼叫类型 音频或者视频
 *  @param protol 呼叫协议，SDK建议选择Auto 或者SIP
 */
+ (void)call:(NSString*)number type:(icallType)callType protol:(icallprotol) protol;

/**
 *  立即会议
 *  @param numberList 立即会议需要邀请的联系人号码列表
 *  @param callType 呼叫类型 音频或者视频
 */
+ (void)meetingNow:(NSArray<NSString*>*) numberList type:(icallType)callType;

/**
 *  会议列表
 *  @return getMeetingList 当前登录用户的会议列表， 建议获取列表需要区分当前可加入会议和不可加入会议
 */
+ (NSArray <MeetingDate *>*)getMeetingList;

/**
 *  加入会议列表的会议
 *  @param strConferenceNumber 会议number
 *  @param strUri 会议URL
 *  @param strSubject 会议主题
 *  @param meetingId 会议ID
 */
+ (void)joinMeeting:(NSString*)strConferenceNumber
             strUri:(NSString*)strUri
         strSubject:(NSString*)strSubject
          meetingId:(NSString*)meetingId;


/**
 *  加入会议
 *  @param model 未登录情况下加入会议的模型
 */
+ (void)joinMeetingWithOutLoging:(YlLogingOutJoinMeetingModel*)model;

/**
 *  邀请联系人加入会议
 *  @param inviteMembers 邀请联系人列表
 */
+ (void)inviteMember:(NSArray <NSString*>*)inviteMembers;

/**
 *  是否在通话中
 *  @return BOOL Yes表示通话中，No 表示不在
 */

+ (BOOL)isHasTalk;

/**
 *  获得callID
 *  @return int 通话ID
 */
+ (int)getCallId;

/**
 *  通话中旋转摄像头
 *  @param finishblock 旋转完成后回调Block
 */
+ (void)switchCamera:(interFacehandle) finishblock;

/**
 *  是否允许设备旋转（通话中使用）
 *  @return BOOL Yes表示允许，No 表示不允许
 */
+ (BOOL)enableRotation;

/**
 *  建议的设备方向设备旋转（通话中使用）
 *  @return UIInterfaceOrientationMask
 */
+ (UIInterfaceOrientationMask)getSuggestOrientation;


// 后台模式
/**
 *  是否进入后台模式
 *  @param flag 是否进入后台模式
 */
+ (void)setBackgroundStatus:(BOOL)flag;


//联系人组织架构
/**
 *  是否进入后台模式
 *  @return cloudOrgType 列表组织机构还是树形结构（YMS2.0服务器为树，以前为列表）
 */
+ (cloudOrgType)getCloudContactType;

/**
 *  获取列表形式组织架构的列表
 *  @param key 搜索关键自 “” 会搜索全部人员
 *  @return NSArray <YlCloudContactDate*>* 云联系人列表
 */
+ (NSArray <YlCloudContactDate*>*)getNormalContactsList:(NSString *) key;

/**
 *  获取树形结构的组织结构节点和其一级子节点
 *  @param realKey 搜索关键自 “” 根节点
 *  @return OrgTreeInfo 节点模型
 */
+ (OrgTreeInfo*) getOrgNodeInfo:(NSString *) realKey;

// Yealink 内部使用
+ (UIViewController*)getCallViewController;

+ (NSArray *)getmeetingMemberArray;

+ (NSString *)getRemoteName;
    
+ (void) writeLogToSDK:(NSString *)logString;
@end


