//
//  MKTextField.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class MKTextField : UITextField {
    @IBInspectable var padding: CGSize = CGSize(width: 5, height: 5)
    @IBInspectable var floatingLabelBottomMargin: CGFloat = 2.0
    @IBInspectable var floatingPlaceholderEnabled: Bool = false
    
    @IBInspectable var rippleLocation: MKRippleLocation = .tapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    
    @IBInspectable var aniDuration: Float = 0.65
    @IBInspectable var circleAniTimingFunction: MKTimingFunction = .linear
    @IBInspectable var shadowAniEnabled: Bool = true
    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(circleLayerColor)
        }
    }
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    
    // floating label
    @IBInspectable var floatingLabelFont: UIFont = UIFont(name: "Roboto-Medium", size: 13.0)! {
        didSet {
            floatingLabel.font = floatingLabelFont
        }
    }
    @IBInspectable var floatingLabelTextColor: UIColor = UIColor.lightGray {
        didSet {
            floatingLabel.textColor = floatingLabelTextColor
        }
    }
    
    @IBInspectable var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame = CGRect(x: 0, y: self.layer.bounds.height - 1, width: self.bounds.width, height: 1)
                bottomBorderLayer?.backgroundColor = UIColor.MKColor.Grey.cgColor
                self.layer.addSublayer(bottomBorderLayer!)
            }
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat = 1.0
    @IBInspectable var bottomBorderColor: UIColor = UIColor.lightGray
    @IBInspectable var bottomBorderHighlightWidth: CGFloat = 1.75
    
    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
            floatingLabel.sizeToFit()
            setFloatingLabelOverlapTextField()
        }
    }
    override var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    fileprivate lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    fileprivate var floatingLabel: UILabel!
    fileprivate var bottomBorderLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupLayer()
    }
    
    fileprivate func setupLayer() {
        self.cornerRadius = 2.5
        self.layer.borderWidth = 1.0
        self.borderStyle = .none
        mkLayer.circleGrowRatioMax = 1.0
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(circleLayerColor)
        
        // floating label
        floatingLabel = UILabel()
        floatingLabel.font = floatingLabelFont
        floatingLabel.alpha = 0.0
        self.addSubview(floatingLabel)
    }
    
    //    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
    //        mkLayer.didChangeTapLocation(touch.locationInView(self))
    //
    //        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.Linear, duration: 0.75)
    //        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: 0.75)
    //
    //        return super.beginTrackingWithTouch(touch, withEvent: event)
    //    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        mkLayer.didChangeTapLocation(touch.location(in: self))
        
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.linear, duration: 0.75)
        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.linear, duration: 0.75)
        
        return super.beginTracking(touch, with: event)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !floatingPlaceholderEnabled {
            return
        }
        
        if !self.text!.isEmpty {
            floatingLabel.textColor = self.isFirstResponder ? self.tintColor : floatingLabelTextColor
            if floatingLabel.alpha == 0 {
                self.showFloatingLabel()
            }
        } else {
            self.hideFloatingLabel()
        }
        
        bottomBorderLayer?.backgroundColor = self.isFirstResponder ? self.tintColor.cgColor : bottomBorderColor.cgColor
        let borderWidth = self.isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: self.layer.bounds.height - borderWidth, width: self.layer.bounds.width, height: borderWidth)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var newRect = CGRect(x: rect.origin.x + padding.width, y: rect.origin.y,
            width: rect.size.width - 2*padding.width, height: rect.size.height)
        
        if !floatingPlaceholderEnabled {
            return newRect
        }
        
        if !self.text!.isEmpty {
            let dTop = floatingLabel.font.lineHeight + floatingLabelBottomMargin
            newRect = UIEdgeInsetsInsetRect(newRect, UIEdgeInsets(top: dTop, left: 0.0, bottom: 0.0, right: 0.0))
        }
        return newRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    // MARK - private
    fileprivate func setFloatingLabelOverlapTextField() {
        let textRect = self.textRect(forBounds: self.bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - floatingLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - floatingLabel.bounds.width
        default:
            break
        }
        floatingLabel.frame = CGRect(x: originX, y: padding.height,
            width: floatingLabel.frame.size.width, height: floatingLabel.frame.size.height)
    }
    
    fileprivate func showFloatingLabel() {
        let curFrame = floatingLabel.frame
        floatingLabel.frame = CGRect(x: curFrame.origin.x, y: self.bounds.height/2, width: curFrame.width, height: curFrame.height)
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut, animations: {
            self.floatingLabel.alpha = 1.0
            self.floatingLabel.frame = curFrame
            }, completion: nil)
    }
    
    fileprivate func hideFloatingLabel() {
        floatingLabel.alpha = 0.0
    }
}

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
