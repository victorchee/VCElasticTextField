//
//  ElasticView.swift
//  VCElasticTextField
//
//  Created by qihaijun on 9/11/15.
//  Copyright (c) 2015 VictorChee. All rights reserved.
//

import UIKit

class ElasticView: UIView {
    @IBInspectable var overshootAmount: CGFloat = 10.0
    
    private let topControlPointView = UIView()
    private let leftControlPointView = UIView()
    private let bottomControlPointView = UIView()
    private let rightControlPointView = UIView()
    
    private let elasticShape = CAShapeLayer()
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: "updateLoop")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        return displayLink
    }()
    
    override var backgroundColor: UIColor? {
        willSet {
            if let value = newValue {
                elasticShape.fillColor = value.CGColor
                super.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        positionControlPoints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponents()
    }
    
    private func setupComponents() {
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        
        elasticShape.fillColor = backgroundColor?.CGColor
        elasticShape.path = UIBezierPath(rect: bounds).CGPath
        layer.addSublayer(elasticShape)
        
        for controlPoint in [topControlPointView, leftControlPointView, bottomControlPointView, rightControlPointView] {
            addSubview(controlPoint)
            controlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
//            controlPoint.backgroundColor = UIColor.blueColor()
        }
    }
    
    private func positionControlPoints() {
        topControlPointView.center = CGPoint(x: bounds.midX, y: 0.0)
        leftControlPointView.center = CGPoint(x: 0.0, y: bounds.midY)
        bottomControlPointView.center = CGPoint(x: bounds.midX, y: bounds.maxY)
        rightControlPointView.center = CGPoint(x: bounds.maxX, y: bounds.midY)
    }
    
    private func bezierPathForControlPoints() -> CGPathRef {
        let path = UIBezierPath()
        
        let top = topControlPointView.layer.presentationLayer()!.position
        let left = leftControlPointView.layer.presentationLayer()!.position
        let bottom = bottomControlPointView.layer.presentationLayer()!.position
        let right = rightControlPointView.layer.presentationLayer()!.position
        
        let width = frame.width
        let height = frame.height
        
        path.moveToPoint(CGPoint.zero)
        path.addQuadCurveToPoint(CGPointMake(width, 0), controlPoint: top)
        path.addQuadCurveToPoint(CGPointMake(width, height), controlPoint: right)
        path.addQuadCurveToPoint(CGPointMake(0, height), controlPoint: bottom)
        path.addQuadCurveToPoint(CGPointMake(0, 0), controlPoint: left)
        
        return path.CGPath
    }
    
    func updateLoop() {
        elasticShape.path = bezierPathForControlPoints()
    }
    
    private func startUpdateLoop() {
        displayLink.paused = false
    }
    
    private func stopUpdateLoop() {
        displayLink.paused = true
    }
    
    func animatedControlPoints() {
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: [], animations: { () -> Void in
            self.topControlPointView.center.y -= self.overshootAmount
            self.leftControlPointView.center.x -= self.overshootAmount
            self.bottomControlPointView.center.y += self.overshootAmount
            self.rightControlPointView.center.x += self.overshootAmount
        }) { (_) -> Void in
            UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5, options: [], animations: { () -> Void in
                self.positionControlPoints()
            }, completion: { (_) -> Void in
                self.stopUpdateLoop()
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startUpdateLoop()
        animatedControlPoints()
    }
}
