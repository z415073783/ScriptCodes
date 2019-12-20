//
//  CallServerObject.m
//  CallServer
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import "CallServerObject.h"

@implementation CallServerObject

@end

@implementation regAccountProfile
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}
-(void)setDefaultValue
{
    _m_bEnable = false;
    _m_strDisplayName = @"";
    _m_strUserName = @"";
    _m_strRegisterName = @"";
    _m_strPassword = @"";
    _m_strServer = @"";
    _m_iPort = 5060;
    _m_iTransfer = 1;
    _m_bBFCP = true;
    _m_bEnableOutbound = 0;
    _m_strOutboundServer = @"";
    _m_iOutboundPort = 5060;
    _m_bEnableStun = 0;
    _m_strStunServer = @"";
    _m_iStunPort = 3478;
    _m_iNATType = 0;
    _m_iSRTP = 0;
    _m_iDTMFType = 1;
    _m_iDTMFInfoType = 1;
    _m_iDTMFPayload = 101;
}

@end

@implementation YLSdkRespon
- (instancetype)init {
    self = [super init];
    if (self) {
        _shareString = @"";
    }
    return self;
}
@end

@implementation YLSdkReturnResult

@end

@implementation MeetingDate

@end

@implementation YlCloudContactDate


@end
@implementation OrgTreeInfo : NSObject
@end


@implementation YlLogingOutJoinMeetingModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}
-(void)setDefaultValue
{
    _confID = @"";
    _password = @"";
    _strName = @"";
    _strServer = @"";
    _bOpenMic = true;
    _bOpenCamera = true;

}

@end
