//
//  ENMBadgedBarButtonItem.swift
//  TestBadge-Swift
//
//  Created by Eric Miller on 6/2/14.
//  Copyright (c) 2014 Yogurt Salad. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

let kENMDefaultPadding: CGFloat = 3.0
let kENMDefaultMinSize: CGFloat = 8.0
let kENMDefaultOriginX: CGFloat = 0.0
let kENMDefaultOriginY: CGFloat = 0.0

class ENMBadgedBarButtonItem: UIBarButtonItem {
    
    var badgeLabel: UILabel = UILabel()
    var badgeValue: String {
    didSet {
        if (shouldBadgeHide(badgeValue)) {
            removeBadge()
            return;
        }
        
        if (badgeLabel.superview != nil) {
            updateBadgeValueAnimated(true)
        } else {
            badgeLabel = self.createBadgeLabel()
            updateBadgeProperties()
            customView.addSubview(badgeLabel)
            updateBadgeValueAnimated(false)
        }
    }
    }
    var badgeBackgroundColor: UIColor = UIColor.greenColor() {
    didSet {
        refreshBadgeLabelProperties()
    }
    }
    var badgeTextColor: UIColor = UIColor.blackColor() {
    didSet {
        refreshBadgeLabelProperties()
    }
    }
    var badgeFont: UIFont = UIFont.systemFontOfSize(12.0){
    didSet {
        refreshBadgeLabelProperties()
    }
    }
    @final let badgePadding: CGFloat = kENMDefaultPadding
    var badgeMinSize: CGFloat = kENMDefaultMinSize {
    didSet {
        updateBadgeFrame()
    }
    }
    var badgeOriginX: CGFloat = kENMDefaultOriginX {
    didSet {
        updateBadgeFrame()

    }
    }
    var badgeOriginY: CGFloat = kENMDefaultOriginY {
    didSet {
        updateBadgeFrame()
    }
    }
    var shouldHideBadgeAtZero: Bool = true
    var shouldAnimateBadge: Bool = true
    
    
// MARK: - Initializers
    
    init()  {
        badgeValue = "0"
        super.init()
    }
    
    init(customView: UIView!, value: String!) {
        badgeValue = value
        badgeOriginX = customView.frame.size.width - badgeLabel.frame.size.width/2
        super.init(customView: customView)
    }
    
    
// MARK: - Utilities
    
    func refreshBadgeLabelProperties() {
        if (badgeLabel != nil) {
            badgeLabel.textColor = badgeTextColor;
            badgeLabel.backgroundColor = badgeBackgroundColor;
            badgeLabel.font = badgeFont;
        }
    }
    
    func updateBadgeValueAnimated(animated: Bool) {
        if (animated && shouldAnimateBadge && (badgeLabel.text != badgeValue)) {
            var animation: CABasicAnimation = CABasicAnimation()
            animation.keyPath = "transform.scale"
            animation.fromValue = 1.5
            animation.toValue = 1
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
            badgeLabel.layer.addAnimation(animation, forKey: "bounceAnimation")
        }
        
        badgeLabel.text = self.badgeValue;
        
        var duration: CGFloat = animated ? 0.2 : 0.0
        
        self.updateBadgeFrame()
    }
    
    func updateBadgeFrame() {
        var expectedLabelSize: CGSize = badgeExpectedSize()
        var minHeight: CGFloat = expectedLabelSize.height
        
        minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize.height
        var minWidth: CGFloat = expectedLabelSize.width
        var padding: CGFloat = badgePadding
        
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        UIView.animateWithDuration(0.2) {
                self.badgeLabel.frame = CGRectMake(self.badgeOriginX,
                                                   self.badgeOriginY,
                                                   minWidth + padding,
                                                   minHeight + padding)
                self.badgeLabel.layer.cornerRadius = (minHeight + padding) / 2
                self.badgeLabel.layer.masksToBounds = true
            }
    }
    
    func removeBadge() {
        UIView.animateWithDuration(0.2,
            animations: {
                self.badgeLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
            }, completion: { finished in
                self.badgeLabel.removeFromSuperview()
            })
    }
    
    
// MARK: - Internal Helpers
    
    func createBadgeLabel() -> UILabel {
        var frame = CGRectMake(badgeOriginX, badgeOriginY, 15, 15)
        var label = UILabel(frame: frame)
        label.textColor = badgeTextColor
        label.font = badgeFont
        label.backgroundColor = badgeBackgroundColor
        label.textAlignment = NSTextAlignment.Center
        
        return label
    }
    
    func badgeExpectedSize() -> CGSize {
        var frameLabel: UILabel = self.duplicateLabel(badgeLabel)
        frameLabel.sizeToFit()
        var expectedLabelSize: CGSize = frameLabel.frame.size;
        
        return expectedLabelSize
    }
    
    func duplicateLabel(labelToCopy: UILabel) -> UILabel {
        var dupLabel = UILabel(frame: labelToCopy.frame)
        dupLabel.text = labelToCopy.text
        
        return dupLabel
    }
    
    func shouldBadgeHide(value: NSString) -> Bool {
        var b2: Bool = value.isEqualToString("")
        var b3: Bool = value.isEqualToString("0")
        var b4: Bool = shouldHideBadgeAtZero
        if ((b2 || b3) && b4) {
            return true
        }
        return false
    }
    
    func updateBadgeProperties() {
        badgeOriginX = self.customView.frame.size.width - badgeLabel.frame.size.width/2
    }
}
