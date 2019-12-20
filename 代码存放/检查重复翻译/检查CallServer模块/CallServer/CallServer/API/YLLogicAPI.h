//
//  UCLogicInterface.h
//  Odin-UC
//
//  Created by 姜祥周 on 16/12/14.
//  Copyright © 2016年 yealing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TalkDataDef.h"
#import "video_render_ios_view_interface.h"

@interface YLLogicAPI : NSObject
/**
 *  判断是非否初始化成功
 *
 *  @return bool
 */

+ (bool)isInitSucess;

/**
 *  播放bundle 里面的提示音
 *  @param strFile 路径
 *  
 */

+ (void)playFile:(NSString*)strFile;

/**
 *  停止播放
 *
 */
+ (void)stopPlayFile;

/**
 *  挂断
 *  @param callid 整形 通话Id
 *
 */
+ (void)hangUp:(int)callid;

/**
 *  音频mute
 *
 */
+ (void)mute;

/**
 *  音频解mute
 *
 */
+ (void)uMute;

/**
 *  获取音量
 *
 */
+ (int)getVolumn;

/**
 *  设置音量
 *
 */
+ (void)setVolumn:(int)value;

/**
 *  播放DTMF 声音
 *  @param soundId DTMF 提示音Id
 *
 */
+ (void)playDtmf:(NSString *)soundId;

/**
 *  向服务器发送DTMF 并播放soundId
 *  @param soundId DTMF 提示音Id
 *  @param callid  通话 id
 *
 */
+ (void)sendDtmfCallid:(int)callid soundId:(NSString *)soundId;

/**
 *  获得后台日志路径
 *
 */
+ (NSString *)generateLogReportsPath;

/**
 *  清理后台日志路径
 *
 */
+ (void)disposeCrashReports;

/**
 *  获得通话统计信息
 *  @param callid  通话 id
 *
 */
+ (TalkStatistics *)getCallStatistics: (int)callid;

/**
 *  设置视频layout 
 *  @param view VideoRenderIosView
 *  @param eLayoutType  通话视频type
 *
 */
+ (void)setMyLayout:(VideoRenderIosView *)view viewId:(int)viewId eLayoutType:(int)eLayoutType;

/**
 *  移除视频输出
 *
 *  @param lpWin       lpWin description
 *  @param viewID      viewID description
 *  @param eLayoutType eLayoutType description
 */
+ (void)removeLayout:(VideoRenderIosView*)lpWin viewId:(int)viewID eLayoutType:(int)eLayoutType;

/**
 *  接听通话
 *  @param callId  通话 id
 *
 */
+ (void)answer:(int) callId;

/**
 *  切换摄像头
 *  @param camraSpecifier  前后摄像头 标示符
 *
 */
+ (void)switchCamear:(NSString *)camraSpecifier;

/**
 *  建立通话
 *  @param iProtocol 拨号界面选择拨号类型：0，自动；1：云账号；2：H323或sip帐号
 *  @param bVideo 是否视频
 *  @param strNumber 号码
 *  @param iDialType 拨号类型
 *
 */
+(int)makeCall:(int)iProtocol isVideo:(bool)bVideo callNumber:(NSString*)strNumber dialType:(int)iDialType;

/*是否存在通话：来电、去电和正在通话中
 * @return 是否存在通话
 */
+ (bool)isHasTalk;

/*设置音频状态
 * @bRunning 是否开启音频引擎：是开启，否关闭
 */
+ (void)audioEngineStatus:(bool)bRunning;

/**
 *  开启视频通话
 *  @return true or false
 */
+ (bool)muteVideo;

/**
 *  停止视频通话
 *  @return true or false
 */
+ (bool)unmuteVideo;

/*是否正在视频通话
 * @return 是否在视频通话
 */
+ (bool)isVideoTalking;

/*设置视频状态
 * @bRunning 是否开启视频引擎：是开启，否关闭
 */
+ (void)videoEngineStatus:(bool)bRunning;

/**
 *  更新摄像头方向
 *  @param iOrientation 旋转方向
 */
+ (void)updateCaptureOrientation:(int)iOrientation;

/**
 *  设置音频模式
 *
 *  @param mode 1-:强制使用HandFree  0-使用默认声道
 */
+ (void)setAudioMode:(int) mode;

/**
 *  DND是否开启
 *
 *  @return true or false
 */
+ (bool)isDndOn;

/**
 *  开启DND
 *
 *  @return true or false
 */
+ (bool)setDndOn;

/**
 *  关闭DND
 *
 *  @return true or false
 */
+ (bool)setDndOff;

/**
 *  拒绝
 *
 *  @param iCallID 通话ID
 *
 *  @return true or false
 */
+ (bool)refuse:(int)iCallID;

/**
 *  获取当前使用摄像头
 *
 *  @return 当前摄像头显示名
 */
+ (NSString*)get_CurrentCamera;

/**
 *  重置摄像头
 */
+ (void)reset_Camera;

/**
 *  发送DTMF信号
 *
 *  @param iCallID 通话ID
 *  @param cDtmf   DTMF 字符
 */
+ (void)sendDtmf:(int)iCallID cDtmf:(char)cDtmf;

/**
 *  获取SIP帐号状态
 *
 *  @param idAccount account ID值
 *
 *  @return int
 */
+ (int)getSipAccountState:(int)idAccount;

/**
 *  获取H323帐号状态
 *
 *  @param idAccount account ID值
 *
 *  @return int
 */
+ (int)getH323AccountState:(int)idAccount;

/**
 *  获取通话数据
 *
 *  @param iCallID 通话ID
 *
 *  @return TalkData 自定义对象,表示通话信息体
 */
+ (TalkData*)getCallData:(int)iCallID;

/**
 *  <#Description#>
 *
 *  @param strFile       <#strFile description#>
 *  @param strSection    <#strSection description#>
 *  @param strKey        <#strKey description#>
 *  @param nDefaultValue <#nDefaultValue description#>
 *
 *  @return <#return value description#>
 */
+ (int)getIntConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey nDefault:(int)nDefaultValue;

/**
 *  <#Description#>
 *
 *  @param strFile    <#strFile description#>
 *  @param strSection <#strSection description#>
 *  @param strKey     <#strKey description#>
 *  @param nValue     <#nValue description#>
 *
 *  @return <#return value description#>
 */
+ (bool)setIntConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey nValue:(int)nValue;

/**
 *  <#Description#>
 *
 *  @param strFile         <#strFile description#>
 *  @param strSection      <#strSection description#>
 *  @param strKey          <#strKey description#>
 *  @param strDefaultValue <#strDefaultValue description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getStringConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey strDefault:(NSString*)strDefaultValue;

/**
 *  <#Description#>
 *
 *  @param strFile         <#strFile description#>
 *  @param strSection      <#strSection description#>
 *  @param strKey          <#strKey description#>
 *  @param strDefaultValue <#strDefaultValue description#>
 *
 *  @return <#return value description#>
 */
+ (bool)setStringConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey strDefault:(NSString*)strDefaultValue;

/**
 *  获取本地IP地址
 *
 *  @return 本地IP地址字符串
 */
+ (NSString*)get_LocalIp;

/**
 *  获取摄像头列表
 *
 *  @return 获取摄像头列表("Back Camera","Front Camera")
 */
+ (NSMutableArray*)get_CameraList;

/**
 *  释放视频用于二次设置
 *  @param eLayoutType eLayoutType description
 */
+ (void)releaseLayout:(int)eLayoutType;

/**
 *  用pin code登录云账号
 *  @param strPinCode pin code
 *  @return 是否处理成功
 */
+ (bool)asyncLoginByPinCode:(NSString*)strPinCode strServer:(NSString*)strServer;

/**
 *  用用户名和密码登录云账号
 *  @param strNumber 云账号用户名
 *  @param strPassword 云账号密码
 *  @param bRememberPwd 云账号是否保存密码
 *  @return 是否处理成功
 */
+ (bool)asyncLoginByNumber:(NSString*)strNumber strPassword:(NSString*)strPassword bRememberPwd:(bool)bRememberPwd strServer:(NSString*)strServer;

/** function
 *  @brief:使用用户名、密码、服务器、备份服务器登陆YMS
 *  @strNumber @in @brief:登陆账号
 *  @strPassword @in @brief:登陆密码
 *  @bRememberPwd @in @brief:是否保存密码
 *  @strServer @in @brief:登陆服务器
 *  @strProxyServer @in @brief:登陆备份服务器
 *  @return:是否可以登陆，注：该结果不是登陆结果，登陆结果有消息通知
 **/
+ (bool)asyncLoginPremise:(NSString*)strNumber strPassword:(NSString*)strPassword bRememberPwd:(bool)bRememberPwd strServer:(NSString*)strServer strProxyServer:(NSString*)strProxyServer;

/** function
 *  @brief:根据帐号获取云账号服务器
 *  @strAccountNumber @in @brief:YMS帐号
 *  @bPremise @in @brief:是否是YMS服务器
 *  @return:云账号服务器
 **/
+ (NSString*)getCloudServer:(NSString*)strAccountNumber isPremise:(bool)bPremise;

/** function
 *  @brief:根据帐号获取云账号备份服务器
 *  @strAccountNumber @in @brief:YMS帐号
 *  @bPremise @in @brief:是否是YMS备份服务器
 *  @return:云账号备份服务器
 **/
+ (NSString*)getCloudOutboundServer:(NSString*)strAccountNumber isPremise:(bool)bPremise;

/**
 *  同步上次云账号状态
 *  @return 是否处理成功
 */
+ (bool)sync_LastAccountState;

/**
 *  取消登录中的云账号
 */
+ (void)cancel_Login;

/** function
 *  @brief:获取保存的账号列表
 *  @bPremise @in @brief:是否是YMS账号列表，否则是云账号列表
 *  @return:保存的账号列表
 **/
+ (NSMutableArray*)getNumberList:(bool)bPremise;

/** function
 *  @brief:根据账号去除存储的登陆账号
 *  @strAccountNumber @in @brief:账号
 *  @bPremise @in @brief:是否是YMS账号，否则是云账号
 *  @return:是否删除成功
 *  @note:云账号和YMS账号共用该函数
 **/
+ (bool)deleteAccountByNumber:(NSString*)strAccountNumber bPremise:(bool)bPremise;

/**
 *  获取当前登录的云账号显示名
 *  @return 当前使用云账号的显示名
 */
+ (NSString*)get_CurrentNumber;

/** function
 *  @brief:获取当前账号状态
 *  @return:当前账号状态：0:None;1:logining;2:logined;3:disable;4:offline;
 *  @note:云账号和YMS账号共用该函数
 **/
+ (int)get_CurrentStatus;

/** function
 *  @brief:根据账号获取账号对应密码
 *  @strAccountNumber @in @brief:账号
 *  @bPremise @in @brief:是否是YMS账号，否则是云账号
 *  @return:账号对应密码
 *  @note:云账号和YMS账号共用该函数
 **/
+ (NSString*)getPasswordByNumber:(NSString*)strAccountNumber bPremise:(bool)bPremise;

/**
 *  获取云账号登录错误信息
 *  @return 云账号登录错误信息
 */
+ (NSString*)get_LastErrorMsg;

/** function
 *  @brief:获取账号登录错误信息
 *  @return:错误信息
 *  @note：云账号和YMS账号共用该函数
 **/
+ (int)get_LastErrorCode;

/** function
 *  @brief:当前使用的是否是YMS账号
 *  @return:当前使用的是否是YMS账号
 *  @note:云账号和YMS账号共用该函数
 **/
+ (bool)is_UsingYMSAccount;

/*获取云账户的状态
 *  @return 云账号登录状态
 */
+ (bool)is_CloudAccountRegister;
/*获取SIP的状态
 *  @return SIP登录状态
 */
+ (bool)is_SipAccountRegister;
/*获取h323的状态
 *  @return h323登录状态
 */
+ (bool)is_H323AccountRegister;

/*是否存在需要导出的Crash文件
 * @return 是否存在需要导出的Crash文件
 */
+ (bool)is_ExistCrashForReport;

/*是否正在使用移动流量
 * @return 是否正在使用移动流量
 */
+ (bool)is_UsingMobileTraffic;

/* 设置是否关闭本地摄像头
 * bClose 是否关闭摄像头
 * @return 是否设置成功
 */
+ (bool)setCameraClose:(bool)bClose;

/* 获取本地摄像头状态
 * @return 本地摄像头状态：0：摄像头正常工作；1：摄像头被关闭；2：摄像头Mute；3：摄像头不存在；4：摄像头开启失败
 */
+ (int)get_CameraState;

/** function
 *  @brief:设置设备Token
 *  @strDeviceToken @in @brief:设备标示
 *  
 **/
+ (void)setDeviceToken:(NSString*)strDeviceToken;

/**
 *  设置SIP帐号信息
 *
 *  @param idAccount     account ID
 *  @param pfile 自定义对象,表示sip帐号信息体
 */
+ (void) set_SipProfile: (int )idAccount pfile:(SipAccountProfile *) pfile ;

/**
 *  获取SIP帐号信息

 @param idAccount account ID
 @return 自定义对象,表示sip帐号信息体
 */
+ (SipAccountProfile *)get_SipProfile:(int)idAccount;

/** function
 *  @brief:json格式的rpc接口
 *  @strZipFile @in @brief:接口名和参数的json格式字符串
 *  @return:调用函数返回接口的json格式字符串
 **/
+ (NSString *)rpcCall:(NSString *)strInputJson;
@end
