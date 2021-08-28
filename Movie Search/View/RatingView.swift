//
//  RatingView.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit

@IBDesignable
class RatingView: UIView {
    
    @IBInspectable var currentRating: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var emptyColor: UIColor = UIColor.systemGray { didSet { setNeedsDisplay() } }
    @IBInspectable var fillColor: UIColor = .systemIndigo { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = min(rect.size.width, rect.size.height) / 2
        let viewCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        var startAngle = CGFloat.pi / 2
        var endAngle = startAngle - (2 * .pi * (currentRating / 100.0))
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(fillColor.cgColor)
        context?.move(to: viewCenter)
        context?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.strokePath()
        
        startAngle = endAngle
        endAngle = CGFloat.pi / 2
        
        context?.setStrokeColor(emptyColor.cgColor)
        context?.move(to: viewCenter)
        context?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
}
