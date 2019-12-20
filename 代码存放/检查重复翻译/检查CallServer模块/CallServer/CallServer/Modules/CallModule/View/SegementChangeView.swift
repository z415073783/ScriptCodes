//
//  SegementChangeView.swift
//  Odin-UC
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit

typealias segClickActionBlock = (_ chooseIndex: Int) -> Void

class SegementChangeView: UIView {
    //代理
    var segChooseBlock: segClickActionBlock!

    /** 左侧按钮 */
    var leftButton: UIButton = {
        let button = UIButton.init()
        button.tag = 0
        button.titleLabel?.font = UIFont.fontWithHelvetica(17)
        button.backgroundColor = .clear
        return button
    }()
    /** 左侧滑动滚动条 */
    var lineLeftView: UIView = {
        let view = UIView.init()
        return view
    }()

    var normalColor: UIColor?

    var selectColor: UIColor?

    /** 右侧按钮 */
    var rightButton: UIButton = {
        let button = UIButton.init()
        button.tag = 1
        button.titleLabel?.font = UIFont.fontWithHelvetica(17)
        button.backgroundColor = .clear
        return button
    }()

    /** 右侧滑动滚动条 */
    var lineRightView: UIView = {
        let view = UIView.init()
        return view
    }()

    /** 底部分割线 */
    var splitLineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.5)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SegementChangeView {
    func updateSegementChange(leftTitle: String, rightTitle: String, normalColor: UIColor, selectColor: UIColor, block: @escaping segClickActionBlock) {

        segChooseBlock = block
        self.backgroundColor = UIColor.backgackgroundTintColorYL
        self.normalColor = normalColor
        self.selectColor = selectColor

        self.addSubview(leftButton)
        self.addSubview(lineLeftView)

        self.addSubview(rightButton)
        self.addSubview(lineRightView)

        self.addSubview(splitLineView)

        leftButton.setTitle(leftTitle, for: .normal)
        leftButton.setTitleColor(selectColor, for: .normal)
        lineLeftView.backgroundColor = selectColor

        rightButton.setTitleColor(normalColor, for: .normal)
        rightButton.setTitle(rightTitle, for: .normal)
        lineRightView.backgroundColor = UIColor.clear

        leftButton.addTarget(self, action: #selector(touchUpAction(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(touchUpAction(_:)), for: .touchUpInside)

        leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top).offset(2)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }

        lineLeftView.snp.makeConstraints { (make) in
            make.top.equalTo(leftButton.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(120)
            make.centerX.equalTo(leftButton.snp.centerX)
        }

        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(2)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }

        lineRightView.snp.makeConstraints { (make) in
            make.top.equalTo(rightButton.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(120)
            make.centerX.equalTo(rightButton.snp.centerX)
        }

        splitLineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

    func updateSegChoose(int: Int) {
        if (int == 0) {
            leftButton.setTitleColor(selectColor, for: .normal)
            lineLeftView.backgroundColor = selectColor

            rightButton.setTitleColor(normalColor, for: .normal)
            lineRightView.backgroundColor = UIColor.clear

            leftButton.isSelected = true
            rightButton.isSelected = false
        } else if (int == 1) {
            rightButton.setTitleColor(selectColor, for: .normal)
            lineRightView.backgroundColor = selectColor

            leftButton.setTitleColor(normalColor, for: .normal)
            lineLeftView.backgroundColor = UIColor.clear

            leftButton.isSelected = false
            rightButton.isSelected = true
        }
    }

    func updateSegChooseAndBlockFlush(int: Int) {
        if leftButton.isSelected == true && leftButton.tag == int {
            return
        } else  if rightButton.isSelected == true &&  rightButton.tag == int {
            return
        } else {
            updateSegChoose(int: int)
            if segChooseBlock != nil {
                segChooseBlock(int)
            }
        }
    }

    @objc func touchUpAction(_ button: UIButton) {
        updateSegChoose(int: button.tag)
        if segChooseBlock != nil {
            segChooseBlock(button.tag)
        }
    }
}
