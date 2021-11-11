//
//  CircularView.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 9/11/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import SwiftUI

func createObjectsAroundCircle(people: [ImportantPerson]) {

//    let center = CGPointMake(40/2 ,40/2)
    let radius : CGFloat = 40
    let count = people.count

    var angle = CGFloat(2 * Double.pi)
    let step = CGFloat(2 * Double.pi) / CGFloat(count)

    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

    let shapeLayer = Circle()
//    shapeLayer.path(circlePath.CGPath)

//    shapeLayer.fillColor = UIColor.clearColor().CGColor
//    shapeLayer.strokeColor = UIColor.redColor().CGColor
//    shapeLayer.lineWidth = 3.0

//    self.layer.addSublayer(shapeLayer)

    // set objects around circle
//    for index in 0...count {
//        let x = cos(angle) * radius + center.x
//        let y = sin(angle) * radius + center.y
//
//        let label = UILabel()
//        label.text = "\(index)"
//        label.font = UIFont(name: "Arial", size: 20)
//        label.textColor = UIColor.blackColor()
//        label.sizeToFit()
//        label.frame.origin.x = x - label.frame.midX
//        label.frame.origin.y = y - label.frame.midY
//        label.font = UIFont(name: "Arial", size: 20)
//        label.textColor = UIColor.blackColor()
//        label.sizeToFit()
//
//        self.addSubview(label)
//        angle += step
//    }
}

//

