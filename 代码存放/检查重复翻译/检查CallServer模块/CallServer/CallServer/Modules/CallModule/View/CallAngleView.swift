//
//  CallAngleView.swift
//  Odin-UC
//
//  Created by Apple on 09/01/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

import UIKit

class CallAngleView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.beginPath()

        let pointOne = CGPoint.init(x: rect.origin.x, y: rect.origin.y )
        let pointTwo = CGPoint.init(x: rect.size.width, y: rect.origin.y)
        let pointThree = CGPoint.init(x: rect.size.width/2 + rect.origin.x, y: rect.maxY)

        context?.move(to: pointOne)
        context?.addLine(to: pointTwo)
        context?.addLine(to: pointThree)
        context?.closePath()
        UIColor.white.setFill()
        UIColor.white.setStroke()
        context?.fillPath()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
