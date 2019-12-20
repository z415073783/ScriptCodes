//
//  CallStateManager.m
//  Odin-UC
//
//  Created by Apple on 05/01/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

#import "CallStateMachine.h"
NSString *const InitSucessEvent = @"YLInitSucessEvent";
NSString *const InitFailedEvent = @"YLInitFailedEvent";
NSString *const IncomingCallEvent = @"YLIncomingCallEvent";
NSString *const OutgoingCallEvent = @"YLOutgoingCallEvent";
NSString *const WaitingAnswerEvent = @"YLWaitingAnswerEvent";

NSString *const RingbackEvent = @"YLRingbackEvent";
NSString *const AnswerEvent = @"YLAnswerCallEvent";
NSString *const RejectEvent = @"YLRejectCallEvent";
NSString *const EstablishedEvent = @"YLEstablishedEvent";
NSString *const OnTalkingEvent = @"YLOnTalkingEvent";

NSString *const ClearCallEvent = @"YLClearCallEvent";
NSString *const FinishEvent = @"YLFinishEvent";
NSString *const ToIdleEvent = @"YLToIdleEvent";
NSString *const ShowResultEvent = @"YLShowResultEvent";
NSString *const DisconnectedEvent = @"YLDisconnectedEvent";

NSString *const EstablishedFailedEvent = @"YLEstablishedFailedEvent";
NSString *const OccurErrorEvent = @"YLOccurErrorEvent";



NSString *const InitialState = @"YLInitializeState";
NSString *const IdleState = @"YLIdleState";
NSString *const IncomingState = @"YLIncomingCallState";
NSString *const OutgoingState = @"YLOutgoingCallState";
NSString *const WaitingEstablishedState = @"YLWaitingEstablishedState";

NSString *const WaitingAnswerState = @"YLWaitingAnswerState";
NSString *const RingbackState = @"YLRingbackState";
NSString *const EstablishedState = @"YLTalkEstablishedState";
NSString *const OnTalkingState = @"YLOnTalkingState";
NSString *const ClearCallState = @"YLClearCallState";


NSString *const TalkFinishState = @"YLTalkFinishState";
NSString *const ShowResultState = @"YLShowCallResultState";
NSString *const DisconnectedState = @"YLDisconnectedState";
NSString *const EstablishedFailedState = @"YLEstablishedFailedState";
NSString *const OccurErrorState = @"YLOccurErrorState";

NSString *const InitErrorState = @"YLInitErrorState";

@implementation CallStateMachine
- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.stateMachine = [TKStateMachine new];
    
    // initState
    TKState *_initialState = [TKState stateWithName:InitialState];
    TKState *_idleState = [TKState stateWithName:IdleState];
    TKState *_incomingState = [TKState stateWithName:IncomingState];
    TKState *_outgoingState = [TKState stateWithName:OutgoingState];
    TKState *_waitingEstablishedState = [TKState stateWithName:WaitingEstablishedState];
    
    TKState *_waitingAnswerState = [TKState stateWithName:WaitingAnswerState];
    TKState *_ringbackState = [TKState stateWithName:RingbackState];
    TKState *_establishedState = [TKState stateWithName:EstablishedState];
    TKState *_onTalkingState= [TKState stateWithName:OnTalkingState];
    TKState *_clearCallState = [TKState stateWithName:ClearCallState];
    
    TKState *_talkFinishState = [TKState stateWithName:TalkFinishState];
    TKState *_showResultState = [TKState stateWithName:ShowResultState];
    TKState *_disconnectedState = [TKState stateWithName:DisconnectedState];
    TKState *_establishedFailedState = [TKState stateWithName:EstablishedFailedState];
    TKState *_occurErrorState = [TKState stateWithName:OccurErrorState];
    
    TKState *_initErrorState = [TKState stateWithName:InitErrorState];
    
    NSArray *_states = @[
                         _initialState,
                         _idleState,
                         _incomingState,
                         _outgoingState,
                         _waitingEstablishedState,
                         
                         _waitingAnswerState,
                         _ringbackState,
                         _establishedState,
                         _onTalkingState,
                         _clearCallState,
                         
                         _talkFinishState,
                         _showResultState,
                         _disconnectedState,
                         _establishedFailedState,
                         _occurErrorState,
                         
                         _initErrorState,
                         ];
    
    [self.stateMachine addStates:_states];
    self.stateMachine.initialState = _initialState;
    
    TKEvent *initSucessEvent = [TKEvent eventWithName:InitSucessEvent
                              transitioningFromStates:@[_initialState]
                                              toState:_idleState];
    TKEvent *initFailedEvent = [TKEvent eventWithName:InitFailedEvent
                              transitioningFromStates:@[_initialState]
                                              toState:_initErrorState];
    TKEvent *incomingCallEvent = [TKEvent eventWithName:IncomingCallEvent
                                transitioningFromStates:@[_idleState, _showResultState]
                                                toState:_incomingState];
    TKEvent *outgoingCallEvent = [TKEvent eventWithName:OutgoingCallEvent
                                transitioningFromStates:@[_idleState]
                                                toState:_outgoingState];
    TKEvent *waitingAnswerEvent = [TKEvent eventWithName:WaitingAnswerEvent
                                 transitioningFromStates:@[_incomingState]
                                                 toState:_waitingAnswerState];
    
    
    TKEvent *ringbackEvent = [TKEvent eventWithName:RingbackEvent
                            transitioningFromStates:@[_outgoingState]
                                            toState:_ringbackState];
    
    TKEvent *answerEvent = [TKEvent eventWithName:AnswerEvent
                          transitioningFromStates:@[_waitingAnswerState]
                                          toState:_waitingEstablishedState];
    
    TKEvent *rejectEvent = [TKEvent eventWithName:RejectEvent
                          transitioningFromStates:@[_waitingAnswerState]
                                          toState:_clearCallState];
    
    TKEvent *establishedEvent = [TKEvent eventWithName:EstablishedEvent
                               transitioningFromStates:@[_waitingEstablishedState, _ringbackState,_idleState,_outgoingState,_incomingState,_onTalkingState,_establishedState]
                                               toState:_establishedState];
    TKEvent *establishedFailedEvent = [TKEvent eventWithName:EstablishedFailedEvent
                                     transitioningFromStates:@[ _waitingEstablishedState ]
                                                     toState:_establishedFailedState];
    
    TKEvent *onTalkingEvent = [TKEvent eventWithName:OnTalkingEvent
                             transitioningFromStates:@[ _establishedState,_disconnectedState ]
                                             toState:_onTalkingState];
    
    TKEvent *clearCallEvent = [TKEvent eventWithName:ClearCallEvent
                             transitioningFromStates:@[
                                                       _incomingState,
                                                       _outgoingState,
                                                       _ringbackState,
                                                       _waitingAnswerState,
                                                       _waitingEstablishedState,
                                                       _establishedFailedState,
                                                       _disconnectedState,
                                                       ]toState:_clearCallState];
    
    TKEvent *finishEvent = [TKEvent eventWithName:FinishEvent
                          transitioningFromStates:@[
                                                    _idleState,
                                                    _incomingState,
                                                    _outgoingState,
                                                    _ringbackState,
                                                    _waitingAnswerState,
                                                    _waitingEstablishedState,
                                                    _establishedState,
                                                    _establishedFailedState,
                                                    _onTalkingState,
                                                    _clearCallState,
                                                    _disconnectedState,
                                                    _occurErrorState
                                                    ] toState:_talkFinishState];
    
    TKEvent *toIdleEvent = [TKEvent eventWithName:ToIdleEvent
                          transitioningFromStates:@[
                                                    _talkFinishState,
                                                    _clearCallState,
                                                    _occurErrorState,
                                                    _disconnectedState
                                                    ]toState:_idleState];
    
    TKEvent *disconnectedEvent = [TKEvent eventWithName:DisconnectedEvent
                                transitioningFromStates:nil
                                                toState:_disconnectedState];
    
    TKEvent *occurErrorEvent = [TKEvent eventWithName:OccurErrorEvent
                              transitioningFromStates:nil
                                              toState:_occurErrorState];
    
    NSArray *talkEvents = @[
                            initSucessEvent,
                            initFailedEvent,
                            incomingCallEvent,
                            outgoingCallEvent,
                            waitingAnswerEvent,
                            establishedEvent,
                            ringbackEvent,
                            answerEvent,
                            rejectEvent,
                            onTalkingEvent,
                            clearCallEvent,
                            finishEvent,
                            toIdleEvent,
                            disconnectedEvent,
                            establishedFailedEvent,
                            occurErrorEvent
                            ];
    [self.stateMachine addEvents:talkEvents];
    [self.stateMachine activate];
    NSLog(@"stateMachine create succeed");
}

#pragma mark - Publick Method
- (BOOL)canFireEvent:(NSString *)eventName {
    return [self.stateMachine canFireEvent:eventName];
}

- (BOOL)fireEvent:(NSString *)eventName
         userInfo:(NSDictionary *)userInfo {
    NSError *error;
    BOOL bRes =
    [self.stateMachine fireEvent:eventName
                        userInfo:userInfo
                           error:&error];
    if (!bRes) {
        NSLog(@"fireEvent  name:%@ error:%@", eventName,[error localizedDescription]);
    }
    
    printf("fireEvent eventName:%s ",[eventName UTF8String]);
//    NSLog(@"fireEvent eventName:%@ info:%@",eventName,userInfo);
    return bRes;
    
}
- (BOOL)isEqualState:(NSString *)state {
    return [self.stateMachine.currentState.name isEqualToString:state];
}

@end
