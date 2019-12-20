//
//  ListSection.swift
//  Odin-UC
//
//  Created by Apple on 17/04/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

import UIKit

// MARK: - 👉Struct define Area

typealias ListSectionChooseBlock = (_ chooseTitle: String) -> Void
typealias ListSectionCancelBlock = () -> Void
typealias ListSectionCancelAreaBlock = () -> Void

class YLDailListSection: UIView {
    // MARK: - 👉Property Data Area
    var listSectionArray: Array<UIButton>!

    var chooseFunc: ListSectionChooseBlock?
    var cancelFunc: ListSectionCancelBlock?
    var clickCancelAreaFunc: ListSectionCancelAreaBlock?

    fileprivate var tapCancelGe: UITapGestureRecognizer!
    fileprivate var titleArray: Array<String> = []

    // MARK: - 👉Property UI Area

    var bgview: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        return view
    }()

    lazy var cancelButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = UIFont.fontWithHelvetica(17)
        btn.setTitleColor(UIColor.textBlackColorYL, for: .normal)
        btn.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .normal)
        btn.setBackgroundImage(UIImage.imageWithColor(color: .backgroundHighLightColorYL()), for: .highlighted)
        btn.setTitle(YLSDKLanguage.YLSDKCancel, for: .normal)
        return btn
    }()

    var bgmenuView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()

    var chooseImage: UIImageView = {
        let imageView = UIImageView.init(image:#imageLiteral(resourceName: "single_choose"))
        imageView.isUserInteractionEnabled =  true
        return imageView
    }()

    // MARK: - 👉View LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initBgView()
        initChooseView()
    }
    deinit {
        print("deinit DailListSection")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 👉UI Struct Area

    func initBgView() {
        self.addSubview(bgview)
        tapCancelGe = UITapGestureRecognizer.init(target: self, action: #selector(cancelTap))
        bgview.isUserInteractionEnabled = true
        bgview.addGestureRecognizer(tapCancelGe)

        bgview.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    func initChooseView() {
        self.addSubview(bgmenuView)
        bgmenuView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
        }
    }

    // MARK: - 👉UI GE Area
    @objc func cancelTap() {
        bgmenuView.sliderOutAction()
        UIView.animate(withDuration: 0.5, animations: {
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0)
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.removeFromSuperview()
        })
        if clickCancelAreaFunc != nil {
            clickCancelAreaFunc!()
        }
    }

    @objc func cancelFormBottomTap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgmenuView.snp.remakeConstraints { (make) in
                make.bottom.left.right.equalTo(self)
                make.height.equalTo(0)
            }
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0)
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }

    func cancelActionTap(action: @escaping ListSectionCancelBlock) {
        bgmenuView.sliderOutAction()
        cancelFunc = action
        UIView.animate(withDuration: 0.5, animations: {
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0)
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.removeFromSuperview()
            if self.cancelFunc != nil {
                self.cancelFunc!()
            }
        })
    }
    // down
    @objc func chooseTap(_ tap: UIButton) {
        if (chooseFunc != nil) {
            chooseFunc!(titleArray[tap.tag])
        }
        self.cancelFormBottomTap()
    }

    // Upper
    @objc func chooseCnacleTap(_ tap: UIButton) {
        let tapView = tap
        chooseImage.removeFromSuperview()
        tapView.addSubview(chooseImage)

        self.chooseImage.snp.remakeConstraints { (make) in
            make.right.equalTo((tapView.snp.right)).offset(-12)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo((tapView.snp.centerY))
        }
        self.layoutIfNeeded()
        if (chooseFunc != nil) {
            chooseFunc!(titleArray[tap.tag])
        }
        UIView.animate(withDuration: 1.5, animations: {

        }) { (_) in
            self.cancelTap()
        }
    }

    // MARK: - 👉Public Method
    // 有默认选择项
    func updateHeaderView(sheetTitleArray: Array<String>, defalutItem: Int, action: @escaping ListSectionChooseBlock) {
        chooseFunc = action
        listSectionArray = Array()
        titleArray = sheetTitleArray
        let sheetHight = sheetTitleArray.count * 40
        bgview.backgroundColor =  UIColor.blackColorAlphaYL(alpha: 0)

        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
            self?.layoutIfNeeded()
        }, completion: {[weak self] (_) in
            self?.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        })

        self.bgmenuView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.top)
            make.height.equalTo(sheetHight)
        }
        bgmenuView.sliderInActionWithTime(CGPoint(x: 0, y: sheetHight), time: 0.3)

        for i in stride(from: 0, to: sheetTitleArray.count, by: 1) {
            let btnView = UIButton.init()
            btnView.tag = i
            btnView.setTitleColor(UIColor.clear, for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .backgroundHighLightColorYL()), for: .highlighted)
            let lable = UILabel.init(frame: .zero)
            lable.font = UIFont.fontWithHelvetica(16)
            lable.textColor = UIColor.importTitleColor
            lable.textAlignment = .left
            let title: String =  localizedSDK(key: sheetTitleArray[i])
            btnView.setTitle(title, for: .normal)
            lable.text = title
            bgmenuView.addSubview(btnView)
            btnView.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(btnView)
                make.left.equalTo(btnView.snp.left).offset(20)
                make.width.equalTo(200)
            })
            btnView.addTarget(self, action:  #selector(chooseCnacleTap(_:)), for: .touchUpInside)

            let line = UIView.init()
            line.backgroundColor = UIColor.lineMediumGrayColorYL
            btnView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(bgmenuView.snp.left)
                make.right.equalTo(bgmenuView.snp.right)
                make.bottom.equalTo(btnView.snp.bottom)
                make.height.equalTo(0.5)
            })
            if i == sheetTitleArray.count - 1 {
                line.snp.removeConstraints()
                line.removeFromSuperview()
            }
            listSectionArray.append(btnView)
        }

        for index in stride(from: listSectionArray.count - 1, through: 0, by: -1) {
            let btn = listSectionArray[index]
            if index == listSectionArray.count - 1 {
                btn.snp.remakeConstraints({ (make) in
                    make.bottom.equalTo(bgmenuView.snp.bottom)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(40)
                })
            } else {
                let btnDownCell = listSectionArray[index + 1]
                btn.snp.remakeConstraints({ (make) in
                    make.bottom.equalTo(btnDownCell.snp.top)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(40)
                })
            }
        }
        let tapView = listSectionArray[defalutItem] as UIButton
        tapView.addSubview(self.chooseImage)
        self.chooseImage.snp.remakeConstraints { (make) in
            make.right.equalTo((tapView.snp.right)).offset(-12)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo((tapView.snp.centerY))
        }
    }

    // 没有默认选择项
    func updateHeaderView(sheetTitleArray: Array<String>, action: @escaping ListSectionChooseBlock) {
        chooseFunc = action
        listSectionArray = Array()
        titleArray = sheetTitleArray
        let sheetHight = sheetTitleArray.count * 40
        bgview.backgroundColor =  UIColor.blackColorAlphaYL(alpha: 0)

        UIView.animate(withDuration: 0.3, animations: {
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        })

        self.bgmenuView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.top)
            make.height.equalTo(sheetHight)
        }
        bgmenuView.sliderInActionWithTime(CGPoint(x: 0, y: sheetHight), time: 0.3)

        for i in stride(from: 0, to: sheetTitleArray.count, by: 1) {
            let btnView = UIButton.init()
            btnView.tag = i
            btnView.setTitleColor(UIColor.clear, for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .backgroundHighLightColorYL()), for: .highlighted)
            let lable = UILabel.init(frame: .zero)
            lable.font = UIFont.fontWithHelvetica(16)
            lable.textColor = UIColor.importTitleColor
            lable.textAlignment = .left
            let title: String =  localizedSDK(key: sheetTitleArray[i])
            btnView.setTitle(title, for: .normal)
            lable.text = title
            bgmenuView.addSubview(btnView)
            btnView.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(btnView)
                make.left.equalTo(btnView.snp.left).offset(20)
                make.right.equalTo(btnView.snp.right)
            })
            btnView.addTarget(self, action:  #selector(chooseCnacleTap(_:)), for: .touchUpInside)

            let line = UIView.init()
            line.backgroundColor = UIColor.lineMediumGrayColorYL
            btnView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(bgmenuView.snp.left)
                make.right.equalTo(bgmenuView.snp.right)
                make.bottom.equalTo(btnView.snp.bottom)
                make.height.equalTo(0.5)
            })
            if i == sheetTitleArray.count - 1 {
                line.snp.removeConstraints()
                line.removeFromSuperview()
            }
            listSectionArray.append(btnView)
        }

        for index in stride(from: listSectionArray.count - 1, through: 0, by: -1) {
            let btn = listSectionArray[index]
            if index == listSectionArray.count - 1 {
                btn.snp.remakeConstraints({ (make) in
                    make.bottom.equalTo(bgmenuView.snp.bottom)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(40)
                })
            } else {
                let btnDownCell = listSectionArray[index + 1]
                btn.snp.remakeConstraints({ (make) in
                    make.bottom.equalTo(btnDownCell.snp.top)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(40)
                })
            }
        }
    }

    func updateHeaderFromBottomView( sheetTitleArray: Array<String>, textColor: UIColor, sheetAttrTitleArray: Array<NSAttributedString>? = nil, titleBgcolor: UIColor? = nil, block: @escaping ListSectionChooseBlock) {

        chooseFunc = block
        listSectionArray = Array()
        titleArray = sheetTitleArray

        var sheetHight = sheetTitleArray.count * 45
        sheetHight = sheetHight + 55

        UIView.animate(withDuration: 0.3, animations: {
            self.bgmenuView.snp.remakeConstraints { (make) in
                make.bottom.left.right.equalTo(self)
                make.height.equalTo(sheetHight)
            }
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.5)
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.bgview.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.5)
        })

        for i in stride(from: 0, to: sheetTitleArray.count, by: 1) {
            let btnView = UIButton.init()
            btnView.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingInvieSheetBtn + "\(i)"
            btnView.setTitleColor(UIColor.clear, for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .normal)
            btnView.setBackgroundImage(UIImage.imageWithColor(color: .backgroundHighLightColorYL()), for: .highlighted)
            if titleBgcolor != nil && i == 0 {
                btnView.setBackgroundImage(UIImage.imageWithColor(color: titleBgcolor!), for: .normal)
                btnView.setBackgroundImage(UIImage.imageWithColor(color: titleBgcolor!), for: .highlighted)
                btnView.isEnabled =  false
            }

            let lable = UILabel.init(frame: .zero)
            lable.font = UIFont.fontWithHelvetica(17)
            lable.textColor = textColor
            lable.textAlignment = .center

            let title: String =  titleArray[i]
            btnView.setTitle(title, for: .normal)
            lable.text = title
            if sheetAttrTitleArray != nil  && (sheetAttrTitleArray?.count)! > i {
                let attr = sheetAttrTitleArray![i]
                lable.attributedText = attr
            }
            bgmenuView.addSubview(btnView)
            btnView.addSubview(lable)
            lable.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(btnView)
                make.left.equalTo(btnView.snp.left)
                make.right.equalTo(btnView.snp.right)
            })
            btnView.tag = i
            btnView.addTarget(self, action:  #selector(chooseTap(_:)), for: .touchUpInside)

            let line = UIView.init()
            line.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.1)
            btnView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(bgmenuView.snp.left)
                make.right.equalTo(bgmenuView.snp.right)
                make.bottom.equalTo(btnView.snp.bottom)
                make.height.equalTo(0.5)
            })
            if i == sheetTitleArray.count - 1 {
                line.snp.removeConstraints()
                line.removeFromSuperview()
            }

            if i == 0 {
                let lineUpper = UIView.init()
                lineUpper.backgroundColor = UIColor.lineMediumGrayColorYL
                btnView.addSubview(lineUpper)
                lineUpper.snp.makeConstraints({ (make) in
                    make.left.equalTo(bgmenuView.snp.left)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.top.equalTo(btnView.snp.top)
                    make.height.equalTo(0.5)
                })

            }
            listSectionArray.append(btnView)
        }

        for index in stride(from: 0, to: listSectionArray.count, by: 1) {
            let btn = listSectionArray[index]
            if index == 0 {
                btn.snp.remakeConstraints({ (make) in
                    make.top.equalTo(bgmenuView.snp.top)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(45)
                })
            } else {
                let btnUpCell =  listSectionArray[index - 1]
                btn.snp.remakeConstraints({ (make) in
                    make.top.equalTo(btnUpCell.snp.bottom)
                    make.right.equalTo(bgmenuView.snp.right)
                    make.left.equalTo(bgmenuView.snp.left)
                    make.height.equalTo(45)
                })
            }
        }

        let btnLastCell = listSectionArray.last

        let cancelView = UIView.init()
        cancelView.backgroundColor = UIColor.backgackgroundTintColorYL
        bgmenuView.addSubview(cancelView)
        cancelView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(bgmenuView)
            make.height.equalTo(10)
            make.top.equalTo((btnLastCell?.snp.bottom)!)
        })

        bgmenuView.addSubview(cancelButton)

        cancelButton.addTarget(self, action: #selector(cancelFormBottomTap), for: .touchUpInside)

        cancelButton.snp.makeConstraints({ (make) in
            make.left.right.equalTo(bgmenuView)
            make.height.equalTo(45)
            make.top.equalTo(cancelView.snp.bottom)
        })

        bgview.removeGestureRecognizer(tapCancelGe)
        tapCancelGe = UITapGestureRecognizer.init(target: self, action: #selector(cancelFormBottomTap))
        bgview.isUserInteractionEnabled = true
        bgview.addGestureRecognizer(tapCancelGe)
    }
}
