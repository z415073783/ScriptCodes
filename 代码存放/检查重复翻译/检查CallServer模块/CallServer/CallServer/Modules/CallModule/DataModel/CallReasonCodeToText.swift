//
//  CallReasonCodeToText.swift
//  CallServer
//
//  Created by Apple on 2017/12/1.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class ReturnText:NSObject {
    var mainTitle = ""
    var subtitle = ""
}
class CallReasonCodeToText: NSObject {
    
    class func getCallReasonCodeText(resultCode: Int) -> String {
        if  resultCode == CallFinishResonCode.noError.rawValue {
            return ""
        } else if resultCode ==  CallFinishResonCode.sipH323.rawValue {
            return ""
        } else if resultCode ==  CallFinishResonCode.localEndHangupTheSession2.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else if resultCode ==  CallFinishResonCode.localEndHangupTheSession3.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else if resultCode ==  CallFinishResonCode.timeouted.rawValue {
            return  YLSDKLanguage.YLSDKtimeOuted
        } else if resultCode ==  CallFinishResonCode.sessionOverFlow.rawValue {
            return YLSDKLanguage.YLSDKsessionOverFlow
        } else if resultCode ==  CallFinishResonCode.unkownProtocol.rawValue {
            return YLSDKLanguage.YLSDKunkownProtocol
        } else if resultCode ==  CallFinishResonCode.uoUsableAccount.rawValue {
            return YLSDKLanguage.YLSDKnoUsableAccount
        } else if resultCode ==  CallFinishResonCode.crashed.rawValue {
            return YLSDKLanguage.YLSDKCallCrashed
        } else if resultCode ==  CallFinishResonCode.networkError.rawValue {
            return YLSDKLanguage.YLSDKNetworkError
        } else if resultCode ==  CallFinishResonCode.unkownError.rawValue {
            return YLSDKLanguage.YLSDKunkownError
        } else {
            return YLSDKLanguage.YLSDKUnknownType
        }
    }
    
    class func getFinishNoErrorCode(finishCode: Int) -> String {
        
        switch finishCode {
        case FinishNoErrorCode.localEndHangupTheSession.rawValue:
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
            
        case FinishNoErrorCode.sipEndedByForbidden.rawValue:
            return YLSDKLanguage.YLSDKSipEndedByForbidden
            
        case FinishNoErrorCode.sipEndedByNotFound.rawValue:
            return YLSDKLanguage.YLSDKSipEndedByNotFound
            
        case FinishNoErrorCode.sipEndedByRequestTimeOut.rawValue:
            return YLSDKLanguage.YLSDKSipEndedByRequestTimeOut
            
        case FinishNoErrorCode.ipRemoteEnd.rawValue:
            return YLSDKLanguage.YLSDKRemoteEndHangupTheSession
            
        case FinishNoErrorCode.remoteEndHangupTheSession.rawValue:
            return YLSDKLanguage.YLSDKRemoteEndHangupTheSession
            
        case FinishNoErrorCode.dnd.rawValue:
            return "DND" 
            
        case FinishNoErrorCode.talkFinishNetworkBroken.rawValue:
            return YLSDKLanguage.YLSDKTalkFinishNetworkBroken
            
        case FinishNoErrorCode.userNotRegister.rawValue:
            return YLSDKLanguage.YLSDKuserNotRegister
            
        case FinishNoErrorCode.mediaNegotiateFail.rawValue:
            return YLSDKLanguage.YLSDKMediaNegotiateFail
            
        case FinishNoErrorCode.ignoreCallOrForceRejectByPeer.rawValue:
            return YLSDKLanguage.YLSDKIgnoreCallOrForceRejectByPeer
            
        case FinishNoErrorCode.completedElsewhere.rawValue:
            return YLSDKLanguage.YLSDKCompletedElsewhere
            
        case FinishNoErrorCode.talkFinishAudioHasError.rawValue:
            return YLSDKLanguage.YLSDKTalkFinishAudioHasError
            
        case FinishNoErrorCode.conferenceUriUnknown.rawValue:
            return YLSDKLanguage.YLSDKConferenceUriUnknown
            
        case FinishNoErrorCode.conferenceLocked.rawValue:
            return YLSDKLanguage.YLSDKConferenceLocked
            
        case FinishNoErrorCode.conferenceUserCountExceed.rawValue:
            return YLSDKLanguage.YLSDKConferenceUserCountExceed
            
        case FinishNoErrorCode.conferenceUserDuplicate.rawValue:
            return YLSDKLanguage.YLSDKConferenceUserDuplicate
            
        case FinishNoErrorCode.youAreRemovedFromTheConference.rawValue:
            return YLSDKLanguage.YLSDKYouHaveBeenRemovedFromTheConference
            
        case FinishNoErrorCode.conferenceIsEndedByModerator.rawValue:
            return YLSDKLanguage.YLSDKConferenceHasBeenEndedByModerator
            
        default:
            return  "reason code 0 and finishCode:" + String(finishCode)
            
        }
    }
    
    class func getFinishSIPCode(finishCode: Int) -> String {
        if  finishCode == VoipSIPCallEndReasonCode.unknownReason.rawValue {
            return ""
        } else if finishCode ==  VoipSIPCallEndReasonCode.unknownUriScheme.rawValue {
            return YLSDKLanguage.YLSDKUnknownURIScheme
        } else if finishCode ==  VoipSIPCallEndReasonCode.badRequest.rawValue {
            return YLSDKLanguage.YLSDKBadRequest
        } else if finishCode ==  VoipSIPCallEndReasonCode.forbidden.rawValue {
            return YLSDKLanguage.YLSDKCallForbidden
        } else if finishCode ==  VoipSIPCallEndReasonCode.notFound.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointNotFound
        } else if finishCode ==  VoipSIPCallEndReasonCode.methodNotAllowed.rawValue {
            return YLSDKLanguage.YLSDKMethodNotAllowed
        } else if finishCode ==  VoipSIPCallEndReasonCode.notAcceptable.rawValue {
            return YLSDKLanguage.YLSDKNotAcceptable
        } else if finishCode ==  VoipSIPCallEndReasonCode.requestTimeOut.rawValue {
            return YLSDKLanguage.YLSDKRequestTimeOut
        } else if finishCode ==  VoipSIPCallEndReasonCode.unsupportedMediaType.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointUnsupportedMediaType
        } else if finishCode ==  VoipSIPCallEndReasonCode.unsupportedUriScheme.rawValue {
            return YLSDKLanguage.YLSDKUnsupportedURIScheme
        } else if finishCode ==  VoipSIPCallEndReasonCode.badExtension.rawValue {
            return YLSDKLanguage.YLSDKBadRequest
        } else if finishCode ==  VoipSIPCallEndReasonCode.anonymityDisallowed.rawValue {
            return YLSDKLanguage.YLSDKAnonymityDisallowed
        } else if finishCode ==  VoipSIPCallEndReasonCode.temporarilyUnavailable.rawValue {
            return YLSDKLanguage.YLSDKTemporarilyUnavailable
        } else if finishCode ==  VoipSIPCallEndReasonCode.callTransactionDoesNotExist.rawValue {
            return YLSDKLanguage.YLSDKCallTransactionDoesNotExist
        } else if finishCode ==  VoipSIPCallEndReasonCode.loopDetected.rawValue {
            return YLSDKLanguage.YLSDKLoopDetected
        } else if finishCode ==  VoipSIPCallEndReasonCode.busyHere.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointBusy
        } else if finishCode ==  VoipSIPCallEndReasonCode.notAcceptableHere.rawValue {
            return YLSDKLanguage.YLSDKNotAcceptable
        } else if finishCode ==  VoipSIPCallEndReasonCode.badEvent.rawValue {
            return YLSDKLanguage.YLSDKBadRequest
        } else if finishCode ==  VoipSIPCallEndReasonCode.requestPending.rawValue {
            return YLSDKLanguage.YLSDKRequestPending
        } else if finishCode ==  VoipSIPCallEndReasonCode.internalServerError.rawValue {
            return YLSDKLanguage.YLSDKServiceInternalServerError
        } else if finishCode ==  VoipSIPCallEndReasonCode.serviceLost.rawValue {
            return YLSDKLanguage.YLSDKServiceLost
        } else if finishCode ==  VoipSIPCallEndReasonCode.serviceUnavailable.rawValue {
            return YLSDKLanguage.YLSDKServiceUnavailable
        } else if finishCode ==  VoipSIPCallEndReasonCode.decline.rawValue {
            return YLSDKLanguage.YLSDKCodeDecline
        } else if finishCode ==  VoipSIPCallEndReasonCode.endByLocal.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else if finishCode ==  VoipSIPCallEndReasonCode.endByReMote.rawValue {
            return  YLSDKLanguage.YLSDKRemoteEndHangupTheSession
        } else if finishCode ==  VoipSIPCallEndReasonCode.forceSignout.rawValue {
            return YLSDKLanguage.YLSDKForcedWithdrawal
        } else if finishCode ==  VoipSIPCallEndReasonCode.videoTimeOut.rawValue {
            return YLSDKLanguage.YLSDKVideoTimeout
        } else if finishCode ==  VoipSIPCallEndReasonCode.userIgnore.rawValue {
            return YLSDKLanguage.YLSDKUsersIgnore
        } else if finishCode ==  VoipSIPCallEndReasonCode.dnd.rawValue {
            return YLSDKLanguage.YLSDKDndHangsUp
        } else if finishCode ==  VoipSIPCallEndReasonCode.callLimit.rawValue {
            return YLSDKLanguage.YLSDKCallRestriction
        } else if finishCode ==  VoipSIPCallEndReasonCode.backList.rawValue {
            return YLSDKLanguage.YLSDKBlacklist
        } else if finishCode ==  VoipSIPCallEndReasonCode.extenBase.rawValue {
            return YLSDKLanguage.YLSDKUnknownType
        } else if finishCode ==  VoipSIPCallEndReasonCode.netWorkBroken.rawValue {
            return YLSDKLanguage.YLSDKNetworkError
        } else if finishCode ==  VoipSIPCallEndReasonCode.userNotReg.rawValue {
            return YLSDKLanguage.YLSDKTheUserIsNotRegistered
        } else if finishCode ==  VoipSIPCallEndReasonCode.mediaNegotiateFailed.rawValue {
            return YLSDKLanguage.YLSDKMediaConsultationFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.IgnoreCall.rawValue {
            return YLSDKLanguage.YLSDKExpiredTimeout
        } else if finishCode ==  VoipSIPCallEndReasonCode.forceReject.rawValue {
            return YLSDKLanguage.YLSDKMandatoryRefusal
        } else if finishCode ==  VoipSIPCallEndReasonCode.elsewhereComplate.rawValue {
            return YLSDKLanguage.YLSDKFinishItSomewhereElse
        } else if finishCode ==  VoipSIPCallEndReasonCode.audioError.rawValue {
            return YLSDKLanguage.YLSDKAudioProblem
        } else if finishCode ==  VoipSIPCallEndReasonCode.confServiceFailed.rawValue {
            return YLSDKLanguage.YLSDKConferenceServiceFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.confInitFailed.rawValue {
            return YLSDKLanguage.YLSDKConferenceInitializationFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.confNotFound.rawValue {
            return YLSDKLanguage.YLSDKMeetingLost
        } else if finishCode ==  VoipSIPCallEndReasonCode.confLocked.rawValue {
            return YLSDKLanguage.YLSDKConferenceLocked
        } else if finishCode ==  VoipSIPCallEndReasonCode.confUserCountLimit.rawValue {
            return YLSDKLanguage.YLSDKSubscriberLimit
        } else if finishCode ==  VoipSIPCallEndReasonCode.confElsewhereJoin.rawValue {
            return YLSDKLanguage.YLSDKJoinElsewhere
        } else if finishCode ==  VoipSIPCallEndReasonCode.confUserDel.rawValue {
            return YLSDKLanguage.YLSDKYouHaveBeenRemovedFromTheConference
        } else if finishCode ==  VoipSIPCallEndReasonCode.confForceEnd.rawValue {
            return YLSDKLanguage.YLSDKConferenceHasBeenEndedByModerator
        } else {
            return ""
        }
    }
    
    class func getFinish323Code(finishCode: Int) -> String {
        
        if  finishCode == Voip323CallEndReasonCode.h323FinishCodeLocalUser.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoAccept.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeAnwserDenied.rawValue {
            return YLSDKLanguage.YLSDKLocalEndsUpTheSession
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeRemoteUser.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndHangupTheSession
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeRefusal.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndHangupTheSession
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoAnswer.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointDidNotAnswerInRequiredTime
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeCallAbout.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointStoppedCalling
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeTransportFail.rawValue {
            return YLSDKLanguage.YLSDKTransportErrorClearedCall
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeConnectFail.rawValue {
            return YLSDKLanguage.YLSDKTransportConnectionFailedToEstablishCall
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeGateKeeper.rawValue {
            return YLSDKLanguage.YLSDKGatekeeperHasClearedCall
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoUser.rawValue {
            return YLSDKLanguage.YLSDKCallFailedAsCouldNotFindUserInGK
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoBandwidth.rawValue {
            return YLSDKLanguage.YLSDKCallFailedAsCouldNotGetEnoughBandwidth
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeCapabilityExchange.rawValue {
            return YLSDKLanguage.YLSDKCouldNotFindCommonCapabilities
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeCallForward.rawValue {
            return YLSDKLanguage.YLSDKCallWasForwardedUsingFACILITYMessage
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeSecurityDenial.rawValue {
            return YLSDKLanguage.YLSDKCallFailedASecurityCheckAndWasEnded
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeLocalBusy.rawValue {
            return YLSDKLanguage.YLSDKLocalEndpointBusy
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeLocalCongestion.rawValue {
            return YLSDKLanguage.YLSDKLocalEndpointCongested
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeRemoteBusy.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointBusy
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeRemoteCongestion.rawValue {
            return YLSDKLanguage.YLSDKRemoteEndpointCongested
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeUNReachable.rawValue {
            return YLSDKLanguage.YLSDKCouldNotReachTheRemoteParty
        } else if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoEndPoint.rawValue {
            return YLSDKLanguage.YLSDKTheRemotePartyIsNotRunningAnEndpoint
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeHostOffline.rawValue {
            return YLSDKLanguage.YLSDKTheRemotePartyHostOffLine
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeTemporaryFailue.rawValue {
            return YLSDKLanguage.YLSDKTheRemoteFailedTemporarilyAppMayretry
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeQ931Cause.rawValue {
            return YLSDKLanguage.YLSDKTheRemoteEndedTheCallWithUnmappedQ931CauseCode
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeDurationLimit.rawValue {
            return YLSDKLanguage.YLSDKCallClearedAsNumberWasInvalidFormat
        } else if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeInvalidConferenceId.rawValue {
            return YLSDKLanguage.YLSDKCallClearedDueToInvalidConferenceID
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeOSPRefusal.rawValue {
            return YLSDKLanguage.YLSDKCallClearedAsOSPServerUnableOrUnwillingToRoute
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeInvalidNumberFormat.rawValue {
            return YLSDKLanguage.YLSDKCallClearedAsNumberWasInvalidFormat
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeUnspecifiedPortocol.rawValue {
            return YLSDKLanguage.YLSDKCallClearedDueToUnspecifiedProtocolError
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeNoFeatureSupport.rawValue {
            return YLSDKLanguage.YLSDKCallEndedDueToFeatureNotBeingPresent
            
        } else if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeInfomationELEMissing.rawValue {
            return YLSDKLanguage.YLSDKmandatoryInformationElementMissing
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeCompatStateError.rawValue {
            return YLSDKLanguage.YLSDKmessageNotCompatibleWithCallState
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeInvalidInfomation.rawValue {
            return YLSDKLanguage.YLSDKinvalidInformationElement
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeTimerExpiry.rawValue {
            return YLSDKLanguage.YLSDKEndedByTimerExpiryT301
        } else  if finishCode ==  Voip323CallEndReasonCode.h323FinishCodeParamError.rawValue {
            return YLSDKLanguage.YLSDKnewMsgAddByRequirement
        } else if finishCode ==  Voip323CallEndReasonCode.endByReMote.rawValue {
            return  YLSDKLanguage.YLSDKRemoteEndUp
        } else if finishCode ==  VoipSIPCallEndReasonCode.forceSignout.rawValue {
            return YLSDKLanguage.YLSDKForcedWithdrawal
        } else if finishCode ==  VoipSIPCallEndReasonCode.videoTimeOut.rawValue {
            return YLSDKLanguage.YLSDKVideoTimeout
        } else if finishCode ==  VoipSIPCallEndReasonCode.userIgnore.rawValue {
            return YLSDKLanguage.YLSDKUsersIgnore
        } else if finishCode ==  VoipSIPCallEndReasonCode.dnd.rawValue {
            return YLSDKLanguage.YLSDKDndHangsUp
        } else if finishCode ==  VoipSIPCallEndReasonCode.callLimit.rawValue {
            return YLSDKLanguage.YLSDKCallRestriction
        } else if finishCode ==  VoipSIPCallEndReasonCode.backList.rawValue {
            return YLSDKLanguage.YLSDKBlacklist
        } else if finishCode ==  VoipSIPCallEndReasonCode.extenBase.rawValue {
            return YLSDKLanguage.YLSDKUnknownType
        } else if finishCode ==  VoipSIPCallEndReasonCode.netWorkBroken.rawValue {
            return YLSDKLanguage.YLSDKNetworkError
        } else if finishCode ==  VoipSIPCallEndReasonCode.userNotReg.rawValue {
            return YLSDKLanguage.YLSDKTheUserIsNotRegistered
        } else if finishCode ==  VoipSIPCallEndReasonCode.mediaNegotiateFailed.rawValue {
            return YLSDKLanguage.YLSDKMediaConsultationFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.IgnoreCall.rawValue {
            return YLSDKLanguage.YLSDKExpiredTimeout
        } else if finishCode ==  VoipSIPCallEndReasonCode.forceReject.rawValue {
            return YLSDKLanguage.YLSDKMandatoryRefusal
        } else if finishCode ==  VoipSIPCallEndReasonCode.elsewhereComplate.rawValue {
            return YLSDKLanguage.YLSDKFinishItSomewhereElse
        } else if finishCode ==  VoipSIPCallEndReasonCode.audioError.rawValue {
            return YLSDKLanguage.YLSDKAudioProblem
        } else if finishCode ==  VoipSIPCallEndReasonCode.confServiceFailed.rawValue {
            return YLSDKLanguage.YLSDKConferenceServiceFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.confInitFailed.rawValue {
            return YLSDKLanguage.YLSDKConferenceInitializationFailed
        } else if finishCode ==  VoipSIPCallEndReasonCode.confNotFound.rawValue {
            return YLSDKLanguage.YLSDKMeetingLost
        } else if finishCode ==  VoipSIPCallEndReasonCode.confLocked.rawValue {
            return YLSDKLanguage.YLSDKConferenceLock
        } else if finishCode ==  VoipSIPCallEndReasonCode.confUserCountLimit.rawValue {
            return YLSDKLanguage.YLSDKSubscriberLimit
        } else if finishCode ==  VoipSIPCallEndReasonCode.confElsewhereJoin.rawValue {
            return YLSDKLanguage.YLSDKJoinElsewhere
        } else if finishCode ==  VoipSIPCallEndReasonCode.confUserDel.rawValue {
            return YLSDKLanguage.YLSDKYouHaveBeenRemovedFromTheConference
        } else if finishCode ==  VoipSIPCallEndReasonCode.confForceEnd.rawValue {
            return YLSDKLanguage.YLSDKConferenceHasBeenEndedByModerator
        } else {
            return ""
        }
    }
    
    
    
    class func getCallfinisheCode (resultCode: Int, finishCode: Int , timeStart:TimeInterval)-> ReturnText {
        let returnText = ReturnText()
        if (resultCode == CallFinishResonCode.noError.rawValue) {
            if (timeStart > 0) {
                //mainTitle 原因
                returnText.mainTitle = getFinishNoErrorCode(finishCode: finishCode)
                
                // subTitle 时间
                let timeLast: TimeInterval = SDKTimeManager.getCurrentTime() - timeStart
                returnText.subtitle = SDKTimeManager.getTalkTimerLengthFromZero(timeInterval: timeLast)
            } else {
                returnText.mainTitle = YLSDKLanguage.YLSDKCallFinished
                //subTitle 原因 ，
                returnText.subtitle  = getFinishNoErrorCode(finishCode: finishCode)
            }
        } else if (resultCode == CallFinishResonCode.sipH323.rawValue) {
            if (timeStart > 0) {
                // if H323
                if CallServerDataSource.getInstance.getTkData().m_iType == 1 {
                    returnText.mainTitle = getFinish323Code(finishCode: finishCode)
                    
                } else {
                    //  sip
                    returnText.mainTitle = getFinishSIPCode(finishCode: finishCode)
                }
                // subTitle 时间
                let timeLast: TimeInterval = SDKTimeManager.getCurrentTime() - timeStart
                returnText.subtitle = SDKTimeManager.getTalkTimerLengthFromZero(timeInterval: timeLast)
            } else {
                returnText.mainTitle = YLSDKLanguage.YLSDKCallFinished
                //subTitle 原因 ，
                // if H323
                if CallServerDataSource.getInstance.getTkData().m_iType == 1 {
                    returnText.subtitle = getFinish323Code(finishCode: finishCode)
                    
                } else {
                    // if Sip
                    returnText.subtitle = getFinishSIPCode(finishCode: finishCode)
                }
            }
        } else {
            if (timeStart > 0) {
                //mainTitle 原因
                returnText.mainTitle = getCallReasonCodeText(resultCode: resultCode)
                
                // subTitle 时间
                let timeLast: TimeInterval = SDKTimeManager.getCurrentTime() - timeStart
                returnText.subtitle = SDKTimeManager.getTalkTimerLengthFromZero(timeInterval: timeLast)
            } else {
                returnText.mainTitle = YLSDKLanguage.YLSDKCallFinished
                
                //subTitle 原因 ，
                returnText.subtitle = getCallReasonCodeText(resultCode: resultCode)
            }
        }
        return returnText
    }
    
    class func getMeetingInviteFailedCode(failedCode:Int) -> String {
        var reson = ""
        switch failedCode {
        case InviteUserFailedCode.notRegister.rawValue :
            reson = YLSDKLanguage.YLSDKTheUserIsNotRegistered
            break
        case InviteUserFailedCode.busy.rawValue :
            reson = YLSDKLanguage.YLSDKUserBusy
            break
        case InviteUserFailedCode.reject.rawValue:
            reson =  YLSDKLanguage.YLSDKRefusedToJoinTheInvitation
            break
        case InviteUserFailedCode.timeOut.rawValue:
            reson =  YLSDKLanguage.YLSDKSInvitationIsOverdue
            break
        case InviteUserFailedCode.setDnd.rawValue:
            reson = YLSDKLanguage.YLSDKEnablesDNDFeature
            break
        case InviteUserFailedCode.limitCalls.rawValue:
            reson =  YLSDKLanguage.YLSDKRefusedYourInvitation
            break
        case InviteUserFailedCode.rejectByBlackList.rawValue:
            reson = YLSDKLanguage.YLSDKRefusedYourInvitation
            break
        case InviteUserFailedCode.dnd.rawValue:
            reson =  YLSDKLanguage.YLSDKEnablesDNDFeature
            break
        case InviteUserFailedCode.offline.rawValue:
            reson =  YLSDKLanguage.YLSDKIsOffline
            break
            
        default:
            reson = String(failedCode)
            break
        }
        return reson
    }
    
    class func getConfEndFailedCode(reasonCode: Int) -> String {
        switch reasonCode {
        case ConfEndFailedCode.confNoExistent.rawValue:
            return YLSDKLanguage.YLSDKConfNoExist
        case ConfEndFailedCode.haveNoRight.rawValue:
            return YLSDKLanguage.YLSDKLimitedPermissions
        default:
            return ""
        }
    }
}


