//
//  YLBlueCallViewController.swift
//  CallServer
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 yealink. All rights reserved.
//

import UIKit

class YLBlueCallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavigationBarColor()
        addLeftReturnAndTitleButton()
//        changeNavigationBarColor(type: .main)
//        addLeftReturnAndTitleButton(.white)
    }

    func changeNavigationBarColor() {
        let color = UIColor.mainColorYL
        let image = UIImage.imageWithColor(color: color)
        navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }

    func addLeftReturnAndTitleButton() {
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = nil

        let rightButton = UIButton.init(type: UIButtonType.custom)
        rightButton.setTitle("", for: .normal)
        rightButton.titleLabel?.font = UIFont.fontWithHelvetica(kFontSizeLarge)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.addTarget(self, action: #selector(closeCurrentController), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        if let image: UIImage = UIImage.init(named: "close_nor") {
            rightButton.setImage(image, for: UIControlState.normal)
        }
        let barBT: UIBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        barBT.accessibilityIdentifier = "Back"
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = barBT
    }

   @objc func closeCurrentController() {
         _ = navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
