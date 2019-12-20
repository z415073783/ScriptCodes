//
//  DtmfView.swift
//  Odin-UC
//
//  Created by Apple on 23/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

class CallDtmfView: UIView {

    /** 遮罩背景图 */
    lazy var bgView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.6)
        view.isUserInteractionEnabled = true
        return view
    }()

    /** 点击区域白色背景图 */
    lazy var dtmfAreaView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 4
        return view
    }()

    var inputLabel: UILabel!
    var inputLabelStr: String = ""

    var dtmfContainer: CallDtmfKeyContainerView!
    var tap: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        initSubViews()
        addGuseter()
        self.accessibilityIdentifier = YLSDKAutoTestIDs.YLOnTalikingDTMFView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getTxtSize (inputText: NSString, font: UIFont, constrainedSize: CGSize ) -> CGSize {
        var actualSize: CGSize!
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let height: CGFloat = CGFloat(constrainedSize.height)
        let ract: CGSize =   CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        actualSize = inputText.boundingRect(with: ract, options: options, attributes: [NSAttributedStringKey.font: font], context: nil).size
        return actualSize
    }
}

extension CallDtmfView: DtmfKeyContainerViewDelegate {
    func dtmfBtnClick(dailChar: NSString) {
        inputLabelStr = (inputLabelStr.appending(dailChar as String)) as String
        // String 显示尺寸计算
        self.configTextFiled(txtFieldStr: inputLabelStr as NSString)
    }
}

extension CallDtmfView {

    func configTextFiled (txtFieldStr: NSString) {
        let font: UIFont = inputLabel.font
        let height: CGFloat = CGFloat(font.lineHeight)
        let size: CGSize = YLSDKTextView.getTxtSize(inputText: txtFieldStr, font: font, constrainedSize: CGSize.init(width: CGFloat(MAXFLOAT), height: height))
        if size.width <= inputLabel.frame.size.width {
            inputLabel.text = inputLabelStr
            return
        } else {
            let  width: CGFloat = CGFloat (inputLabel.frame.size.width)
            let  length: NSInteger = (inputLabelStr.characters.count)
            var  subTxt: NSString = inputLabelStr as NSString
            for _ in 1...length {
                subTxt = subTxt.substring(from: 1) as NSString
                let subSize: CGSize = YLSDKTextView.getTxtSize(inputText: subTxt, font: font, constrainedSize: size)
                if subSize.width < width {
                    break
                }
            }
            inputLabel.text = subTxt as String?
        }
    }

    func initData() {
    }
    func initSubViews() {
        self.backgroundColor = UIColor.clear
        initBgView()
        initTitles()
        initKeyBoard()
    }
    func initBgView() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        bgView.addSubview(dtmfAreaView)
        dtmfAreaView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 318, height: 320))
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }

    func initTitles() {
        inputLabel = UILabel.init()
        inputLabel.backgroundColor = UIColor.white
        inputLabel.font = UIFont.fontWithHelvetica(35)
        inputLabel.textColor = UIColor.importTitleColor
        inputLabel.textAlignment = .center
        inputLabel.numberOfLines = 1
        inputLabel.isUserInteractionEnabled = true
        inputLabel.isExclusiveTouch = true
        dtmfAreaView.addSubview(inputLabel)
        inputLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dtmfAreaView.snp.top)
            make.left.equalTo(dtmfAreaView.snp.left).offset(10)
            make.right.equalTo(dtmfAreaView.snp.right).offset(-10)
            make.height.equalTo(60)
        }
    }

    func initKeyBoard() {
        dtmfContainer = CallDtmfKeyContainerView.init(frame: .zero)
        dtmfContainer.delegate = self
        dtmfAreaView.addSubview(dtmfContainer)
        dtmfContainer.snp.makeConstraints { (make) in
            make.left.equalTo(dtmfAreaView.snp.left)
            make.right.equalTo(dtmfAreaView.snp.right)
            make.top.equalTo(inputLabel.snp.bottom)
            make.bottom.equalTo(dtmfAreaView.snp.bottom)
        }
       let tapCenter = UITapGestureRecognizer.init(target: self, action: #selector(dtmfAreaViewTap))
        dtmfAreaView.addGestureRecognizer(tapCenter)
    }

    func addGuseter() {
        tap = UITapGestureRecognizer.init(target: self, action: #selector(btnContainerTape))
        bgView.addGestureRecognizer(tap)
    }
    @objc func btnContainerTape() {
        self.snp.removeConstraints()
        self.removeFromSuperview()
    }
    @objc func dtmfAreaViewTap() {

    }
}
