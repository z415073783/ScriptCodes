//
//  YLAlertView.swift
//  UME
//
//  Created by zlm on 16/7/21.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit

class YLSDKAlertView: NSObject {

    /// 初始化并显示提示框,
    ///
    /// - Parameters:
    ///   - title: 标题 可选
    ///   - message: 内容 可选
    ///   - param1: 按钮1 可选
    ///   - param2: 按钮2 可选
    ///   - cancel: 关闭按钮 可选
    ///   - preferredStyle: 提示框风格
    ///   - target: 视图控制器 传入需要调用该方法的本视图控制器
    ///   - superView: 当preferredStyle设为actionSheet时,需要传入指定视图 可选
    ///   - block: 返回块 
    static func Show(_ title: String?, message: String?, param1: String?, param2: String?, cancel: String?, preferredStyle: UIAlertControllerStyle, target: UIViewController, superView: UIView? = nil, block:@escaping ((_ action: UIAlertAction) -> Void)) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if param1 != nil {
            let param1Action: UIAlertAction = UIAlertAction(title: param1, style: UIAlertActionStyle.default) { (action) in
                block(action)
            }
            alertC.addAction(param1Action)
        }
        if param2 != nil {
            let param2Action: UIAlertAction = UIAlertAction(title: param2, style: UIAlertActionStyle.default) { (action) in
                block(action)
            }
            alertC.addAction(param2Action)
        }
        if cancel != nil {
            let param3Action: UIAlertAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel) { (action) in
                block(action)
            }
            alertC.addAction(param3Action)
        }

        if let popoverC: UIPopoverPresentationController = alertC.popoverPresentationController {
            if superView != nil {
                popoverC.sourceView = superView
                popoverC.sourceRect = superView!.bounds
                popoverC.permittedArrowDirections = UIPopoverArrowDirection.any
            }
        }
        target.present(alertC, animated: true) {

        }
        if preferredStyle == UIAlertControllerStyle.actionSheet {
            alertC.view.layoutIfNeeded()
        }

    }

}
