//
//  ElasticTextField.swift
//  VCElasticTextField
//
//  Created by qihaijun on 9/11/15.
//  Copyright (c) 2015 VictorChee. All rights reserved.
//

import UIKit

class ElasticTextField: UITextField {
    var elasticView: ElasticView!
    
    @IBInspectable var overshootAmount: CGFloat = 10.0 {
        didSet {
            elasticView.overshootAmount = overshootAmount
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = false
        borderStyle = .None
        
        elasticView = ElasticView(frame: bounds)
        elasticView.backgroundColor = backgroundColor
        addSubview(elasticView)
        
        backgroundColor = UIColor.clearColor() // use elastic view's background color as background color
        
        elasticView.userInteractionEnabled = false // 不能触发当前View的Touches事件，而通过传递进去
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        elasticView.touchesBegan(touches, withEvent: event)
    }
    
    // Add some padding to the text and editing bounds
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 5.0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 5.0)
    }
}
