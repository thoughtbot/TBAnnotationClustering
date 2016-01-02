//
//  TBClusterAnnotationView.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import MapKit

class TBClusterAnnotationView: MKAnnotationView {
    
    let TBScaleFactorAlpha:Float = 0.3
    let TBScaleFactorBeta:Float = 0.4
    
    private var count:Int?
    private var countLabel:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        setupLabel()
        setCount(1)
    }
    
    func TBScaledValueForValue(value:Float, multiplier:Float) -> Float {
        // Multiplier * (1/e^(-Alpha * X^(Beta)))
        return multiplier * (1.0 / (1.0 + expf(-1 * TBScaleFactorAlpha * powf(value, TBScaleFactorBeta))))
    }
    
    func TBCenterRect(rect:CGRect, center: CGPoint) -> CGRect {
        let r = CGRect(x: center.x - rect.size.width/2.0, y: center.y - rect.size.height/2.0, width: rect.size.width, height: rect.size.height)
        return r
    }
    
    func TBRectCenter(rect: CGRect) -> CGPoint {
        return CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect));
    }
    
    func setupLabel() {
        countLabel = UILabel(frame: self.frame)
        countLabel?.backgroundColor = UIColor.clearColor()
        countLabel?.textColor = UIColor.whiteColor()
        countLabel?.textAlignment = NSTextAlignment.Center
        countLabel?.shadowColor = UIColor(white: 0, alpha: 0.75)
        countLabel?.shadowOffset = CGSize(width: 0, height: -1)
        countLabel?.adjustsFontSizeToFitWidth = true
        countLabel?.numberOfLines = 1
        countLabel?.font = UIFont.boldSystemFontOfSize(12)
        countLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        
        addSubview(countLabel!)
    }
    
    func setCount(count:Int) {
        self.count = count
        let size = CGFloat(roundf(TBScaledValueForValue(Float(count), multiplier: 44.0)))
        
        let newBounds = CGRect(x: 0, y: 0, width: size, height: size)
        frame = TBCenterRect(newBounds, center: self.center)
        
        let newLabelBounds:CGRect = CGRect(x: 0, y: 0, width: newBounds.size.width, height: newBounds.size.height)
        countLabel?.frame = TBCenterRect(newLabelBounds, center: TBRectCenter(newBounds))
        countLabel?.text = String(count)
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetAllowsAntialiasing(context, true)
        
        let outerCircleStrokeColor = UIColor(white: 0, alpha: 0.25)
        let innerCircleStrokeColor = UIColor.whiteColor()
        var innerCircleFillColor = UIColor(red: (255.0 / 255.0), green: (95.0 / 255.0), blue: (42.0 / 255.0), alpha: 1.0)
        if(count == 1) {
            innerCircleFillColor = UIColor(red: (95.0 / 255.0), green: (150.0 / 255.0), blue: (42.0 / 255.0), alpha: 1.0)
        }
        
        let circleFrame = CGRectInset(rect, 4, 4)
        
        outerCircleStrokeColor.setStroke()
        CGContextSetLineWidth(context,  5.0)
        CGContextStrokeEllipseInRect(context, circleFrame)
        
        innerCircleStrokeColor.setStroke()
        CGContextSetLineWidth(context,  4.0)
        CGContextStrokeEllipseInRect(context, circleFrame)
        
        innerCircleFillColor.setFill()
        CGContextFillEllipseInRect(context, circleFrame)
    }
}
