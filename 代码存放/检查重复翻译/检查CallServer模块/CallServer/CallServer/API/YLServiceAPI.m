//
//  UCServiceInterface.m
//  Odin-UC
//
//  Created by 姜祥周 on 16/12/23.
//  Copyright © 2016年 yealing. All rights reserved.
//

#import "YLServiceAPI.h"
#import "LogicService.h"
#import "YLSdkLogAPI.h"


@implementation YLServiceAPI

+(void)initService
{
    NSString *bundlePath =
    [[NSBundle mainBundle] pathForResource:@"yealink" ofType:@"bundle"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *strDocPath = [paths lastObject];
    NSString *strUDID = [[NSUUID UUID] UUIDString];
    SyncConfig([bundlePath UTF8String], [strDocPath UTF8String],
               [[strUDID stringByReplacingOccurrencesOfString:@"-" withString:@""] UTF8String]);
    NSLog(@"---------- StartLogicService begin ----------");
    StartLogicService();
    NSLog(@"---------- StartLogicService end ----------");
    [YLSdkLogAPI loginfo:@"initService"];
}

+(void)unInitService
{
    StopLogicService();
    [YLSdkLogAPI loginfo:@"unInitService"];
}

+(void)setBackgroundStatus:(bool)bBackground
{
    [YLSdkLogAPI loginfo:@"setBackgroundStatus"];

    setBackgroundStatus(bBackground);
}

/** function
 *  @brief:设置软件转前台是否需要重新注册帐号
 *  @strCallID @NSString @brief:通话id
 *  @return:
 **/
+ (void)setRegisterAccount:(NSString*)strCallID;
{
    [YLSdkLogAPI loginfo:@"setRegisterAccount"];
    setRegisterAccount(strCallID);
}

@end
