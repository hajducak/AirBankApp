//
//  DashedLineView.swift
//  Volvista
//
//  Created by Petr Chmelar on 04/10/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

@IBDesignable class DashedLineView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.black
    @IBInspectable var lineLenght: CGFloat = 6
    @IBInspectable var lineGap: CGFloat = 3
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Graphics context
        let  context: CGContext = UIGraphicsGetCurrentContext()!
        
        // line points
        let p0 = CGPoint(x: bounds.minX, y: bounds.minY)
        let p1 = CGPoint(x: bounds.maxX, y: bounds.minY)
        
        // line drawing
        context.move(to: p0)
        context.addLine(to: p1)
        
        // line property
        context.setLineDash(phase: 0.0, lengths: [lineLenght, lineGap])
        context.setLineWidth(bounds.height * 2)
        context.setLineCap(.butt)
        lineColor.set()
        
        // draw a line
        context.strokePath()
    }
    
}
