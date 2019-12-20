//
//  CallServerInterface.m
//  CallServer
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 yealink. All rights reserved.
//

#import "CallServerInterface.h"

@interface CallServerInterface()
@end

@implementation CallServerInterface

static CallServerInterface *instance = nil;

+(instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (void)setDelegate:(id<CallServerProtocol>) delegate {
    _delegate  = delegate;
}

- (YLSdkReturnResult *)clickType:(iclickType)iType respon:(YLSdkRespon *)respon {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ylSdkListener:returnObject:)]) {
        return  [_delegate ylSdkListener:iType returnObject:respon];
    } else {
        YLSdkReturnResult * result =  [[YLSdkReturnResult alloc] init];
        result.handleType = unknow;
        result.handleReuslt = false;
        return result;
    }
}
- (void)registerChange {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(registerStateChange)]) {
        [_delegate registerStateChange];
    }
}
@end
