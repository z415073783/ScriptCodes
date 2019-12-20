//
//  DtmfKeyContainerView.swift
//  Odin-UC
//
//  Created by Apple on 23/12/2016.
//  Copyright © 2016 yealing. All rights reserved.
//

import UIKit
// MARK: - 👉Struct define Area

protocol DtmfKeyContainerViewDelegate: NSObjectProtocol {
    func dtmfBtnClick(dailChar: NSString)
}
class CallDtmfKeyContainerView: UIView {
    // MARK: - 👉Property Data Area
    let numberArr: NSArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#" ]
    weak var delegate: DtmfKeyContainerViewDelegate?

    // MARK: - 👉Property UI Area
    var lineVOne: UIView!
    var lineVTwo: UIView!
    var lineHTop: UIView!
    var lineHOne: UIView!
    var lineHTwo: UIView!
    var lineHThree: UIView!
    var lineHBottom: UIView!

    // MARK: - 👉View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLineViews()
        initSubViews()
    }
    deinit {
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CallDtmfKeyContainerView {
    // MARK: - 👉UI Struct Area

    func initLineViews() {
        //竖线
        lineVOne = UIView.init(frame: CGRect.zero)
        lineVOne.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineVOne)
        lineVOne.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(self.snp.left).offset(106)
        }

        lineVTwo = UIView.init(frame: CGRect.zero)
        lineVTwo.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineVTwo)
        lineVTwo.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(self.snp.right).offset(-106)
        }

        //横线
        //顶部横线
        lineHTop = UIView.init(frame: CGRect.zero)
        lineHTop.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineHTop)
        lineHTop.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(self.snp.top)
        }

        lineHOne = UIView.init(frame: CGRect.zero)
        lineHOne.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineHOne)
        lineHOne.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(lineHTop.snp.bottom).offset(65)
        }

        lineHTwo = UIView.init(frame: CGRect.zero)
        lineHTwo.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineHTwo)
        lineHTwo.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(lineHOne.snp.bottom).offset(65)

        }

        lineHThree = UIView.init(frame: CGRect.zero)
        lineHThree.backgroundColor = UIColor.blackColorAlphaYL(alpha: 0.2)
        self.addSubview(lineHThree)
        lineHThree.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(lineHTwo.snp.bottom).offset(65)
        }
    }
    func initSubViews() {
        /** 1 */
        let dialOneBtn: UIButton = createBtn(#imageLiteral(resourceName: "1"))
        dialOneBtn.tag = 0
        dialOneBtn.accessibilityIdentifier = "DTMF1"
        self.addSubview(dialOneBtn)
        dialOneBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(lineHTop.snp.bottom)
            make.right.equalTo(lineVOne.snp.left)
            make.bottom.equalTo(lineHOne.snp.top)
        }
        dialOneBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 2 */
        let dialTwoBtn: UIButton =  createBtn(#imageLiteral(resourceName: "2"))
        dialTwoBtn.tag = 1
        dialOneBtn.accessibilityIdentifier = "DTMF2"

        dialTwoBtn.setImage(UIImage.init(named: "2"), for: .normal)

        self.addSubview(dialTwoBtn)
        dialTwoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineVOne.snp.right)
            make.top.equalTo(lineHTop.snp.bottom)
            make.right.equalTo(lineVTwo.snp.left)
            make.bottom.equalTo(lineHOne.snp.top)
        }
        dialTwoBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 3 */
        let dialThreeBtn: UIButton = createBtn(#imageLiteral(resourceName: "3"))
        dialThreeBtn.tag = 2
        dialOneBtn.accessibilityIdentifier = "DTMF3"
        
        self.addSubview(dialThreeBtn)
        dialThreeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineVTwo.snp.right)
            make.top.equalTo(lineHTop.snp.bottom)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(lineHOne.snp.top)
        }
        dialThreeBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 4 */
        let dialFourBtn: UIButton = createBtn(#imageLiteral(resourceName: "4"))
        dialFourBtn.tag = 3
        dialOneBtn.accessibilityIdentifier = "DTMF4"

        self.addSubview(dialFourBtn)
        dialFourBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(lineHOne.snp.bottom)
            make.right.equalTo(lineVOne.snp.left)
            make.bottom.equalTo(lineHTwo.snp.top)
        }
        dialFourBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 5 */
        let dialFiveBtn: UIButton =  createBtn(#imageLiteral(resourceName: "5"))
        dialFiveBtn.tag = 4
        dialOneBtn.accessibilityIdentifier = "DTMF5"

        self.addSubview(dialFiveBtn)
        dialFiveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineVOne.snp.right)
            make.top.equalTo(lineHOne.snp.bottom)
            make.right.equalTo(lineVTwo.snp.left)
            make.bottom.equalTo(lineHTwo.snp.top)
        }
        dialFiveBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 6 */
        let dialSixBtn: UIButton = createBtn(#imageLiteral(resourceName: "6"))
        dialSixBtn.tag = 5
        dialOneBtn.accessibilityIdentifier = "DTMF6"

        self.addSubview(dialSixBtn)
        dialSixBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineHOne.snp.bottom)
            make.left.equalTo(lineVTwo.snp.right)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(lineHTwo.snp.top)
        }
        dialSixBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 7 */
        let dialSevenBtn: UIButton =  createBtn(#imageLiteral(resourceName: "7"))
        dialSevenBtn.tag = 6
        dialOneBtn.accessibilityIdentifier = "DTMF7"

        self.addSubview(dialSevenBtn)
        dialSevenBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(lineHTwo.snp.bottom)
            make.right.equalTo(lineVOne.snp.left)
            make.bottom.equalTo(lineHThree.snp.top)
        }
        dialSevenBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 8 */
        let dialEightBtn: UIButton = createBtn(#imageLiteral(resourceName: "8"))
        dialEightBtn.tag = 7
        dialOneBtn.accessibilityIdentifier = "DTMF8"

        self.addSubview(dialEightBtn)
        dialEightBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineVOne.snp.right)
            make.top.equalTo(lineHTwo.snp.bottom)
            make.right.equalTo(lineVTwo.snp.left)
            make.bottom.equalTo(lineHThree.snp.top)
        }
        dialEightBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 9 */
        let dialNineBtn: UIButton =  createBtn(#imageLiteral(resourceName: "9"))
        dialNineBtn.tag = 8
        dialOneBtn.accessibilityIdentifier = "DTMF9"

        self.addSubview(dialNineBtn)
        dialNineBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineHTwo.snp.bottom)
            make.left.equalTo(lineVTwo.snp.right)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(lineHThree.snp.top)
        }
        dialNineBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** *号 */
        let dialStarBtn: UIButton = UIButton.init(type: .custom)
        dialStarBtn.setBackgroundImage(UIImage.init(named: "left_corner_nor")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch), for: .normal)
        dialStarBtn.setBackgroundImage(UIImage.init(named: "left_corner_sel")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch), for: .highlighted)
        dialStarBtn.tag = 9
        dialOneBtn.accessibilityIdentifier = "DTMFStar"


        dialStarBtn.setImage(UIImage.init(named: "plus"), for: .normal)
        self.addSubview(dialStarBtn)
        dialStarBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(lineHThree.snp.bottom)
            make.right.equalTo(lineVOne.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        dialStarBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** 0 */
        let dialZeroBtn: UIButton = createBtn(#imageLiteral(resourceName: "0"))
        dialZeroBtn.tag = 10
        dialOneBtn.accessibilityIdentifier = "DTMFZero"

        self.addSubview(dialZeroBtn)
        dialZeroBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineVOne.snp.right)
            make.top.equalTo(lineHThree.snp.bottom)
            make.right.equalTo(lineVTwo.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        dialZeroBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)

        /** #号 */
        let dialHashBtn: UIButton = UIButton.init(type: .custom)
        dialHashBtn.setBackgroundImage(UIImage.init(named: "right_corner_nor")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch), for: .normal)
        dialHashBtn.setBackgroundImage(UIImage.init(named: "right_corner_sel")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch), for: .highlighted)

        dialHashBtn.tag = 11
        dialOneBtn.accessibilityIdentifier = "DTMFHash"
        dialHashBtn.setImage(UIImage.init(named: "hash"), for: .normal)

        self.addSubview(dialHashBtn)
        dialHashBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineHThree.snp.bottom)
            make.left.equalTo(lineVTwo.snp.right)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
        dialHashBtn.addTarget(self, action: #selector(dialBtnAction(_:)), for: .touchUpInside)
    }

    @objc func dialBtnAction(_ button: UIButton) {
        var clickBtnTxt: NSString = numberArr.object(at: button.tag) as! NSString
        if (clickBtnTxt .isEqual(to: ".")) {
            clickBtnTxt = "*"
        }
        CallServerDataSource.getInstance.sendDtmf(soundId: clickBtnTxt as String )
        if (delegate != nil) {
            delegate?.dtmfBtnClick(dailChar: clickBtnTxt)
        }
    }

    func createBtn(_ btnImage: UIImage) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.dialPadBgColor()), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.dialPadKeyClickBgColor()), for: .highlighted)
        button.setImage(btnImage, for: .normal)
        return button
    }
}
