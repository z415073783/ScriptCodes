//
//  NetworkManager.swift
//  Odin-UC
//
//  Created by zlm on 2016/11/24.
//  Copyright © 2016年 yealing. All rights reserved.
//

import UIKit

class SDKNetworkManager: NSObject {
    static let getInstance = SDKNetworkManager()
    private var _reachability: Reachability?
    var _netStateChange: Bool = false

    var reachability: Reachability? {
        get {
            if _reachability == nil {
                _reachability = Reachability()
            }
            return _reachability
        }
    }

    class func start() {
        let reach = SDKNetworkManager.getInstance.reachability
        reach?.whenReachable = {(obj) in
            SDKNetworkManager.getInstance.networkStateChangeNotification()
        }
        reach?.whenUnreachable = {(obj) in
            SDKNetworkManager.getInstance.networkStateChangeNotification()
        }

        do {
            try reach?.startNotifier()
        } catch {
            YLSDKLOG.debug("调用网络监控失败")
        }
    }
    class func stop() {
        SDKNetworkManager.getInstance.reachability?.stopNotifier()
    }
    func networkStateChangeNotification() {
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object:SDKNetworkManager.getInstance.reachability)
    }
    var _isOpenCheck4G: Bool = true
    var isOpenCheck4G: Bool {
        set {
            _isOpenCheck4G = newValue
        }
        get {
            return _isOpenCheck4G
        }
    }

}
