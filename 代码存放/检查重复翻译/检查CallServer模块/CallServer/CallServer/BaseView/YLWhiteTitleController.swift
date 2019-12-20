//
//  YLWhiteTitleController.swift
//  CallServer
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class YLWhiteTitleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavigationBarColor()
        addLeftReturnAndTitleButton()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    func addLeftReturnAndTitleButton() {
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = nil
        
        let button = UIButton.init(type: UIButtonType.custom)

        button.setTitle(YLSDKLanguage.YLSDKback, for: .normal)
        button.titleLabel?.font = UIFont.fontWithHelvetica(kFontSizeLarge)
        button.setTitleColor(UIColor.mainColorYL, for: .normal)
        button.addTarget(self, action: #selector(closeCurrentController), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        let image: UIImage = #imageLiteral(resourceName: "NavigationBarReturn_Blue")
        button.setImage(image, for: UIControlState.normal)
        
        let barBT: UIBarButtonItem = UIBarButtonItem.init(customView: button)
        barBT.accessibilityIdentifier = "Back"
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = barBT
    }
    
    func changeNavigationBarColor() {
        let color = UIColor.clear
        let image = UIImage.imageWithColor(color: color)
        navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.textBlackColorYL]
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
 
    @objc func  closeCurrentController() {
        dismiss(animated: true, completion: nil);
    }
    
    @objc func  clickMsgNoticeBtn() {
        
    }
    
    
    func addRightMsgNoticeButton() {
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
        let button = UIButton.init(type: UIButtonType.custom)
        button.addTarget(self, action: #selector(clickMsgNoticeBtn), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        let image: UIImage = #imageLiteral(resourceName: "NavigationBarMsgNoticeNor")
        button.setImage(image, for: UIControlState.normal)
        
        let barBT: UIBarButtonItem = UIBarButtonItem.init(customView: button)
        barBT.accessibilityIdentifier = "MsgNotice"
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = barBT
    }

}
