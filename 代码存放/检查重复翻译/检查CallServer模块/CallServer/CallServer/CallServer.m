//
//  CallServer.m
//  CallServer
//
//  Created by Apple on 2017/10/11.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import "CallServer.h"
#import "CallServer-Swift.h"
#import <UIKit/UIKit.h>
#import "CallServerInterface.h"
#import "YLConfAPI.h"
#import "YLLogicAPI.h"
#import "LogicService.h"
#import "YLServiceAPI.h"
#import "LogicInterface.h"
#import "YLContactAPI.h"
#import "YLSdkLogAPI.h"
@implementation CallServer 

+ (void)startTalkService {
    [[YLCallServerManager getInstance] createService];
    [[AudioRouteManager getInstance] addListener];
    [[RegisterManager getInstance] addListener];
    [YLServiceAPI initService];
    [YLSDKLanguageManager getSystemLanguage];
}


+ (void)registerSip:(regAccountProfile*)pfile {
//    SipAccountProfile *file =  getSipProfile(1);
//    file.m_bEnable = pfile.m_bEnable;
//    file.m_strRegisterName  = pfile.m_strRegisterName;
//    file.m_strUserName = pfile.m_strUserName;
//    file.m_strDisplayName = pfile.m_strDisplayName;
//    file.m_strAuthName = pfile.m_strAuthName;
//    file.m_strPassword = pfile.m_strPassword;
//    file.m_strServer = pfile.m_strServer;
//    file.m_iPort = pfile.m_iPort;
//    file.m_bEnableOutbound = pfile.m_bEnableOutbound;
//    file.m_strOutboundServer = pfile.m_strOutboundServer;
//    file.m_iOutboundPort =  pfile.m_iOutboundPort;
//    file.m_iTransPort = pfile.m_iTransfer;
//    setSipProfile(1, file);
    
    [SettingManager writeSIPDataWithSender:pfile];
}

+ (void)registerH323:(regAccountProfile*)pfile {
    [SettingManager writeH323DataWithSender:pfile];
}

+ (void)registerCloudPinCode:(NSString *)pinCode
                      server:(NSString *)server {
    [YLLogicAPI asyncLoginByPinCode:pinCode
                        strServer:server];
}

+ (void)registerYms:(NSString *)username
           password:(NSString *)password
             server:(NSString *)server
        proxyServer:(NSString *)proxyServer {
    
    [YLLogicAPI asyncLoginPremise:username
                    strPassword:password
                   bRememberPwd:false
                      strServer:server
                 strProxyServer:proxyServer];
}

+ (void)registerCloud:(NSString *)username
           password:(NSString *)password
             server:(NSString *)server {
    if (server == nil || [server isEqualToString:@""]) {
        server = @"yealinkvc.com";
    }
    
    [YLLogicAPI asyncLoginByNumber:username
                     strPassword:password
                    bRememberPwd:false
                       strServer:server];
}

+(BOOL)sipRegisterState {
    return [YLLogicAPI is_SipAccountRegister];
}

+(BOOL)h323RegisterState {
   return [YLLogicAPI is_H323AccountRegister];
}

+(BOOL)cloudRegisterState{
    if ([YLLogicAPI is_UsingYMSAccount]) {
        return  false;
    } else {
       return [YLLogicAPI is_CloudAccountRegister];
    }
}

+(BOOL)ymsRegisterState {
    if ([YLLogicAPI is_UsingYMSAccount]) {
        return  [YLLogicAPI is_CloudAccountRegister];
    } else {
        return false;
    }
}

+(void)unRegisterYms {
    [YLLogicAPI  cancel_Login];
}

+(void)unRegisterCloud {
    [YLLogicAPI  cancel_Login];
}

+(void)unRegisterSip {
    [SettingManager unregisterSip];
//    [SettingManager un];
}

+ (void)stopTalkService {
    [[AudioRouteManager getInstance] removeListener];
    [[YLCallServerManager getInstance] unRegisterService];
    StopLogicService();
}

+ (void)call:(NSString*)number type:(icallType)callType protol:(icallprotol) protol {
    [[YLCallServerManager getInstance] ocMakeCallWithNumber:number callType:callType protol:protol];
}

+ (void)call:(NSString*)number type:(icallType)callType {
    [CallServer call:number type:callType protol:autoProtol];
}

+ (void)call:(NSString*)number {
    [CallServer call:number type:video protol:autoProtol];
}

+ (void)meetingNow:(NSArray<NSString*>*) numberList type:(icallType)callType {
    [[YLCallServerManager getInstance] ocMeetingNowWithNumberList:numberList callType:callType];
}
+ (NSArray <MeetingDate *>*)getMeetingList {
    NSArray *listMeetingSchedule = [YLConfAPI getMeetingScheduleInfoList];
    
    NSMutableArray <MeetingDate *>* returnArray = [NSMutableArray new];
    if (listMeetingSchedule == nil || listMeetingSchedule.count == 0) {
        return [NSArray new];
    } else {
        for (IMeetingScheduleInfo *meetItem  in listMeetingSchedule) {
            MeetingDate *meetDate =  [[MeetingDate alloc] init];
            meetDate.strConferenceNumber = meetItem.m_tDescript.m_strNumber;
            meetDate.strUri = meetItem.m_tDescript.m_strFocusUri;
            meetDate.strSubject = meetItem.m_tDescript.m_strSubject;
            meetDate.meetingId = meetItem.m_tSchedule.m_strMeetingId;
            meetDate.beginTime =  meetItem.m_tSchedule.m_timeBegin;
            meetDate.endTime =  meetItem.m_tSchedule.m_timeEnd;
            [returnArray addObject:meetDate];
        }
        return returnArray;
    }
}

+ (void)joinMeeting:(NSString*)strConferenceNumber
             strUri:(NSString*)strUri
         strSubject:(NSString*)strSubject
          meetingId:(NSString*)meetingId {
    [[YLCallServerManager getInstance] ocJoinMettingWithStrConferenceNumber:strConferenceNumber strUri:strUri strSubject:strSubject meetingId:meetingId];
}

+ (void)joinMeetingWithOutLoging:(YlLogingOutJoinMeetingModel*) model {
    [[YLCallServerManager getInstance] ocJoinMeetingNoLoginWithModel:model];
}

+ (void)inviteMember:(NSArray<NSString*>*)inviteMembers {
    [[YLCallServerManager getInstance] inviteToMeetingWithListInviteMember:inviteMembers];

}

+ (void)setBackgroundStatus:(BOOL)flag {
    [YLServiceAPI setBackgroundStatus:flag];
}

// inner
+ (int) getCallId {
    NSInteger callID = [[CallServerDataSource getInstance] getCallId];
    
    if (callID) {
        return (int)callID;
    } else {
        return 0;
    }
}

+ (void)setDelegate:(id<CallServerProtocol>) delegate {
    [[CallServerInterface sharedManager] setDelegate:delegate];
}

+ (void)switchCamera:(interFacehandle) finishblock {
        [[CallServerDeviceSource getInstance]switchCamearWithBlock:^{
            if (finishblock != nil) {
                finishblock();
            }
        }];
}

+ (BOOL)enableRotation {
    return [[RotationManager getInstance] enableRotation];
}

+ (BOOL)isHasTalk {
    return [YLLogicAPI isHasTalk];
}
    
- (void)test {
    CallTest * call = [[CallTest alloc] init];
    [call createService];
}
    

+ (UIInterfaceOrientationMask)getSuggestOrientation {
    return [[RotationManager getInstance] currentOrientationType];
}

+ (UIViewController*) getCallViewController {
   return  [[YLCallServerManager getInstance] getCallViewController];
}

+ (NSArray *) getmeetingMemberArray {
    NSInteger callID =  [[CallServerDataSource getInstance] getCallId];
    if (callID > 0) {
        return  [YLConfAPI getMemberList:callID];
    }
    return [NSArray new];
}

+ (NSString *) getRemoteName {
    NSString * name = [[CallServerDataSource getInstance] getRemoteName];
    if(name == nil || [name isEqualToString:@""]) {
        name = [[CallServerDataSource getInstance] getCallIPOrName];
    }
   return name ;
}

+ (void)registerVoip {
    [[VoIPPushManager default] registerVoIPNotification];
}
    
- (BOOL)openRotation {
    return  false;
}
+ (cloudOrgType)getCloudContactType {
    int flag = [YLContactAPI get_CloudDirType];
    switch (flag) {
        case 0:
            return cloudknow;
            break;
        case 1:
            return cloudGeneral;
            break;
        case 2:
            return cloudOrg;
            break;
            
        default:
            return cloudOrg;
            break;
    }
    return cloudGeneral;
}

+ (NSArray <YlCloudContactDate*>*)getNormalContactsList:(NSString *) key {
    NSMutableArray * memberList = [YLContactAPI searchCloudContact:key];
    NSMutableArray <YlCloudContactDate*>* returnAray = [NSMutableArray new];
    for (IPhoneBookData *bookdata in memberList) {
        IDataContact* contact = [YLContactAPI toCloudContactData:bookdata];
        YlCloudContactDate* retrunContact =  [[YlCloudContactDate alloc] init];
        NSString *realNumber = @"";
        if (contact.m_listNumber != nil && contact.m_listNumber.count > 0) {
            IPhoneNumPair* numberPair = [contact.m_listNumber  firstObject];
            realNumber = numberPair.m_strNum;
        }
        retrunContact.username = contact.m_strDisplayName;

        retrunContact.userid = realNumber;
        retrunContact.usernumber = realNumber;
        [returnAray addObject:retrunContact];
    }
    return returnAray;
}

+ (OrgTreeInfo*) getOrgNodeInfo:(NSString *) realKey {
    if (realKey == nil)  {
        realKey = @"";
    }
    IOrgTreeInfo* node =  [YLContactAPI getOrgNodeInfo:realKey];
    if ([realKey isEqualToString:@""]) {
        //根目录
        for (IOrgTreeInfo*subNode in node.m_listChildren) {
            if ([subNode.m_strName containsString:@"vmr.root"]) {
                subNode.m_strName = @"虚拟会议设备";
            } else if ([subNode.m_strName containsString:@"device.root"]) {
                subNode.m_strName = @"硬件会议室设备";
            } else if ([subNode.m_strName containsString:@"staff.root"]) {
                subNode.m_strName = @"组织架构";
            }
        }
    }
    OrgTreeInfo * returnNode = [CallServer getnodeForINode:node];
    return returnNode;
}

+ (OrgTreeInfo*) getnodeForINode:(IOrgTreeInfo*)node {
    OrgTreeInfo * returnNode = [[OrgTreeInfo alloc] init];
    returnNode.m_strId = node.m_strId;
    returnNode.m_iLeavesNum = node.m_iLeavesNum;
    returnNode.m_iType = node.m_iType;
    returnNode.m_strParentId = node.m_strParentId;
    returnNode.m_strName = node.m_strName;
    returnNode.m_strNamePinyin = node.m_strNamePinyin;
    returnNode.m_strNamePinyinAlia = node.m_strNamePinyinAlia;
    returnNode.m_iIndex = node.m_iIndex;
    returnNode.m_strEmail = node.m_strEmail;
    returnNode.m_strNumber = node.m_strNumber;
    returnNode.m_strExtension = node.m_strExtension;
    returnNode.m_strId = node.m_strId;
    returnNode.m_listChildren = [NSMutableArray new];
    for (IOrgTreeInfo* subNode in node.m_listChildren) {
        OrgTreeInfo *node = [CallServer getnodeForINode:subNode];
        [returnNode.m_listChildren addObject:node];
    }
    return returnNode;
}
    
+ (void) writeLogToSDK:(NSString *)logString {
    [YLSdkLogAPI loginfo:logString];
}

@end
