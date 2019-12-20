//
//  DispatchManager.swift
//  Odin-UC
//
//  Created by zlm on 2017/2/6.
//  Copyright © 2017年 yealing. All rights reserved.
//

import UIKit

class YLSDKDispatchManager: NSObject {

    //线程锁
    fileprivate static var _lock: NSRecursiveLock = NSRecursiveLock()
    class func lock() {
        YLSDKDispatchManager._lock.lock()
    }
    class func unlock() {
        YLSDKDispatchManager._lock.unlock()
    }

    //队列 //数据计算,用于刷新UI的数据处理
    private static var _updateOperatorQueue = YLSDKOperationQueueDm(maxCount: 3)
    class var updateOperatorQueue: YLSDKOperationQueueDm {
        get {
            return _updateOperatorQueue
        }
    }
//    rpc专用
    private static var _interfaceOperatorQueue = YLSDKOperationQueueDm(maxCount: 10)
    class var interfaceOperatorQueue: YLSDKOperationQueueDm {
        get {

            return _interfaceOperatorQueue
        }
    }
    //下载图片
    private static var _imageQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var imageQueue: YLSDKOperationQueueDm {
        get {
            return _imageQueue
        }
    }

    //拉取会议信息雷鸟
    private static var _meetingQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var meetingQueue: YLSDKOperationQueueDm {
        get {
            return _meetingQueue
        }
    }

    //网络数据相关
    private static var _dataQueue = YLSDKOperationQueueDm(maxCount: 10)
    class var dataQueue: YLSDKOperationQueueDm {
        get {
            return _dataQueue
        }
    }

    //搜索线程
    private static var _searchQueue = YLSDKOperationQueueDm(maxCount: 2)
    class var searchQueue: YLSDKOperationQueueDm {
        get {
            return _searchQueue
        }
    }

    //推送线程
    private static var _pushQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var pushQueue: YLSDKOperationQueueDm {
        get {
            return _pushQueue
        }
    }

    //通话线程
    private static var _callQueue = YLSDKOperationQueueDm(maxCount: 2)
    class var callQueue: YLSDKOperationQueueDm {
        get {
            return _callQueue
        }
    }
    
    //会议控制列表相关
    private static var _meetingControlQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var meetingControlQueue: YLSDKOperationQueueDm {
        get {
            return _callQueue
        }
    }

    //提前加载数据
    private static var _advanceQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var advanceQueue: YLSDKOperationQueueDm {
        get {
            return _advanceQueue
        }
    }

    //音视频引擎开闭线程 不要移除
    private static var _videoEngineQueue = YLSDKOperationQueueDm(maxCount: 2)
    class var videoEngineQueue: YLSDKOperationQueueDm {
        get {
            return _videoEngineQueue
        }
    }

    // 意见反馈上传
    private static var _feedBackUploadQueue = YLSDKOperationQueueDm(maxCount: 1)
    class var feedBackUploadQueue: YLSDKOperationQueueDm {
        get {
            return _feedBackUploadQueue
        }
    }

    //移除所有队列中的任务
    class func removeAllOperations() {
        YLSDKDispatchManager.updateOperatorQueue.cancelAllOperations()
        YLSDKDispatchManager.interfaceOperatorQueue.cancelAllOperations()
        YLSDKDispatchManager.imageQueue.cancelAllOperations()
        YLSDKDispatchManager.dataQueue.cancelAllOperations()
        YLSDKDispatchManager.advanceQueue.cancelAllOperations()
        YLSDKDispatchManager.pushQueue.cancelAllOperations()
        YLSDKDispatchManager.searchQueue.cancelAllOperations()
    }

}
