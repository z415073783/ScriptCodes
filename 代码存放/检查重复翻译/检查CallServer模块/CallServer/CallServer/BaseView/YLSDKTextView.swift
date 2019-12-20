//
//  YLTextView.swift
//  UME
//
//  Created by zlm on 16/8/16.
//  Copyright © 2016年 yealink. All rights reserved.
//用于点击回收键盘

import UIKit
import YLBaseFramework
class YLSDKTextView: UITextView {

    var placeholder: String? {
        didSet {
            placeholderTextView.text = placeholder
            updatePlaceholder()
        }
    }

    private lazy var placeholderTextView: UITextView = {
        let view = UITextView(frame: .zero)

        view.backgroundColor = .clear
        view.textColor = UIColor.textMediumGrayColorYL
        view.isUserInteractionEnabled = false

        return view
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperty()
    }

    func initProperty() {
        textColor = UIColor.textBlackColorYL

        addSubview(placeholderTextView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: .UITextViewTextDidChange,
                                               object: self)

        updatePlaceholder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ExecuteOnMainThread {[weak self] in
            if let bounds = self?.bounds {
                self?.placeholderTextView.frame = bounds
            }
        }
    }

    override var text: String? {
        didSet {
            updatePlaceholder()
        }
    }

    class open func getTxtSize (inputText: NSString, font: UIFont, constrainedSize: CGSize ) -> CGSize {
        var actualSize: CGSize
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let height: CGFloat = CGFloat(constrainedSize.height)
        let ract: CGSize =   CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        actualSize = inputText.boundingRect(with: ract, options: options, attributes: [NSAttributedStringKey.font: font], context: nil).size
        return actualSize
    }
}

private typealias __Actions = YLSDKTextView
extension __Actions {

    func updatePlaceholder() {
        placeholderTextView.font = font
        placeholderTextView.contentInset = contentInset
        placeholderTextView.textContainerInset = textContainerInset

        if let text = text {
            placeholderTextView.isHidden = text.characters.count > 0
        } else {
            placeholderTextView.isHidden = true
        }
    }

    @objc func textDidChange(_ sender: Any) {
        updatePlaceholder()
    }
}
