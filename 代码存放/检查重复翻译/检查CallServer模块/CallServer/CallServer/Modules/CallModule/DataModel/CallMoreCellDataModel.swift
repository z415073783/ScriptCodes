//
//  CallMoreCellDataModel.swift
//  Odin-YMS
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

class CallMoreCellDataModel: NSObject {
    var titleStr: String = ""
    var imageNorName: String = ""

    var titleStrSel: String = ""
    var iamgeSelName: String = ""

    var type: CallMoreCellType = .unknow
    var showSelectView: Bool = false

}
