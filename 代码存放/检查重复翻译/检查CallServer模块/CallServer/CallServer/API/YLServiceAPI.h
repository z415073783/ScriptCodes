//
//  UCServiceInterface.h
//  Odin-UC
//
//  Created by 姜祥周 on 16/12/23.
//  Copyright © 2016年 yealing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLServiceAPI : NSObject
+(void)initService;
+(void)unInitService;
+(void)setBackgroundStatus:(bool)bBackground;

/** function
 *  @brief:设置软件转前台是否需要重新注册帐号
 *  @strCallID @NSString 通话id
 *
 **/
+ (void)setRegisterAccount:(NSString*)strCallID;
@end
