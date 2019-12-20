//
//  YLAlertNoButtonView.swift
//  UME
//
//  Created by zlm on 16/7/25.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit
enum YLSDKAlertNoButtonView_Position {
    case top, center, bottom, resident //顶部显示,中间显示,底部显示
}

class YLSDKAlertNoButtonViewManager: NSObject {
    static let getInstance = YLSDKAlertNoButtonViewManager()
    var residentView: YLSDKAlertNoButtonView?
    func removeView() {
        residentView?.endAction(block: { (_) in
        })
        YLSDKAlertNoButtonViewManager.getInstance.residentView = nil
    }
    func setText(sender: String) {
        residentView?.titlelb?.text = sender
    }
    func setAttribute(sender: NSAttributedString?) {
        residentView?.titlelb?.attributedText = sender
    }
}

class YLSDKAlertNoButtonView: UIView {
    typealias CallFunc = (_ info:Any?) -> Void
    var _callFunc: CallFunc?
    var _touchCallFunc: CallFunc?
    fileprivate var titlelb: YLSDKTextView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /// 初始化并显示提示框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - position: 显示位置
    ///   - block: 消失返回
    class func show(_ title: String, position: YLSDKAlertNoButtonView_Position? = .center, block: CallFunc? = nil) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow
            let alertView = window?.viewWithTag(YLAlertViewTag)
            if alertView != nil {
                if let titleLabel = alertView?.viewWithTag(1) as? YLSDKTextView{
                    if titleLabel.text == title {
                        return
                    }
                }
            }
            YLSDKAlertNoButtonView(title: title, position: position!, block: block)
        }
        
    }

    /// 富文本提示框
    ///
    /// - Parameters:
    ///   - attribute: 富文本
    ///   - position: 位置
    ///   - touchBlock: touch返回 需要设置link
    ///   - block: 消失返回
    class func showAttribute(attribute: NSAttributedString? = nil, position: YLSDKAlertNoButtonView_Position? = .center, touchBlock: CallFunc? = nil, block: CallFunc? = nil) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow
            let alertView = window?.viewWithTag(YLAlertViewTag)
            if alertView != nil {
                if let titleLabel = alertView?.viewWithTag(1) as? YLSDKCancelLongPressTextView {
                    if titleLabel.text == attribute?.string {
                        return
                    }
                }
                
            }
            
            YLSDKLOG.log("show attribute message")

            YLSDKAlertNoButtonView(title: "", position: position!, attribute: attribute, touchBlock: touchBlock, block: block)
        }
    }

    @discardableResult fileprivate init(title: String, position: YLSDKAlertNoButtonView_Position, attribute: NSAttributedString? = nil, touchBlock: CallFunc? = nil, block: CallFunc?) {
        
        YLSDKLOG.log("show message" + title)
        
        if let thisBlock:CallFunc = block {
            _callFunc = thisBlock
        }
        
        if let thisTouchBlock:CallFunc = touchBlock {
            _touchCallFunc = thisTouchBlock
        }
    
        super.init(frame:CGRect(x: 0, y: 0, width: 600, height: 1000))
        
        let singleMainBtn = UIButton()
            
            //UITapGestureRecognizer.init(target: self, action:  #selector(singleMainScrollTapView))
        self.addSubview(singleMainBtn)
        singleMainBtn.addTarget(self, action: #selector(singleMainScrollTapView), for: .touchUpInside)
        singleMainBtn.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }
        tag = YLAlertViewTag
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        layer.cornerRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.7

        let titleLabel: YLSDKCancelLongPressTextView = YLSDKCancelLongPressTextView()
        //        titleLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
        //                                                                     action: #selector(longPress(gestureRecognizer:))))
        //        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
        //                                                                     action: #selector(longPress(gestureRecognizer:))))
        titleLabel.tag = 1
        titleLabel.isUserInteractionEnabled =  false
//        titleLabel.delegate = self
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.isScrollEnabled = false
        if attribute != nil {
            titleLabel.attributedText = attribute
        } else {
            titleLabel.text = title
        }
        titleLabel.font = UIFont.fontWithHelvetica(kFontSizeMedium)
        titleLabel.textColor = UIColor.white
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
//            YLLOG.debug("window.frame.size.width = \(window.frame.size.width)")
            make.width.lessThanOrEqualTo(kScreenWidth * 4 / 5)
        }

        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.isEditable = false
        snp.makeConstraints { (make) in
            switch position {
            case .top:
                if let thisView = YLSDKAlertNoButtonViewManager.getInstance.residentView {
                    make.top.equalTo(thisView.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(window.snp.top).offset(70)
                }
                make.centerX.equalTo(window)
                make.width.equalTo(titleLabel).offset(20)
                break
            case .center:
                make.center.equalTo(window)
                make.width.equalTo(titleLabel).offset(20)
                break
            case .bottom:
                make.bottom.equalTo(window).offset(-20)
                make.left.equalTo(window).offset(6)
                make.right.equalTo(window).offset(-6)
                break
            case .resident:
                YLSDKAlertNoButtonViewManager.getInstance.residentView = self
                tag = YLAlertResidentViewTag
                make.top.equalTo(window.snp.top).offset(70)
                make.centerX.equalTo(window)
                make.width.equalTo(titleLabel).offset(20)

                break
            }

            make.height.equalTo(titleLabel).offset(20)
        }
        titlelb = titleLabel
        //        NSAttributedStringKey.link
        beginAction(position: position)
    }
    
    @objc func singleMainScrollTapView() {
        if let callFunc = _callFunc{
            callFunc(nil)
        }
    }

    private func beginAction(position: YLSDKAlertNoButtonView_Position) {

        poppingAction()
        if position == .resident {
            return
        }
        Timer.scheduledTimerYL(withTimeInterval: 1.5, repeats: false, block: {[weak self] (_) in
            if self == nil {
                return
            }
            self?.endAction()
        })
    }
    fileprivate func endAction(block: CallFunc? = nil) {
        UIView.animate(withDuration: kActionDuration, delay: 0, options: UIViewAnimationOptions.layoutSubviews, animations: {[weak self] in
            if self == nil {
                return
            }
            self?.alpha = 0
        }) { [weak self](_) in
            if self == nil {
                return
            }
            self?.removeFromSuperview()
            if let thisBlock = block {
                thisBlock(nil)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let callblock =  _callFunc {
            callblock(nil)
        }
    }

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}


//typealias _TextViewDelegate = YLSDKAlertNoButtonView
//extension _TextViewDelegate: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        if _touchCallFunc != nil {
//            _touchCallFunc!(characterRange)
//        }
//        return false
//    }
//
//}



