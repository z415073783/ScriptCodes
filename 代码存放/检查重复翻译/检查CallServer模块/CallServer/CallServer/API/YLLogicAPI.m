//
//  UCLogicInterface.m
//  Odin-UC
//
//  Created by 姜祥周 on 16/12/14.
//  Copyright © 2016年 yealing. All rights reserved.
//

#import "YLLogicAPI.h"
#import "LogicInterface.h"
#import "LogicService.h"
#import "YLSdkLogAPI.h"

@implementation YLLogicAPI

+ (bool)isInitSucess
{
    [YLSdkLogAPI loginfo:@"isInitSucess"];

    return isInitSucess();
}

+ (void)playFile:(NSString*)strFile
{
    [YLSdkLogAPI loginfo:@"playFile"];

    playFile(strFile);
}

+ (void)stopPlayFile {
    [YLSdkLogAPI loginfo:@"stopPlayFile"];

    stopPlayFile();
}

+ (void)hangUp:(int)callid {
    [YLSdkLogAPI loginfo:@"hangUp"];

    hangup(callid);
}

+ (void)mute {
    [YLSdkLogAPI loginfo:@"mute"];

    mute();
}
+ (void)uMute {
    [YLSdkLogAPI loginfo:@"uMute"];

    umute();
}

+ (int)getVolumn {
    [YLSdkLogAPI loginfo:@"getVolumn"];

   return  getVolumn();
}
+ (void)setVolumn:(int)value {
    [YLSdkLogAPI loginfo:@"setVolumn"];

    return setVolumn(value);
}


+ (void)playDtmf:(NSString *)soundId {
    [YLSdkLogAPI loginfo:@"playDtmf"];

    unichar character = 0;
    [soundId getCharacters:&character];
    if (character) {
        playDtmf(character);
    }
}

+ (void)sendDtmfCallid:(int)callid soundId:(NSString *)soundId {
    [YLSdkLogAPI loginfo:@"sendDtmfCallid"];

    unichar character = 0;
    [soundId getCharacters:&character];
    if (character && callid > 0) {
        sendDtmf(callid, character);
    }
}
+ (NSString *)generateLogReportsPath {
    [YLSdkLogAPI loginfo:@"generateLogReportsPath"];

    return generateLogReports();
}

+ (void)disposeCrashReports {
    [YLSdkLogAPI loginfo:@"disposeCrashReports"];

    disposeCrashReports();
}

+ (void)setMyLayout:(VideoRenderIosView *)view viewId:(int)viewId eLayoutType:(int)eLayoutType {
    [YLSdkLogAPI loginfo:@"setMyLayout"];

    setLayout((__bridge void *)(view), viewId, eLayoutType);
}

+ (void)removeLayout:(VideoRenderIosView*)lpWin viewId:(int)viewID eLayoutType:(int)eLayoutType {
    [YLSdkLogAPI loginfo:@"removeMyLayout"];

    removeLayout((__bridge void *)(lpWin), viewID, eLayoutType);
}

+ (void)answer:(int) callId {
   [YLSdkLogAPI loginfo:@"answer"];

    answer(callId);
}

+ (void)switchCamear:(NSString *)camraSpecifier {
    [YLSdkLogAPI loginfo:@"switchCamear"];

    switchCamera(camraSpecifier);
}

+ (TalkStatistics *)getCallStatistics: (int)callid {
    [YLSdkLogAPI loginfo:@"getCallStatistics"];

    return getCallStatistics(callid);
}

+(int)makeCall:(int)iProtocol isVideo:(bool)bVideo callNumber:(NSString*)strNumber dialType:(int)iDialType
{
    [YLSdkLogAPI loginfo:@"makeCall"];

    return makeCall(iProtocol, bVideo, [strNumber UTF8String], iDialType);
}

+ (bool)isHasTalk
{
    [YLSdkLogAPI loginfo:@"isHasTalk"];

    return isHasTalk();
}

+ (void)audioEngineStatus:(bool)bRunning
{
    [YLSdkLogAPI loginfo:@"audioEngineStatus"];

    audioEngineStatus(bRunning);
}

+ (bool)muteVideo
{
    [YLSdkLogAPI loginfo:@"muteVideo"];
    return muteVideo();
}

+ (bool)unmuteVideo
{
    [YLSdkLogAPI loginfo:@"unmuteVideo"];

    return unmuteVideo();
}

+ (bool)isVideoTalking
{
    [YLSdkLogAPI loginfo:@"isVideoTalking"];

    return isVideoTalking();
}

+ (void)videoEngineStatus:(bool)bRunning
{
    [YLSdkLogAPI loginfo:@"videoEngineStatus"];

    videoEngineStatus(bRunning);
}

+ (void)updateCaptureOrientation:(int)iOrientation
{
    [YLSdkLogAPI loginfo:@"updateCaptureOrientation"];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        updateCaptureOrientation(iOrientation);
    });
}

+ (void)setAudioMode:(int) mode {
    [YLSdkLogAPI loginfo:@"setAudioMode"];

    setAudioMode(mode);
}

+ (bool)isDndOn
{
    [YLSdkLogAPI loginfo:@"isDndOn"];

    return isDndOn();
}

+ (bool)setDndOn
{
    [YLSdkLogAPI loginfo:@"setDndOn"];

    return setDndOn();
}

+ (bool)setDndOff
{
    [YLSdkLogAPI loginfo:@"setDndOff"];

    return setDndOff();
}

/**
 *  拒绝
 *
 *  @param iCallID 通话ID
 *
 *  @return true or false
 */
+ (bool)refuse:(int)iCallID
{
    [YLSdkLogAPI loginfo:@"refuse"];

    return refuse(iCallID);
}

/**
 *  获取当前使用摄像头
 *
 *  @return 当前摄像头显示名
 */
+ (NSString*)get_CurrentCamera
{
    [YLSdkLogAPI loginfo:@"get_CurrentCamera"];

    return getCurrentCamera();
}

/**
 *  重置摄像头
 */
+ (void)reset_Camera
{
    [YLSdkLogAPI loginfo:@"reset_Camera"];

    resetCamera();
}

/**
 *  发送DTMF信号
 *
 *  @param iCallID 通话ID
 *  @param cDtmf   DTMF 字符
 */
+ (void)sendDtmf:(int)iCallID cDtmf:(char)cDtmf
{
    [YLSdkLogAPI loginfo:@"sendDtmf"];

    sendDtmf(iCallID, cDtmf);
}

/**
 *  获取SIP帐号状态
 *
 *  @param idAccount account ID值
 *
 *  @return <#return value description#>
 */
+ (int)getSipAccountState:(int)idAccount
{
    [YLSdkLogAPI loginfo:@"getSipAccountState"];

    return getSipAccountState(idAccount);
}

/**
 *  获取H323帐号状态
 *
 *  @param idAccount account ID值
 *
 *  @return <#return value description#>
 */
+ (int)getH323AccountState:(int)idAccount
{
    [YLSdkLogAPI loginfo:@"getH323AccountState"];

    return getH323AccountState(idAccount);
}

/**
 *  获取通话数据
 *
 *  @param iCallID 通话ID
 *
 *  @return TalkData 自定义对象,表示通话信息体
 */
+ (TalkData*)getCallData:(int)iCallID
{
    [YLSdkLogAPI loginfo:@"getCallData"];

    return getCallData(iCallID);
}

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
+ (int)getIntConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey nDefault:(int)nDefaultValue
{
    [YLSdkLogAPI loginfo:@"getIntConfig"];

    return getIntConfig(strFile, strSection, strKey, nDefaultValue);
}

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
+ (bool)setIntConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey nValue:(int)nValue
{
    [YLSdkLogAPI loginfo:@"setIntConfig"];

    return setIntConfig(strFile, strSection, strKey, nValue);
}

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
+ (NSString*)getStringConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey strDefault:(NSString*)strDefaultValue
{
    [YLSdkLogAPI loginfo:@"getStringConfig"];

    return getStringConfig(strFile, strSection, strKey, strDefaultValue);
}

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
+ (bool)setStringConfig:(NSString*)strFile strSection:(NSString*)strSection strKey:(NSString*)strKey strDefault:(NSString*)strDefaultValue
{
    [YLSdkLogAPI loginfo:@"setStringConfig"];

    return setStringConfig(strFile, strSection, strKey, strDefaultValue);
}

/**
 *  获取本地IP地址
 *
 *  @return 本地IP地址字符串
 */
+ (NSString*)get_LocalIp
{
    [YLSdkLogAPI loginfo:@"get_LocalIp"];

    return getLocalIp();
}

/**
 *  获取摄像头列表
 *
 *  @return 获取摄像头列表("Back Camera","Front Camera")
 */
+ (NSMutableArray*)get_CameraList
{
    [YLSdkLogAPI loginfo:@"get_CameraList"];

    return getCameraList();
}

/**
 *  释放视频用于二次设置
 *  @param eLayoutType eLayoutType description
 */
+ (void)releaseLayout:(int)eLayoutType
{
    [YLSdkLogAPI loginfo:@"releaseLayout"];

    releaseLayout(eLayoutType);
}

/**
 *  用pin code登录云账号
 *  @param strPinCode pin code
 *  @return 是否处理成功
 */
+ (bool)asyncLoginByPinCode:(NSString*)strPinCode strServer:(NSString*)strServer
{
    [YLSdkLogAPI loginfo:@"asyncLoginByPinCode"];

    return asyncLoginByPinCode(strPinCode, strServer);
}

/**
 *  用用户名和密码登录云账号
 *  @param strNumber 云账号用户名
 *  @param strPassword 云账号密码
 *  @param bRememberPwd 云账号是否保存密码
 *  @return 是否处理成功
 */
+ (bool)asyncLoginByNumber:(NSString*)strNumber strPassword:(NSString*)strPassword bRememberPwd:(bool)bRememberPwd strServer:(NSString*)strServer
{
    [YLSdkLogAPI loginfo:@"asyncLoginByNumber"];

    return asyncLoginByNumber(strNumber, strPassword, bRememberPwd, strServer);
}

/** function
 *  @brief:使用用户名、密码、服务器、备份服务器登陆YMS
 *  @strNumber @in @brief:登陆账号
 *  @strPassword @in @brief:登陆密码
 *  @bRememberPwd @in @brief:是否保存密码
 *  @strServer @in @brief:登陆服务器
 *  @strProxyServer @in @brief:登陆备份服务器
 *  @return:是否可以登陆，注：该结果不是登陆结果，登陆结果有消息通知
 **/
+ (bool)asyncLoginPremise:(NSString*)strNumber strPassword:(NSString*)strPassword bRememberPwd:(bool)bRememberPwd strServer:(NSString*)strServer strProxyServer:(NSString*)strProxyServer
{
    [YLSdkLogAPI loginfo:@"asyncLoginPremise"];

    return asyncLoginPremise(strNumber, strPassword, bRememberPwd, strServer, strProxyServer);
}

/** function
 *  @brief:根据帐号获取云账号服务器
 *  @strAccountNumber @in @brief:YMS帐号
 *  @bPremise @in @brief:是否是YMS服务器
 *  @return:云账号服务器
 **/
+ (NSString*)getCloudServer:(NSString*)strAccountNumber isPremise:(bool)bPremise
{
    [YLSdkLogAPI loginfo:@"getCloudServer"];

    return getCloudServer(strAccountNumber, bPremise);
}

/** function
 *  @brief:根据帐号获取云账号备份服务器
 *  @strAccountNumber @in @brief:YMS帐号
 *  @bPremise @in @brief:是否是YMS备份服务器
 *  @return:云账号备份服务器
 **/
+ (NSString*)getCloudOutboundServer:(NSString*)strAccountNumber isPremise:(bool)bPremise
{
    [YLSdkLogAPI loginfo:@"getCloudOutboundServer"];

    return getCloudOutboundServer(strAccountNumber, bPremise);
}

/**
 *  同步上次云账号状态
 *  @return 是否处理成功
 */
+ (bool)sync_LastAccountState
{
    [YLSdkLogAPI loginfo:@"sync_LastAccountState"];

    return syncLastAccountState();
}

/**
 *  取消登录中的云账号
 */
+ (void)cancel_Login
{
    [YLSdkLogAPI loginfo:@"cancel_Login"];

    cancelLogin();
}

/** function
 *  @brief:获取保存的账号列表
 *  @bPremise @in @brief:是否是YMS账号列表，否则是云账号列表
 *  @return:保存的账号列表
 **/
+ (NSMutableArray*)getNumberList:(bool)bPremise
{
    [YLSdkLogAPI loginfo:@"getNumberList"];

    return getNumberList(bPremise);
}

/** function
 *  @brief:根据账号去除存储的登陆账号
 *  @strAccountNumber @in @brief:账号
 *  @bPremise @in @brief:是否是YMS账号，否则是云账号
 *  @return:是否删除成功
 *  @note:云账号和YMS账号共用该函数
 **/
+ (bool)deleteAccountByNumber:(NSString*)strAccountNumber bPremise:(bool)bPremise
{
    [YLSdkLogAPI loginfo:@"deleteAccountByNumber"];

    return deleteAccountByNumber(strAccountNumber, bPremise);
}

/**
 *  获取当前登录的云账号显示名
 *  @return 当前使用云账号的显示名
 */
+ (NSString*)get_CurrentNumber
{
    [YLSdkLogAPI loginfo:@"get_CurrentNumber"];

    return getCurrentNumber();
}

/** function
 *  @brief:获取当前账号状态
 *  @return:当前账号状态：0:None;1:logining;2:logined;3:disable;4:offline;
 *  @note:云账号和YMS账号共用该函数
 **/
+ (int)get_CurrentStatus
{
    [YLSdkLogAPI loginfo:@"get_CurrentStatus"];

    return getCurrentStatus();
}

/** function
 *  @brief:根据账号获取账号对应密码
 *  @strAccountNumber @in @brief:账号
 *  @bPremise @in @brief:是否是YMS账号，否则是云账号
 *  @return:账号对应密码
 *  @note:云账号和YMS账号共用该函数
 **/
+ (NSString*)getPasswordByNumber:(NSString*)strAccountNumber bPremise:(bool)bPremise
{
    [YLSdkLogAPI loginfo:@"getPasswordByNumber"];

    return getPasswordByNumber(strAccountNumber, bPremise);
}

/**
 *  获取云账号登录错误信息
 *  @return 云账号登录错误信息
 */
+ (NSString*)get_LastErrorMsg
{
    [YLSdkLogAPI loginfo:@"get_LastErrorMsg"];

    return getLastErrorMsg();
}

/** function
 *  @brief:获取账号登录错误信息
 *  @return:错误信息
 *  @note：云账号和YMS账号共用该函数
 **/
+ (int)get_LastErrorCode
{
    [YLSdkLogAPI loginfo:@"get_LastErrorCode"];

    return getLastErrorCode();
}

/** function
 *  @brief:当前使用的是否是YMS账号
 *  @return:当前使用的是否是YMS账号
 *  @note:云账号和YMS账号共用该函数
 **/
+ (bool)is_UsingYMSAccount
{
    [YLSdkLogAPI loginfo:@"is_UsingYMSAccount"];

    return isUsingYMSAccount();
}

/*获取云账户的状态
 *  @return 云账号登录状态
 */
+ (bool)is_CloudAccountRegister
{
    [YLSdkLogAPI loginfo:@"is_CloudAccountRegister"];

    return isCloudAccountRegister();
}
/*获取SIP的状态
 *  @return SIP登录状态
 */
+ (bool)is_SipAccountRegister
{
    [YLSdkLogAPI loginfo:@"is_SipAccountRegister"];

    return isSipAccountRegister();
}
/*获取h323的状态
 *  @return h323登录状态
 */
+ (bool)is_H323AccountRegister
{
    [YLSdkLogAPI loginfo:@"is_H323AccountRegister"];

    return isH323AccountRegister();
}

/*是否存在需要导出的Crash文件
 * @return 是否存在需要导出的Crash文件
 */
+ (bool)is_ExistCrashForReport
{
    [YLSdkLogAPI loginfo:@"is_ExistCrashForReport"];

    return isExistCrashForReport();
}

/*是否正在使用移动流量
 * @return 是否正在使用移动流量
 */
+ (bool)is_UsingMobileTraffic
{
    [YLSdkLogAPI loginfo:@"is_UsingMobileTraffic"];

    return isUsingMobileTraffic();
}

/* 设置是否关闭本地摄像头
 * bClose 是否关闭摄像头
 * @return 是否设置成功
 */
+ (bool)setCameraClose:(bool)bClose
{
    [YLSdkLogAPI loginfo:@"setCameraClose"];

    return setCameraClose(bClose);
}

/* 获取本地摄像头状态
 * @return 本地摄像头状态：0：摄像头正常工作；1：摄像头被关闭；2：摄像头Mute；3：摄像头不存在；4：摄像头开启失败
 */
+ (int)get_CameraState
{
    [YLSdkLogAPI loginfo:@"get_CameraState"];

    return getCameraState();
}

/** function
 *  @brief:设置设备Token
 *  @strDeviceToken @in @brief:设备标示
 * 
 **/
+ (void)setDeviceToken:(NSString*)strDeviceToken
{
    [YLSdkLogAPI loginfo:@"setDeviceToken"];

    setDeviceToken(strDeviceToken);
}

/**
 *  设置SIP帐号信息
 *
 *  @param idAccount     account ID
 *  @param pfile 自定义对象,表示sip帐号信息体
 */
+ (void) set_SipProfile: (int )idAccount pfile:(SipAccountProfile *) pfile {
    [YLSdkLogAPI loginfo:@"set_SipProfile"];

    setSipProfile(idAccount, pfile);
}

+ (SipAccountProfile *)get_SipProfile:(int)idAccount {
    [YLSdkLogAPI loginfo:@"get_SipProfile"];
    
    return getSipProfile(idAccount);
}

/** function
 *  @brief:json格式的rpc接口
 *  @strZipFile @in @brief:接口名和参数的json格式字符串
 *  @return:调用函数返回接口的json格式字符串
 **/
+ (NSString *)rpcCall:(NSString *)strInputJson {
    return rpc_call(strInputJson);
}

@end
