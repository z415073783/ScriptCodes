//
//  CallServerInterface.h
//  CallServer
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallServer.h"

@interface CallServerInterface : NSObject
@property (weak, nonatomic) id<CallServerProtocol> delegate;

+ (instancetype)sharedManager;
- (void)setDelegate:(id<CallServerProtocol>) delegate;
- (YLSdkReturnResult *)clickType:(iclickType)iType respon:(YLSdkRespon *)respon;
- (void)registerChange;
@end
