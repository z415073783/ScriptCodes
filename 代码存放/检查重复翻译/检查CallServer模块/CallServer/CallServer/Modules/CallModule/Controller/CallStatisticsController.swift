//
//  CallStatisticsController.swift
//  Odin-YMS
//
//  Created by Apple on 03/05/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit
import YLBaseFramework
// MARK: - 👉Struct define Area

let callStatisticsCellIdentifier: String = "CallStatisticsCell"
let callStatisticsHeaderCellIdentifier: String = "CallStatisticsHeaderCell"
let callStatisticsHoriCellIdentifier: String = "CallStatisticsHoriCell"
class CallStatisticsController: YLBlueCallViewController {
    // MARK: - 👉Property Data Area

    /** Verticaltable 布局 true 表示垂直布局， false 表示水平布局 */
    var verticalOrHorizontalLayout: Bool = true
    var callInfoArray: Array = ["Video", "Resolution", "Codec", "Bandwidth", "Frame Rate", "Jitter", "Total Lost", "Lost Percent", "Audio", "Codec", "Bandwidth", "Sample Rate", "Jitter", "Total Lost", "Lost Percent", "Auxiliary flow", "Resolution", "Codec", "Bandwidth", "Frame Rate"]

    /** 统计 通话信息结构体 */
    var talkstatistics: TalkStatistics?
    /** 0: 发送 send , 1: 接收 received */

    var sendorReceivedData: Int = 0
    /** 计时器 YLTimer*/
    var timer: YLTimer?

    // MARK: - 👉Property UI Area

    /** 统计 Verticaltable */
    var callStatisticsTable: UITableView?

    /** 统计 Verticaltable Header */
    /** 统计 Verticaltable */
    var headerView: TransparentView = {

        let bgView = UIView()
        bgView.backgroundColor = UIColor.dailHeaderBtnTextColor(alpha: 1)
        bgView.frame = CGRect.init(x: 0, y: 0, width: Int(kScreenWidth  > kScreenHight ? kScreenWidth: kScreenHight), height: 102)
        let uiView = TransparentView.dropHeaderView(withFrame: CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: 102), contentView: bgView, stretch: bgView)
        return uiView!
    }()

    /** 统计 总带宽 */
    var totalBandwidthLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.fontWithHelvetica(14)
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.text = YLSDKLanguage.YLSDKTotalBandwidth//
        return label
    }()

    /** 统计 信号强度 */
    var callinfoImage: UIImageView = {
        let imageview = UIImageView.init()
        return imageview
    }()

    /** 统计 发送信息总量 */
    var sendInfoLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.fontWithHelvetica(14)
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.text = ""
        return label
    }()

    /** 统计 接收信息总量 */
    /** 统计 接收信息总量 */
    var receiveInfoLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.fontWithHelvetica(14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = ""
        return label
    }()

    /** 统计 协议名 */
    var protocolNameLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.fontWithHelvetica(10)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor =  UIColor.whiteColorAlphaYL(alpha: 0.6)
        label.text = ""
        return label
    }()

    /** 统计 接收设备名 */
    var receiveDeviceNameLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.fontWithHelvetica(10)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = UIColor.whiteColorAlphaYL(alpha: 0.6)
        label.text = ""
        return label
    }()

    var segChangeView: SegementChangeView?
    /** 左滑手势 */
    var swipeLeftRecognizer: UIPanGestureRecognizer?

    var beginPosition: CGPoint?

    /** 右滑手势 */
    var swipeRightRecognizer: UISwipeGestureRecognizer!

    // MARK: - 👉View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = YLSDKLanguage.YLSDKCurrentCallStatistics
        setNavaCoclor()
        setupUI()
        setUpData()
        createTimer()
    }

    override func closeCurrentController() {
        self.dismiss(animated: true) {

        }
    }
//    override func closeCurrentController(_ sender: UIButton?) {
//
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        addLeftReturnAndTitleButton(.white, true, false, nil, "close_nor")
        checkViewLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        YLSDKLogger.debug("CallStatisticsController - deinit")
        if timer != nil {
            timer?.invalidate()
        }
    }
}

// MARK: - 👉UITableViewDataSource

extension CallStatisticsController :UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 15) {
            let cell: CallStatisticsHeaderCell?
            cell = tableView.dequeueReusableCell(withIdentifier: callStatisticsHeaderCellIdentifier, for: indexPath) as? CallStatisticsHeaderCell
            cell?.selectionStyle = .none
            let str = callInfoArray[ indexPath.row]
            if (indexPath.row == 0) {
                cell?.updateUI(stringLeft: str)
            } else if (indexPath.row == 8) {
                cell?.updateUI(stringLeft: str)
            } else if (indexPath.row == 15) {
                cell?.updateUI(stringLeft: str)
            }
            if let returnCell = cell {
                return returnCell
            } else {
                return UITableViewCell.init()
            }
        } else {

            if verticalOrHorizontalLayout == false {
                let cell: CallStatisticsHoriCell?
                cell = tableView.dequeueReusableCell(withIdentifier: callStatisticsHoriCellIdentifier, for: indexPath) as? CallStatisticsHoriCell

                let leftClassName = callInfoArray[ indexPath.row]
                let sendInfoStr = getSendData(index: indexPath.row)
                let receiveInfoStr = getReceivedData(index: indexPath.row)
                cell?.updateUI(classString: leftClassName, sendString: sendInfoStr, receiveString: receiveInfoStr)
                cell?.selectionStyle = .none
                if let retunCell = cell {
                    return retunCell
                } else {
                    return UITableViewCell.init()
                }
            } else {
                let cell: CallStatisticsCell?
                cell = tableView.dequeueReusableCell(withIdentifier: callStatisticsCellIdentifier, for: indexPath) as? CallStatisticsCell
                var strRight: String = "--"
                if sendorReceivedData == 0 {
                    strRight = getSendData(index: indexPath.row)
                } else if (sendorReceivedData == 1) {
                    strRight = getReceivedData(index: indexPath.row)
                }
                let leftClassName = callInfoArray[ indexPath.row]
                cell?.updateUI(stringLeft: leftClassName, stringRight: strRight)
                cell?.selectionStyle = .none
                if let returnCell = cell {
                    return returnCell
                } else {
                    return UITableViewCell()
                }
            }
        }
    }
}

// MARK: - 👉UITableViewDelegate
extension CallStatisticsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 15) {
            return 45
        }
        return 30
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if verticalOrHorizontalLayout == false {
            let view = CallStatisticsHorizontalHeader.init()
            view.updateHeaderView(sendTitle: YLSDKLanguage.YLSDKSend , receiveTitle: YLSDKLanguage.YLSDKReceive)
            view.backgroundColor = UIColor.white
            view.bounds =  CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: 45)
            return view
        } else {
            segChangeView = SegementChangeView.init()
            segChangeView?.updateSegementChange(leftTitle: YLSDKLanguage.YLSDKSend, rightTitle: YLSDKLanguage.YLSDKReceive, normalColor:  UIColor.textGrayColorYL, selectColor: UIColor.dailHeaderBtnTextColor(alpha: 1), block: { (index) in
                self.sendorReceivedData = index
            })
            segChangeView?.updateSegChoose(int: sendorReceivedData)
            segChangeView?.backgroundColor =  UIColor.white
            segChangeView?.bounds =  CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: 45)
            return segChangeView
        }
    }

}

extension CallStatisticsController :UIScrollViewDelegate {

}
// MARK: - 👉Private Method

extension CallStatisticsController {
    // MARK: - 👉UI Struct Area

    func setNavaCoclor() {
        let color = UIColor.mainColorYL
        let image = UIImage.imageWithColor(color: color)
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.isTranslucent = false
    }

    fileprivate func setupUI() {
        initTable()
        initHeaderSubView()
        addListener()
        addGestureRecognizer()
    }

    fileprivate func initTable() {
        callStatisticsTable = UITableView(frame: CGRect.zero, style: .plain)
        callStatisticsTable?.backgroundColor = UIColor.white
        callStatisticsTable?.delegate = self
        callStatisticsTable?.dataSource = self
        callStatisticsTable?.register(CallStatisticsCell.self, forCellReuseIdentifier: callStatisticsCellIdentifier)

        callStatisticsTable?.register(CallStatisticsHeaderCell.self, forCellReuseIdentifier: callStatisticsHeaderCellIdentifier)

        callStatisticsTable?.register(CallStatisticsHoriCell.self, forCellReuseIdentifier: callStatisticsHoriCellIdentifier)

        callStatisticsTable?.separatorStyle = .none
        if let table = callStatisticsTable {
            view.addSubview(table)
            table.snp.remakeConstraints { (make) in
                make.edges.equalTo(self.view.snp.edges)
            }
        }
        
    }

    fileprivate func initHeaderSubView() {
        headerView.frame =  CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: 102)
        callStatisticsTable?.tableHeaderView = headerView

        headerView.addSubview(totalBandwidthLabel)
        headerView.addSubview(callinfoImage)
        headerView.addSubview(sendInfoLabel)
        headerView.addSubview(receiveInfoLabel)
        headerView.addSubview(protocolNameLabel)
        headerView.addSubview(receiveDeviceNameLabel)

        totalBandwidthLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(12)
            make.bottom.equalTo(headerView.snp.bottom).offset(-78)
            make.right.equalTo(view.snp.right).offset(-12)
        }

        callinfoImage.snp.remakeConstraints { (make) in
            make.bottom.equalTo(headerView.snp.bottom).offset(-38)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize.init(width: 84, height: 40))
        }

        sendInfoLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(12)
            make.right.equalTo(callinfoImage.snp.left).offset(-5)
            make.centerY.equalTo(callinfoImage)
        }

        receiveInfoLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(callinfoImage.snp.right).offset(5)
            make.right.equalTo(view.snp.right).offset(-12)
            make.centerY.equalTo(callinfoImage)
        }

        protocolNameLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(callinfoImage.snp.centerX)
            make.top.equalTo(callinfoImage.snp.bottom).offset(3)
            make.right.equalTo(view.snp.right).offset(-12)
            make.left.equalTo(view.snp.left).offset(12)
        }

        receiveDeviceNameLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-12)
            make.left.equalTo(view.snp.left).offset(12)
            make.bottom.equalTo(headerView.snp.bottom).offset(-8)
            make.centerX.equalTo(callinfoImage.snp.centerX)
        }
    }

    func checkViewLayout() {
        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
            verticalOrHorizontalLayout = true
            callStatisticsTable?.reloadData()
        } else if UIInterfaceOrientationIsLandscape((UIApplication.shared.statusBarOrientation)) {
            verticalOrHorizontalLayout = false
            callStatisticsTable?.reloadData()
        }
    }
    fileprivate func setUpData() {
        sendorReceivedData = 0
        talkstatistics = YLLogicAPI.getCallStatistics(Int32(CallServerDataSource.getInstance.getCallId()))
    }

    fileprivate func createTimer() {
        timer = Timer.scheduledTimerYL(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.keepWatchCallData()
        })
    }
    func endTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    func keepWatchCallData() {
        talkstatistics = YLLogicAPI.getCallStatistics(Int32(CallServerDataSource.getInstance.getCallId()))
        if let thisInfo:TalkStatistics = talkstatistics {
            callStatisticsTable?.reloadData()
            sendInfoLabel.text = YLSDKLanguage.YLSDKSend + ":"+thisInfo.m_strTotalBandwidthSend
            receiveInfoLabel.text = YLSDKLanguage.YLSDKReceive  + ":"+thisInfo.m_strTotalBandwidthRecv
            protocolNameLabel.text = YLSDKLanguage.YLSDKProtocol + ":"+thisInfo.m_strProtocol
            receiveDeviceNameLabel.text = YLSDKLanguage.YLSDKReceivingEquipment + ":" + thisInfo.m_strUserAgent
            if CallServerDataSource.getInstance.getCallType() == .video {
                let videoLostPercentSend = thisInfo.m_strVideoLostPercentSend as NSString
                let videoLostPercentRecv = thisInfo.m_strVideoLostPercentRecv as NSString

                if let resultSend = Int(videoLostPercentSend.substring(to: videoLostPercentSend.length - 1)) {
                    if let resultRecv = Int(videoLostPercentRecv.substring(to: videoLostPercentRecv.length - 1)) {
                        if resultSend > resultRecv {
                            CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultSend)
                        } else {
                            CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultRecv)
                        }
                    }
                }
            } else if CallServerDataSource.getInstance.getCallType() == .voice {
                let audioLostPercentSend = thisInfo.m_strAudioLostPercentSend as NSString
                let audioLostPercentRecv = thisInfo.m_strAudioLostPercentRecv as NSString

                if let resultSend = Int(audioLostPercentSend.substring(to: audioLostPercentSend.length - 1)) {
                    if let resultRecv = Int(audioLostPercentRecv.substring(to: audioLostPercentRecv.length - 1)) {
                        if resultSend > resultRecv {
                            CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultSend)
                        } else {
                            CallServerDataSource.getInstance.setLostDataPercentInt(currentPercentDataInt: resultRecv)
                        }
                    }
                }
            }

            let singleCount = CallServerDataSource.getInstance.getSingleCount()

            if singleCount == 0 {
                callinfoImage.image = UIImage.init(named: "call_info_0")
            } else if singleCount == 1 {
                callinfoImage.image = UIImage.init(named: "call_info_1")
            } else if singleCount == 2 {
                callinfoImage.image = UIImage.init(named: "call_info_2")
            } else if singleCount == 3 {
                callinfoImage.image = UIImage.init(named: "call_info_3")
            } else if singleCount == 4 {
                callinfoImage.image = UIImage.init(named: "call_info_4")
            } else {
                callinfoImage.image = UIImage.init(named: "call_info_0")
            }
        }
    }

    fileprivate func getSendData(index: Int) -> String {

        if talkstatistics == nil {
            return "--"
        }
        if let thisinfo = talkstatistics {
            switch index {
            case 1:
                return (thisinfo.m_strVideoResolutionSend != nil) ? thisinfo.m_strVideoResolutionSend : "--"
            case 2:
                return (thisinfo.m_strVideoCodecSend != nil) ? thisinfo.m_strVideoCodecSend :  "--"
            case 3:
                return (thisinfo.m_strVideoBandwidthSend != nil) ? thisinfo.m_strVideoBandwidthSend : "--"
            case 4:
                return (thisinfo.m_strVideoFrameRateSend != nil) ? thisinfo.m_strVideoFrameRateSend : "--"
            case 5:
                return (thisinfo.m_strVideoJitterSend != nil) ? thisinfo.m_strVideoJitterSend : "--"
            case 6:
                return (thisinfo.m_strVideoTotalLostSend != nil) ? thisinfo.m_strVideoTotalLostSend : "--"
            case 7:
                return (thisinfo.m_strVideoLostPercentSend != nil) ? thisinfo.m_strVideoLostPercentSend : "--"
                
            case 9:
                return (thisinfo.m_strAudioCodecSend != nil) ? thisinfo.m_strAudioCodecSend : "--"
            case 10:
                return (thisinfo.m_strAudioBandwidthSend != nil) ? thisinfo.m_strAudioBandwidthSend : "--"
            case 11:
                return (thisinfo.m_strAudioSampleRateSend != nil) ? thisinfo.m_strAudioSampleRateSend : "--"
            case 12:
                return (thisinfo.m_strAudioJitterSend != nil) ? thisinfo.m_strAudioJitterSend : "--"
            case 13:
                return (thisinfo.m_strAudioTotalLostSend != nil) ? thisinfo.m_strAudioTotalLostSend : "--"
            case 14:
                return (thisinfo.m_strAudioLostPercentSend != nil) ? thisinfo.m_strAudioLostPercentSend : "--"
            case 16:
                return "--"
                
            case 17:
                return "--"
            case 18:
                return "--"
            case 19:
                return "--"
            default:
                return "--"
            }
        }
        return "--"

    }

    fileprivate func getReceivedData(index: Int) -> String {
        if talkstatistics == nil {
            return "--"
        }
        if let thisinfo = talkstatistics {
            switch index {
            case 1:
                return (thisinfo.m_strVideoResolutionRecv != nil) ? thisinfo.m_strVideoResolutionRecv : "--"
            case 2:
                return (thisinfo.m_strVideoCodecRecv != nil) ? thisinfo.m_strVideoCodecRecv : "--"
            case 3:
                return (thisinfo.m_strVideoBandwidthRecv != nil) ? thisinfo.m_strVideoBandwidthRecv : "--"
            case 4:
                return (thisinfo.m_strVideoFrameRateRecv != nil) ? thisinfo.m_strVideoFrameRateRecv : "--"
            case 5:
                return (thisinfo.m_strVideoJitterRecv != nil) ? thisinfo.m_strVideoJitterRecv : "--"
            case 6:
                return (thisinfo.m_strVideoTotalLostRecv != nil) ? thisinfo.m_strVideoTotalLostRecv : "--"
            case 7:
                return (thisinfo.m_strVideoLostPercentRecv != nil) ? thisinfo.m_strVideoLostPercentRecv : "--"
                
            case 9:
                return (thisinfo.m_strAudioCodecRecv != nil) ? thisinfo.m_strAudioCodecRecv : "--"
            case 10:
                return (thisinfo.m_strAudioBandwidthRecv != nil) ? thisinfo.m_strAudioBandwidthRecv : "--"
            case 11:
                return (thisinfo.m_strAudioSampleRateRecv != nil) ? thisinfo.m_strAudioSampleRateRecv : "--"
            case 12:
                return (thisinfo.m_strAudioJitterRecv != nil) ? thisinfo.m_strAudioJitterRecv : "--"
            case 13:
                return (thisinfo.m_strAudioTotalLostRecv != nil) ? thisinfo.m_strAudioTotalLostRecv : "--"
            case 14:
                return (thisinfo.m_strAudioLostPercentRecv != nil) ? thisinfo.m_strAudioLostPercentRecv : "--"
                
            case 16:
                return (thisinfo.m_strShareResolutionRecv != nil) ? thisinfo.m_strShareResolutionRecv : "--"
            case 17:
                return (thisinfo.m_strShareCodecRecv != nil) ? thisinfo.m_strShareCodecRecv : "--"
            case 18:
                return (thisinfo.m_strShareBandwidthRecv != nil) ? thisinfo.m_strShareBandwidthRecv : "--"
            case 19:
                return (thisinfo.m_strShareFrameRateRecv != nil) ? thisinfo.m_strShareFrameRateRecv : "--"
            default:
                return "--"
            }
        }
        return "--"
    }

    // MARK: - 👉UI GE Area
    fileprivate func addGestureRecognizer() {
        let swipeLeftRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(pan:)))
        view.addGestureRecognizer(swipeLeftRecognizer)
        
    }
    @objc func panGesture(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            beginPosition = pan.location(in: view)

        case .changed:
            let point = pan.location(in: view)
            if let biginPosi = beginPosition {
                let distance = point.x - (biginPosi.x)
                if distance < 0 {
                    swipeLeft()
                }
                if distance > 0 {
                    swipeRight()
                }
            }
        default:
            break

        }
    }
    func swipeLeft() {
        if verticalOrHorizontalLayout == true {
            if segChangeView != nil {
                segChangeView?.updateSegChooseAndBlockFlush(int: 1)
                sendorReceivedData = 1
                callStatisticsTable?.reloadData()
            }
        }
    }

    func swipeRight() {
        if verticalOrHorizontalLayout == true {
            if segChangeView != nil {
                segChangeView?.updateSegChooseAndBlockFlush(int: 0)
                sendorReceivedData = 0
                callStatisticsTable?.reloadData()
            }
        }
    }

    // MARK: - 👉Listener Area

    fileprivate func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }

    @objc func deviceOrientationDidChange() {
        if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
            verticalOrHorizontalLayout = true
            callStatisticsTable?.reloadData()
        } else if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
            verticalOrHorizontalLayout = false
            callStatisticsTable?.reloadData()
        }
    }

}
