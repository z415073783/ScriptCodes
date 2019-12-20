//
//  CallServerObject2.h
//  CallServer
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>


/*! @brief 通话类型
 *
 */
typedef enum  {
    unknow = 0,    //**< 未知  */
    video = 1,     //**< 视频  */
    audio = 2,     //**< 音频  */
} icallType;

/*! @brief 通话类型
 *
 */
typedef enum  {
    autoProtol = 0,    //**< 未知  */
    cloudProtol = 1,     //**< 视频  */
    sipH323Protol = 2,     //**< 音频  */
} icallprotol;

/*! @brief 通话类型
 *
 */
typedef enum  {
    cloudknow = 0,    //**< 未知  */
    cloudGeneral = 1, //**< 普通组织架构  */
    cloudOrg = 2,     //**< 树形架构  */
} cloudOrgType;


/*! @brief 选择类型
 *
 */
typedef enum {
    UNknow = 0,                         //**未知 默认  */
    
    EVENT_INVITE_CONTACT = 1,                       //** 1.邀请联系人 - 传入参会人员列表 */
    EVENT_INVITE_IP = 2,                     //**2.邀请H323/sip*/
    EVENT_AUDIO_MUTE = 3,                           //**3.静音*/
    EVENT_SHOW_DTMF = 4,                        //**4.拨号键盘*/
    EVENT_SPEAKER_ON = 5,                        //**5.扬声器*/
    
    EVENT_HANP_UP = 6,                         //**6.挂断*/
    EVENT_SHOW_STATISTIC = 7,                 //**7.通话统计*/
    EVENT_OPEN_SHARE_SCREEN = 8,                  //**8.接收辅流*/
    EVENT_CLOSE_SHARE_SCREEN = 9,                      //**9.断开辅流*/
    EVENT_HIDE_SMALL_WINDOWN = 10,               //**10.隐藏小窗口*/
    
    EVENT_VIDEO_MUTE = 11,               //**11.视频mute*/
    EVENT_VIDEO_UNMUTE = 12,                    //**12.视频unmute*/
    EVENT_SHOW_SMALL_WINDOWN = 13,                  //**13.显示小视频窗口*/
    EVENT_FULL_SCREEN = 14,                //**14.全屏显示*/
    EVENT_EXIT_FULL_SCREEN = 15,               //**15.退出全屏*/
    
    EVENT_LOCK_SCREEN = 16,                    //**16.界面锁定*/
    EVENT_UNLOCK_SCREEN = 17,                  //**17.界面解锁*/
    EVENT_SWITCH_CAMERA = 18,                  //**18.切换前后摄像头*/
    EVENT_CLICK_SMALL_WINDOW = 19,         //**19.点击小视频 大小窗口切换*/
    EVENT_HAND_UP = 20,                        //**20.举手*/
    
    EVENT_CANCEL_HAND_UP = 21,                      //**21.取消举手发言*/
    EVENT_AUDIO_UNMUTE = 22,                        //**22.解除静音*/
    EVENT_SPEAKER_OFF = 23,                      //**23.扬声器关*/
    EVENT_SHOW_TALK = 24,                   //**24.展示通话界面*/
    EVENT_CALL_FINISH = 25,                    //**25.通话结束*/
    
    EVENT_CALL_START = 26,               //**26.通话Establish 通话开始 */
    EVENT_INCOMING = 27,                 // 收到来电*/
    EVENT_CALL_UESTABLISH = 28,             //**28.通话EVENT_CALL_UESTABLISH */
    EVENT_CALL_FINISHVIEW_DISSMISS  = 29,      //**29.通话结束finihsView消失 */
    EVENT_SHARE_CONFERENCE_INFO = 30,              //**30 分享会信息 */
    EVENT_CALL_OUT = 31                             //**去电（通话请求返回Call ID > 0 时通知）*/
    
}iclickType;

// Block类型
typedef void(^interFacehandle)(void);

/*! @brief 选择类型
 *
 */
typedef enum {
    swatchCamear = 1,                       //** 1.切换摄像头 */
}interFaceRequestType;


@interface regAccountProfile : NSObject
@property (assign) bool m_bEnable; //开关
@property (strong) NSString *m_strRegisterName;//注册名
@property (strong) NSString *m_strDisplayName; //显示名
@property (strong) NSString *m_strUserName;//用户名
@property (strong) NSString *m_strAuthName;//认证名
@property (strong) NSString *m_strPassword;//密码
@property (strong) NSString *m_strServer;//服务器
@property (assign) int m_iPort; //服务器端口
@property (assign) int m_iTransfer; //传输协议 0:udp;1:TCP;2:TLS;3:DNS-NAPTR
@property (assign) bool m_bBFCP;//高级设置开关
@property (assign) bool m_bEnableOutbound;//代理设置开关
@property (strong) NSString *m_strOutboundServer;//代理地址
@property (assign) int m_iOutboundPort;//代理端口
@property (assign) bool m_bEnableStun;//Stun设置开关
@property (strong) NSString *m_strStunServer;//Stun服务器
@property (assign) int m_iStunPort;//Stun端口
@property (assign) int m_iNATType;//0:Disable;1:STUN;3:Static
@property (assign) int m_iSRTP;//0:Disable;1:Enabled;2:Limit
@property (assign) int m_iDTMFType;//0:INBAND;1:RFC2833;2:SIP INFO
@property (assign) int m_iDTMFInfoType;//1:DTMF-Relay;2:DTMF;3:Telephone-Event
@property (assign) int m_iDTMFPayload;//DTMF Payload Type(96~127)

-(void)setDefaultValue;

@end

@interface YLSdkRespon : NSObject
@property (strong, nullable) NSString *shareString;
@end

@interface YLSdkReturnResult: NSObject

@property (assign) bool handleReuslt; //处理是否成功
@property (assign) iclickType handleType; //处理事件类型

@end



@interface CallServerObject : NSObject

@end

@interface MeetingDate : NSObject
@property (strong) NSString *strConferenceNumber;
@property (strong) NSString *strUri;
@property (strong) NSString *strSubject;
@property (strong) NSString *meetingId;
@property(assign) NSTimeInterval beginTime;
@property(assign) NSTimeInterval endTime;
@end


@interface YlCloudContactDate : NSObject
@property (strong) NSString *usernumber;
@property (strong) NSString *username;
@property (strong) NSString *userid;

@end


@interface OrgTreeInfo : NSObject
@property (strong) NSString* m_strId; //结点唯一标识id
@property (assign) int m_iLeavesNum; //该结点下叶子结点数量
@property (assign) int m_iType; //该结点类型: enum OrgNodeType {ONT_UNKNOW = 0, ONT_ORG = 1, ONT_STAFF = 2, ONT_DEVICE = 4, ONT_VMR = 8, ONT_THIRDPARTY = 16}
@property (strong) NSString* m_strParentId; //该结点父节点的唯一标识id
@property (strong) NSString* m_strName; //结点显示名
@property (strong) NSString* m_strNamePinyin; //显示名拼音，该值用于中文转换
@property (strong) NSString* m_strNamePinyinAlia; //别名显示
@property (assign) int m_iIndex; //该结点在部门中的序号
@property (strong) NSString* m_strEmail; //该结点的邮箱地址
@property (strong) NSString* m_strNumber; //该结点的号码
@property (strong) NSString* m_strExtension; //该结点的补充号码
@property (strong) NSMutableArray<OrgTreeInfo *>* m_listChildren; //该结点的孩子结点列表，类型是OrgTreeInfo* 但是孩子节点m_listChildren没有值
@end


//登出状态加入会议输入模型
@interface YlLogingOutJoinMeetingModel : NSObject
@property (strong) NSString *confID; // 会议ID
@property (strong) NSString *password; // 会议密码
@property (strong) NSString *strName; // 未登录情况下的参会显示名
@property (strong) NSString *strServer; // 服务器地址
@property (assign) bool bOpenMic; // 是否打开麦克风 yes表示打开
@property (assign) bool bOpenCamera; // 是否打开相机 yes表示打开
@end

