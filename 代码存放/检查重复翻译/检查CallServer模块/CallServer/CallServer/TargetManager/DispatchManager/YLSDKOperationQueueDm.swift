//
//  YLOperationQueue.swift
//  Odin-UC
//
//  Created by zlm on 2017/4/7.
//  Copyright © 2017年 yealing. All rights reserved.
//

import UIKit

class YLSDKOperationQueueDm: OperationQueue {

    init(maxCount: Int) {
        super.init()
        self.maxConcurrentOperationCount = maxCount
    }

}
