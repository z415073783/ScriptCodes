//
//  MeetingMemberMessageController.swift
//  Odin-YMS
//
//  Created by soft7 on 2017/11/1.
//  Copyright © 2017年 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework

class MeetingMemberMessageController: YLBasicViewController {
    
    // MARK: - 👉 lifeCycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHex(hexColor: "#000000", alpha: 0.5)
        
        initLayoutUI()
        updateLayoutUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyMessageUpdate(_:)),
                                               name: keyConferencsMessageListInfoUpdate,
                                               object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(.zero, animated: false)
        requestMessage()
    }
    
    // MARK: - 👉 Notification
    @objc func notifyMessageUpdate(_ sender: Notification) {
        ExecuteOnMainThread { [weak self] in
            guard let `self` = self else { return }
            self.requestMessage()
        }
    }
    
    // MARK: - 👉 ui
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityIdentifier = "MessageContentView"
        
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var titleLabel: YLBasicLabel = {
        let view = YLBasicLabel(frame: .zero)
        view.accessibilityIdentifier = "MessageTitleView"
        
        view.backgroundColor = UIColor.colorWithHex(hexColor: "#2699f4", alpha: 1)
        view.textAlignment = .center
        view.font = UIFont.fontWithHelvetica(18)
        view.textColor = UIColor.white
        view.text = YLSDKLanguage.YLSDKMeetingMemberMessageList
        
        view.isUserInteractionEnabled = true
        view.dTap.setup(withTarget: self, selector: #selector(titleLabelDidTap(_:)))
        
        return view
    }()
    
    @objc func titleLabelDidTap(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    lazy var emptyView: MeetingMemberMessageEmptyView = {
        let view = MeetingMemberMessageEmptyView(frame: .zero)
        view.accessibilityIdentifier = "emptyView"
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.accessibilityIdentifier = "MessageTableView"
        
        view.dataSource = self
        view.delegate = self
        
        view.separatorStyle = .none
        
        view.backgroundView = UIView()
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var closeButton: YLBasicButton = {
        let view = YLBasicButton(frame: .zero)
        view.accessibilityIdentifier = "closeButton"
        view.setImage(#imageLiteral(resourceName: "MeetingMessageClose"), for: .normal)
        view.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
        return view
    }()
    
    @objc func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - 👉 layout
    func initLayoutUI() {
        view.addSubview(contentView)
        contentView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            
            make.top.greaterThanOrEqualTo(20)
            make.bottom.lessThanOrEqualTo(-10 - 40 - 20)
            
            make.centerY.equalToSuperview().offset(-30).priority(999)
            make.height.equalTo(240).priority(999)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(emptyView)
        emptyView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(tableView)
        tableView.isHidden = true
        tableView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(contentView.snp.bottom).offset(10)
        }
    }
    
    func updateLayoutUI() {
        tableView.isHidden = messageArray.count == 0
        emptyView.isHidden = !tableView.isHidden
        
        var contentHeight = tableView.contentSize.height + 60
        contentHeight = max(contentHeight, 360)
        contentHeight = min(contentHeight, 360)
        
        contentHeight = tableView.isHidden ? 360 : 360
        
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentHeight).priority(999)
        }
    }
    
    // MARK: - 👉 data
    var messageArray = [MeetingMemberMessage.Message]()
    
    // 当前请求数据的operation，下次请求时取消先前请求
    private var requestingOperation: BlockOperation?
    
    func requestMessage() {
        requestingOperation?.cancel()
        requestingOperation = nil
        
        tableView.isHidden = false
        emptyView.isHidden = true
        
        let index = messageArray.first?.index ?? 0
        
        requestingOperation = MeetingMemberMessage.Intput(nCallId: CallServerDataSource.getInstance.getCallId(),
                                                          nStartIndex: index)
            .getDataQueue(name: MeetingMemberMessage.interfaceName,
                          BodyClass: MeetingMemberMessage.Output.self) { [weak self] (output, result) in
                            guard let `self` = self else { return }
                            if let output = output {
                                var newMessageArray = output.confMsgList
                                newMessageArray.append(contentsOf: self.messageArray)
                                self.messageArray = newMessageArray
                            }
                            self.dataDidUpdate()
        }
    }
    
    func dataDidUpdate() {
        tableView.reloadData()
        updateLayoutUI()
    }
    
    // MARK: - 👉 callback
//    typealias ReceiveNewMessageClosure = (_ sender: MeetingMemberMessageController) -> Void
//    var receiveNewMessageCallback: ReceiveNewMessageClosure?
//    func assignReceiveNewMessageCallback(_ callback: ReceiveNewMessageClosure?) {
//        receiveNewMessageCallback = callback
//    }
}

// MARK: - 👉 Extensions
private typealias __UITableViewDataSource__ = MeetingMemberMessageController
extension __UITableViewDataSource__: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MeetingMemberMessageCell.dequque(withTableView: tableView, indexPath: indexPath)
        return cell
    }
    
}

private typealias __UITableViewDelegate__ = MeetingMemberMessageController
extension __UITableViewDelegate__: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageArray[indexPath.row]
        let newestMessage = messageArray.first ?? message
        
        return MeetingMemberMessageCell.preferHeight(withTableView: tableView,
                                                     message: message,
                                                     maxTimeStr: newestMessage.getTimeStr())
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MeetingMemberMessageCell {
            let message = messageArray[indexPath.row]
            let newestMessage = messageArray.first ?? message
            
            cell.reload(withMessage: message,
                        maxTimeStr: newestMessage.getTimeStr(),
                        isShowTime: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
