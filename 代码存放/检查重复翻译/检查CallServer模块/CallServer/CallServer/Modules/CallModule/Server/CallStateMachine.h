//
//  CallStateManager.h
//  Odin-UC
//
//  Created by Apple on 05/01/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionKit.h"

extern NSString *const InitSucessEvent;
extern NSString *const InitFailedEvent;
extern NSString *const IncomingCallEvent;
extern NSString *const OutgoingCallEvent;
extern NSString *const WaitingAnswerEvent;

extern NSString *const RingbackEvent;
extern NSString *const AnswerEvent;
extern NSString *const RejectEvent;
extern NSString *const EstablishedEvent;
extern NSString *const OnTalkingEvent;

extern NSString *const ClearCallEvent;
extern NSString *const FinishEvent;
extern NSString *const ToIdleEvent;
extern NSString *const ShowResultEvent;
extern NSString *const EstablishedFailedEvent;

extern NSString *const DisconnectedEvent;
extern NSString *const OccurErrorEvent;


extern NSString *const InitialState;
extern NSString *const IdleState;
extern NSString *const IncomingState;
extern NSString *const OutgoingState;
extern NSString *const WaitingEstablishedState;

extern NSString *const WaitingAnswerState;
extern NSString *const RingbackState;
extern NSString *const EstablishedState;
extern NSString *const OnTalkingState;
extern NSString *const ClearCallState;


extern NSString *const TalkFinishState;
extern NSString *const ShowResultState;
extern NSString *const DisconnectedState;
extern NSString *const EstablishedFailedState;
extern NSString *const OccurErrorState;

extern NSString *const InitErrorState;

@interface CallStateMachine : NSObject

@property (nonatomic, strong) TKStateMachine *stateMachine;
- (BOOL)canFireEvent:(NSString *)eventName;
- (BOOL)fireEvent:(NSString *)eventName
         userInfo:(NSDictionary *)userInfo;
- (BOOL)isEqualState:(NSString *)state;
@end
