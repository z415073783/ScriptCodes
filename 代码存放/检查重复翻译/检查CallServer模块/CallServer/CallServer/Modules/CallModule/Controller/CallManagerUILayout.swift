//
//  CallManagerUILayout.swift
//  CallServer
//
//  Created by Apple on 2017/12/3.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class CallManagerUILayout: CallManagerUIGusterVC {


    // MARK: - 👉Listener Area
    func addstatusBarOrientationChangeListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    @objc func statusBarOrientationDidChange() {
        if isVideo == false {
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
                audioCallConfForIphoneLayout()
            } else {
                audioCallConfForIpadLayout()
            }
        } else {
            screenChange()
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.pad) {
                if RotationManager.getInstance.openRotation == true {
                    videoCallForIphone()
                }
            } else {
                if RotationManager.getInstance.openRotation == true {
                    videoCallForIpad()
                }
            }
            if moreView == nil || moreView?.alpha == 0 {
                startbottomContainerHide()
            } else {
                cancleDismissMenu()
            }
            mainScrollView?.setZoomScale(1, animated: true)
            if let thisKeyWindow = UIApplication.shared.keyWindow {
                mainVideoView.frame = thisKeyWindow.frame
                if shareScrollView != nil {
                    shareScrollView?.setZoomScale(1, animated: true)
                    shareVideoView.frame = thisKeyWindow.frame
                }
            }
            
            moreBtnLocation()
            UIApplication.shared.setStatusBarHidden(false, with: .none)
            self.perform(#selector(setMainSmallVideoDisplay), with: nil, afterDelay: 0.35)
        }
    }
    
    
    
    func audioCallConfForIphoneLayout() {
        if isConficen == false {
            audioCallForIphoneLayOut()
        } else if isConficen == true {
            audioConfForIphoneLayOut()
        }
    }
    
    func audioConfForIphoneLayOut() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(view).offset(120)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(27)
                
            })
            
            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(17)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
            
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(178)
                make.left.right.bottom.equalTo(view)
            })
            
            muteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).dividedBy(3)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmSpeakerBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmSpeakerLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmSpeakerBtn)
                make.width.equalTo(56)
            })
            
            bottmDtmfBtn.snp.remakeConstraints({ (make) in
                let a = view.frame.width / 3
                make.centerX.equalTo(view).offset(a)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmDtmfLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmDtmfBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(muteLabel.snp.bottom).offset(14)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(100)
            })
            if isConficen {
                bottmInviteBtn.snp.remakeConstraints({ (make) in
                    make.top.equalTo(muteLabel.snp.bottom).offset(14)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.centerX.equalTo(muteBtn)
                })
                
                inviteLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmInviteBtn)
                    make.width.equalTo(100)
                })
                
                bottmMemberListBtn.snp.remakeConstraints({ (make) in
                    make.top.equalTo(muteLabel.snp.bottom).offset(14)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.centerX.equalTo(bottmDtmfBtn)
                })
                
                memberListLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmMemberListBtn)
                    make.width.equalTo(100)
                })
            }
        } else {
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(view).offset(60)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(27)
                
            })
            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(17)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
            
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(92)
                make.left.right.bottom.equalTo(view)
            })
            muteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-200)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmSpeakerBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-120)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmSpeakerLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmSpeakerBtn)
                make.width.equalTo(56)
            })
            
            bottmDtmfBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-40)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmDtmfLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmDtmfBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottomContainerView).offset(10)
                make.centerX.equalTo(view).offset(200)
                make.width.equalTo(56)
                make.height.equalTo(56)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(hungUpBtn)
                make.width.equalTo(56)
            })
            
            if isConficen {
                bottmInviteBtn.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(view).offset(40)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.top.equalTo(bottomContainerView).offset(10)
                })
                
                inviteLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmInviteBtn)
                    make.width.equalTo(56)
                })
                
                bottmMemberListBtn.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(view).offset(120)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.top.equalTo(bottomContainerView).offset(10)
                })
                
                memberListLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmMemberListBtn)
                    make.width.equalTo(56)
                })
            }
        }
    }
    
    func audioCallForIphoneLayOut() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(view).offset(120)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(27)
                
            })
            
            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(17)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
            
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(178)
                make.left.right.bottom.equalTo(view)
            })
            
            muteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).dividedBy(3)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmSpeakerBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmSpeakerLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmSpeakerBtn)
                //make.width.equalTo(56)
            })
            
            bottmDtmfBtn.snp.remakeConstraints({ (make) in
                let a = view.frame.width / 3
                make.centerX.equalTo(view).offset(a)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmDtmfLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmDtmfBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottmDtmfLabel.snp.bottom).offset(14)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(100)
            })
            
        } else {
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(view).offset(60)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.height.equalTo(27)
                
            })
            subTitleLabel.snp.remakeConstraints({ (make) in
                make.height.equalTo(17)
                make.left.equalTo(bgImageView).offset(12)
                make.right.equalTo(bgImageView).offset(-12)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
            
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(92)
                make.left.right.bottom.equalTo(view)
            })
            muteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-156)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmSpeakerBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-52)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmSpeakerLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmSpeakerBtn)
            })
            
            bottmDtmfBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(52)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmDtmfLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmDtmfBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottomContainerView).offset(10)
                make.centerX.equalTo(view).offset(156)
                make.width.equalTo(56)
                make.height.equalTo(56)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(hungUpBtn)
                make.width.equalTo(56)
            })
        }
    }
    
    func audioCallConfForIpadLayout() {
        if isConficen == false {
            audioCallForIpadLayout()
        } else if isConficen == true {
            audioConfForIpadLayout()
        }
    }
    
    func audioConfForIpadLayout() {
        titleLabel.font = UIFont.fontWithHelvetica(36)
        titleLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(view).offset(120)
            make.left.equalTo(bgImageView).offset(12)
            make.right.equalTo(bgImageView).offset(-12)
            make.height.equalTo(50)
            
        })
        subTitleLabel.font = UIFont.fontWithHelvetica(14)
        subTitleLabel.snp.remakeConstraints({ (make) in
            make.height.equalTo(20)
            make.left.equalTo(bgImageView).offset(12)
            make.right.equalTo(bgImageView).offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        })
        
        bottomContainerView.snp.remakeConstraints({ (make) in
            make.height.equalTo(113)
            make.left.right.bottom.equalTo(view)
        })
        muteBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(-200)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        muteLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(muteBtn.snp.bottom).offset(4)
            make.centerX.equalTo(muteBtn)
            make.width.equalTo(56)
        })
        handUpButton.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteBtn)
        })
        handUpLabel.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteLabel)
        })
        
        bottmSpeakerBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(-120)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmSpeakerLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmSpeakerBtn)
            make.width.equalTo(56)
        })
        
        bottmDtmfBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(-40)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmDtmfLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmDtmfBtn)
            make.width.equalTo(100)
        })
        
        hungUpBtn.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottomContainerView).offset(20)
            make.centerX.equalTo(view).offset(200)
            make.width.equalTo(56)
            make.height.equalTo(56)
        })
        
        hungUpLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
            make.centerX.equalTo(hungUpBtn)
            make.width.equalTo(56)
        })
        
        bottmInviteBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(bottomContainerView).offset(20)
            make.centerX.equalTo(view).offset(40)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
        inviteLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmInviteBtn)
            make.width.equalTo(56)
        }
        
        bottmMemberListBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(bottomContainerView).offset(20)
            make.centerX.equalTo(view).offset(120)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }
        memberListLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmMemberListBtn)
            make.width.equalTo(56)
        }
    }
    
    func audioCallForIpadLayout() {
        titleLabel.font = UIFont.fontWithHelvetica(36)
        titleLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(view).offset(120)
            make.left.equalTo(bgImageView).offset(12)
            make.right.equalTo(bgImageView).offset(-12)
            make.height.equalTo(50)
            
        })
        subTitleLabel.font = UIFont.fontWithHelvetica(14)
        subTitleLabel.snp.remakeConstraints({ (make) in
            make.height.equalTo(20)
            make.left.equalTo(bgImageView).offset(12)
            make.right.equalTo(bgImageView).offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        })
        
        bottomContainerView.snp.remakeConstraints({ (make) in
            make.height.equalTo(113)
            make.left.right.bottom.equalTo(view)
        })
        muteBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(-156)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        muteLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(muteBtn.snp.bottom).offset(4)
            make.centerX.equalTo(muteBtn)
            make.width.equalTo(56)
        })
        handUpButton.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteBtn)
        })
        handUpLabel.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteLabel)
        })
        
        bottmSpeakerBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(-52)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmSpeakerLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmSpeakerBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmSpeakerBtn)
        })
        
        
        bottmDtmfBtn.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(view).offset(52)
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmDtmfLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmDtmfBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmDtmfBtn)
            make.width.equalTo(100)
        })
        
        hungUpBtn.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottomContainerView).offset(20)
            make.centerX.equalTo(view).offset(156)
            make.width.equalTo(56)
            make.height.equalTo(56)
        })
        
        hungUpLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
            make.centerX.equalTo(hungUpBtn)
            make.width.equalTo(56)
        })
    }
    
    func videoCallForIphone() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(178)
                make.left.right.bottom.equalTo(view)
            })
            
            muteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).dividedBy(3)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmCamearBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmCamearLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmCamearBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmCamearBtn)
                make.width.equalTo(56)
            })
            
            bottmMoreBtn.addTarget(self, action: #selector(bottmDtmfBtnClick), for: .touchUpInside)
            
            bottmMoreBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).multipliedBy(1.67)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmMoreLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMoreBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmMoreBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottmMoreLabel.snp.bottom).offset(14)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottomContainerView)
                make.width.equalTo(100)
            })
            
            bottmInviteBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMoreLabel.snp.bottom).offset(14)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.centerX.equalTo(muteBtn)
            })
            
            inviteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmInviteBtn)
                make.width.equalTo(100)
            })
            
            bottmMemberListBtn.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMoreLabel.snp.bottom).offset(14)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.centerX.equalTo(bottmMoreBtn)
            })
            
            memberListLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmMemberListBtn)
                make.width.equalTo(100)
            })
            
            if smallVideoView.videoHideShowBtn.isSelected == false {
                if smallVideoType == .LvtRemote {
                    smallVideoViewSet(width: 160, hight: 90)
                } else {
                    smallVideoViewSet(width: 90, hight: 160)
                }
            }
            
            if smallVideoType == .LvtRemote {
                smallVideoRealVideSet(width: 160, hight: 90)
            } else {
                smallVideoRealVideSet(width: 90, hight: 160)
            }
            
        } else {
            bottomContainerView.snp.remakeConstraints({ (make) in
                make.height.equalTo(92)
                make.left.right.bottom.equalTo(view)
            })
            
            muteBtn.snp.remakeConstraints({ (make) in
                if isConficen == false {
                    make.centerX.equalTo(view).offset(-180)
                } else {
                    make.centerX.equalTo(view).offset(-200)
                }
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            muteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(muteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(muteBtn)
                make.width.equalTo(56)
            })
            handUpButton.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteBtn)
            })
            handUpLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(muteLabel)
            })
            
            bottmCamearBtn.snp.remakeConstraints({ (make) in
                if isConficen == false {
                    make.centerX.equalTo(view).offset(-60)
                } else {
                    make.centerX.equalTo(view).offset(-120)
                }
                make.centerX.equalTo(view).offset(-60)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmCamearLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmCamearBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmCamearBtn)
                make.width.equalTo(56)
            })
            
            bottmMoreBtn.addTarget(self, action: #selector(bottmMoreBtnClick), for: .touchUpInside)
            
            bottmMoreBtn.snp.remakeConstraints({ (make) in
                if isConficen == false {
                    make.centerX.equalTo(view).offset(60)
                } else {
                    make.centerX.equalTo(view).offset(120)
                }
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            bottmMoreLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMoreBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmMoreBtn)
                make.width.equalTo(100)
            })
            
            hungUpBtn.snp.remakeConstraints({ (make) in
                if isConficen == false {
                    make.centerX.equalTo(view).offset(180)
                } else {
                    make.centerX.equalTo(view).offset(200)
                }
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(10)
            })
            
            hungUpLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
                make.centerX.equalTo(hungUpBtn)
                make.width.equalTo(56)
            })
            
            if isConficen {
                bottmInviteBtn.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(view).offset(-40)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.top.equalTo(bottomContainerView).offset(10)
                })
                
                inviteLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmInviteBtn)
                    make.width.equalTo(56)
                })
                
                bottmMemberListBtn.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(view).offset(40)
                    make.width.equalTo(56)
                    make.height.equalTo(56)
                    make.top.equalTo(bottomContainerView).offset(10)
                })
                
                memberListLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
                    make.centerX.equalTo(bottmMemberListBtn)
                    make.width.equalTo(56)
                })
            }
            if smallVideoView.videoHideShowBtn.isSelected == false {
                smallVideoViewSet(width: 160, hight: 90)
            }
            smallVideoRealVideSet(width: 160, hight: 90)
        }
    }
    
    func videoCallForIpad() {
        bottomContainerView.snp.remakeConstraints({ (make) in
            make.height.equalTo(113)
            make.left.right.bottom.equalTo(view)
        })
        
        muteBtn.snp.remakeConstraints({ (make) in
            if isConficen {
                make.centerX.equalTo(view).offset(-200)
            } else {
                make.centerX.equalTo(view).offset(-180)
            }
            
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        muteLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(muteBtn.snp.bottom).offset(4)
            make.centerX.equalTo(muteBtn)
            make.width.equalTo(56)
        })
        
        handUpButton.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteBtn)
        })
        handUpLabel.snp.remakeConstraints({ (make) in
            make.edges.equalTo(muteLabel)
        })
        
        bottmCamearBtn.snp.remakeConstraints({ (make) in
            if isConficen {
                make.centerX.equalTo(view).offset(-120)
            } else {
                make.centerX.equalTo(view).offset(-60)
            }
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmCamearLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmCamearBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmCamearBtn)
            make.width.equalTo(56)
        })
        
        bottmMoreBtn.addTarget(self, action: #selector(bottmMoreBtnClick), for: .touchUpInside)
        
        bottmMoreBtn.snp.remakeConstraints({ (make) in
            if isConficen {
                make.centerX.equalTo(view).offset(120)
            } else {
                make.centerX.equalTo(view).offset(60)
            }
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(bottomContainerView).offset(20)
        })
        
        bottmMoreLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottmMoreBtn.snp.bottom).offset(4)
            make.centerX.equalTo(bottmMoreBtn)
            make.width.equalTo(100)
        })
        
        hungUpBtn.snp.remakeConstraints({ (make) in
            make.top.equalTo(bottomContainerView).offset(20)
            if isConficen {
                make.centerX.equalTo(view).offset(200)
            } else {
                make.centerX.equalTo(view).offset(180)
            }
            make.width.equalTo(56)
            make.height.equalTo(56)
        })
        
        hungUpLabel.snp.remakeConstraints({ (make) in
            make.top.equalTo(hungUpBtn.snp.bottom).offset(4)
            make.centerX.equalTo(hungUpBtn)
            make.width.equalTo(56)
        })
        if isConficen {
            bottmInviteBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(-40)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(20)
            })
            
            inviteLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmInviteBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmInviteBtn)
                make.width.equalTo(56)
            })
            
            bottmMemberListBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view).offset(40)
                make.width.equalTo(56)
                make.height.equalTo(56)
                make.top.equalTo(bottomContainerView).offset(20)
            })
            
            memberListLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(bottmMemberListBtn.snp.bottom).offset(4)
                make.centerX.equalTo(bottmMemberListBtn)
                make.width.equalTo(56)
            })
        }
        
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            if smallVideoView.videoHideShowBtn.isSelected == false {
                if smallVideoType == .LvtRemote {
                    smallVideoViewSet(width: 160, hight: 90)
                } else {
                    smallVideoViewSet(width: 90, hight: 160)
                }
            }
            
            if smallVideoType == .LvtRemote {
                smallVideoRealVideSet(width: 160, hight: 90)
            } else {
                smallVideoRealVideSet(width: 90, hight: 160)
            }
            
        } else {
            if smallVideoView.videoHideShowBtn.isSelected == false {
                smallVideoViewSet(width: 160, hight: 90)
            }
            smallVideoRealVideSet(width: 160, hight: 90)
        }
    }

}
