//
//  UCServiceInterface.h
//  Odin-UC
//
//  Created by 姜祥周 on 16/12/23.
//  Copyright © 2016年 yealing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkDataDef.h"

@interface YLConfAPI : NSObject

/**********************************************会议功能接口****************************************************/
/** function
 *  @brief:创建ad-hoc会议
 *  @listInviteMember @in @brief:会议成员列表
 *  @bVideoCall @in @brief:是否是视频
 *  @return:非正值标示错误码，其余通话id
 **/
+ (int)createConference:(NSMutableArray*)listInviteMember isVideoCall:(bool)bVideoCall;

/** function
 *  @brief:中性通话在通话过程中升级为会议
 *  @nCallId @in @brief:通话id
 *  @return:非正值标示错误码，其余通话id
 **/
+ (int)upgradeTalkToConference:(int)nCallId;

/** function
 *  @brief:加入会议
 *  @strConferenceNumber @in @brief:会议id
 *  @strUri @in @brief:会议加入者uri
 *  @strSubject @in @brief:会议主题
 *  @return:非正值标示错误码，其余通话id
 **/
+ (int)joinConference:(NSString*)strConferenceNumber strURI:(NSString*)strUri strSubject:(NSString*)strSubject strEntity:(NSString*)strEntity;

/** function
 *  @brief:重新加入会议
 *  @strConferenceNumber @in @brief:会议id
 *  @strUri @in @brief:会议加入者uri
 *  @strSubject @in @brief:会议主题
 *  @return:非正值标示错误码，其余通话id
 **/
+ (int)rejoinConference:(NSString*)strConferenceNumber strURI:(NSString*)strUri strSubject:(NSString*)strSubject strEntity:(NSString*)strEntity;

/** function
 *  @brief:结束会议
 *  @nCallId @in @brief:通话id
 *  @return:非正值标示错误码，其余通话id
 **/
+ (int)finish_Conference:(int)nCallId;

/*离开会议调hangup接口*/

/** function
 *  @brief:邀请成员加入会议
 *  @nCallId @in @brief:通话id
 *  @listMember @in @brief:邀请人员
 *  @bDialIn @in @brief:是否拨入，apollo使用dial-out方式
 *  @return:是否可以邀请人员
 **/
+ (bool)inviteMember:(int)nCallId Members:(NSMutableArray*)listMember isDialIn:(bool)bDialIn;

/** function
 *  @brief:移除一个会议成员，该会议成员会被挂断 其它成员处理 会议通告消息
 *  @nCallId @in @brief:通话id
 *  @strMember @in @brief:移除人员
 *  @return:是否可以移除人员
 **/
+ (bool)removeMember:(int)nCallId strMember:(NSString*)strMember;

/** function
 *  @brief:用于主席模式下 举手申请发言
 *  @return:是否允许举手发言
 **/
+ (bool)requestSpeak:(int)nCallId;

/** function
 *  @brief:用于主席模式下 取消举手发言
 *  @return:是否可以取消举手发言
 **/
+ (bool)cancelRequestSpeak:(int)nCallId;

/** function
 *  @brief:是否禁用某个成员发言
 *  @nCallId @in @brief:通话id
 *  @userData @in @brief:成员信息
 *  @bDisable @in @brief:是否禁用发言
 *  @return:是否可以执行该操作
 **/
+ (bool)disableMemberSpeak:(int)nCallId userData:(IConferenceUserData*)userData isDisable:(bool)bDisable;

/** function
 *  @brief:忽略会议加入请求
 *  @nCallId @in @brief:通话id
 *  @nSessionId @in @brief:会议id
 *  @return:执行结果
 **/
+ (bool)ignoreJoinConferenceRequest:(int)nCallId sessionId:(int)nSessionId;

/** function
 *  @brief:接受会议加入请求
 *  @nCallId @in @brief:通话id
 *  @nSessionId @in @brief:会议id
 *  @return:执行结果
 **/
+ (bool)acceptJoinConferenceRequest:(int)nCallId sessionId:(int)nSessionId;

/** function
 *  @brief:获取会议请求信息
 *  @nCallId @in @brief:通话id
 *  @nSessionId @in @brief:会议id
 *  @return:执行结果,IConfRequestJoinData*
 **/
+ (IConfRequestJoinData*)findRequestSession:(int)nCallId sessionId:(int)nSessionId;

/** function
 *  @brief:获取会议最后加入者
 *  @nCallId @in @brief:通话id
 *  @bUserId @in @brief:是否返回id即号码，true为号码，false为显示名
 *  @return:最后加入者
 **/
+ (NSString*)getConferenceLastJoineUser:(int)nCallId bUserId:(bool)bUserId;

/** function
 *  @brief:获取会议最后离开者
 *  @nCallId @in @brief:通话id
 *  @bUserId @in @brief:是否返回id即号码，true为号码，false为显示名
 *  @return:最后离开者
 **/
+ (NSString*)getConferenceLastLeaveUser:(int)nCallId bUserId:(bool)bUserId;

/** function
 *  @brief:获取会议成员
 *  @nCallId @in @brief:通话id
 *  @return:会议人员
 **/
+ (NSMutableArray*)getMemberList:(int)nCallId;

/** function
 *  @brief:获取会议属性信息
 *  @nCallId @in @brief:通话id
 *  @return:会议属性，IConferenceCallProperty
 **/
+ (IConferenceCallProperty*)getConfCallProperty:(int)nCallId;

/** function
 *  @brief:获取会议成员
 *  @nCallId @in @brief:通话id
 *  @return:是否获取成功
 **/
+ (bool)audioToVideo:(int)nCallId;

/** function
 *  @brief:获取会议成员
 *  @nCallId @in @brief:通话id
 *  @return:是否获取成功
 **/
+ (bool)videoToAudio:(int)nCallId;

/**********************************************会议日程接口****************************************************/
/** function
 *  @brief:获取会议日程详情列表
 *  @return:会议日程详情列表,成员IMeetingScheduleInfo
 **/
+ (NSMutableArray*)getMeetingScheduleInfoList;

/** function
 *  @brief:获取会议详情信息
 *  @strMeetingId @in @brief:会议id
 *  @strScheduleId @in @brief:日程id
 *  @return:会议详情
 **/
+ (IMeetingDescript*)getMeetingDescript:(NSString*)strMeetingId strScheduleId:(NSString*)strScheduleId;

/** function
 *  @brief:是否支持会议
 *  @return:是否支持会议
 **/
+ (bool)supportMeetingConf;

/** function
 *  @brief:获取会议的uri
 *  @return:会议uri
 **/
+ (NSString*)getMeetingConfUri;

/** function
 *  @brief:获取日程信息
 *  @strMeetingId @in @brief:会议id
 *  @strScheduleId @in @brief:日程id
 *  @return:日程详情
 **/
+ (IMeetingSchedule*)getScheduleById:(NSString*)strMeetingId strScheduleId:(NSString*)strScheduleId;

/** function
 *  @brief:获取未读日程数量
 *  @return:未读日程数
 **/
+ (int)getUnreadScheduleCnt;

/** function
 *  @brief:设置日程已读
 *  @strMeetingId @in @brief:会议id
 *  @strScheduleId @in @brief:日程id
 *  @return:设置是否成功
 **/
+ (bool)setMeetingReaded:(NSString*)strMeetingId strScheduleId:(NSString*)strScheduleId;

/** function
 *  @brief:忽略日程
 *  @strMeetingId @in @brief:会议id
 *  @strScheduleId @in @brief:日程id
 *  @return:是否忽略成功
 **/
+ (bool)ignoreSchedule:(NSString*)strMeetingId strScheduleId:(NSString*)strScheduleId;

/** function
 *  @brief:获取已经进入会议成员
 *  @nCallId @in @brief:通话id
 *  @return:会议人员
 **/
+ (NSMutableArray*) getPreviousJoinedMembers:(int) nCallId;
@end
