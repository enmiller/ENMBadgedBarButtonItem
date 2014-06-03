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

let kENMPadding: CGFloat = 3.0

class ENMBadgedBarButtonItem: UIBarButtonItem {
    
    var badgeLabel: UILabel = UILabel()
    var badgeValue: String? {
    didSet {
        if (self.shouldBadgeHide(badgeValue!)) {
            self.removeBadge()
            return;
        }
        
        if (badgeLabel.superview != nil) {
            self.updateBadgeValueAnimated(true)
        } else {
            badgeLabel = self.createBadgeLabel()
            self.updateBadgeProperties()
            customView.addSubview(badgeLabel)
            self.updateBadgeValueAnimated(false)
        }
    }
    }
    var badgeBackgroundColor: UIColor = UIColor.greenColor() {
    didSet {
        self.refreshBadgeLabelProperties()
    }
    }
    var badgeTextColor: UIColor = UIColor.blackColor() {
    didSet {
        self.refreshBadgeLabelProperties()
    }
    }
    var badgeFont: UIFont = UIFont.systemFontOfSize(12.0){
    didSet {
        self.refreshBadgeLabelProperties()
    }
    }
    var badgePadding: CGFloat = kENMPadding
    var badgeMinSize: CGFloat = 8.0
    var badgeOriginX: CGFloat = 0.0
    var badgeOriginY: CGFloat = 0.0
    var shouldHideBadgeAtZero: Bool = true
    var shouldAnimateBadge: Bool = true
    
    init()  {
        badgeValue = "0"
        super.init()
    }
    
    init(customView: UIView!, value: String!) {
        badgeValue = value
        super.init(customView: customView)
    }
    
    // Utilities
    
    func refreshBadgeLabelProperties() {
        if (badgeLabel != nil) {
            badgeLabel.textColor = badgeTextColor;
            badgeLabel.backgroundColor = badgeBackgroundColor;
            badgeLabel.font = badgeFont;
        }
    }
    
    func updateBadgeValueAnimated(animated: Bool) {
        if (animated && shouldAnimateBadge && (badgeLabel.text == badgeValue)) {
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
        
        UIView.animateWithDuration(0.2) {
            self.updateBadgeFrame()
        }
    }
    
    func updateBadgeFrame() {
        var expectedLabelSize: CGSize = self.badgeExpectedSize()
        var minHeight: CGFloat = expectedLabelSize.height
        
        minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize.height
        var minWidth: CGFloat = expectedLabelSize.width
        var padding: CGFloat = badgePadding
        
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        badgeLabel.frame = CGRectMake(badgeOriginX, badgeOriginY, minWidth + padding, minHeight + padding)
        badgeLabel.layer.cornerRadius = (minHeight + padding) / 2
        badgeLabel.layer.masksToBounds = true
    }
    
    func removeBadge() {
        var completionBlock: (Bool) -> Void = {finished in self.badgeLabel.removeFromSuperview()}
        UIView.animateWithDuration(0.2,
            animations: ({self.badgeLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)}),
            completion: completionBlock)
    }
    
    
    // Internal Helpers
    
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
        badgePadding = kENMPadding
        badgeMinSize = 8.0
        badgeOriginX = self.customView.frame.size.width - badgeLabel.frame.size.width/2
        badgeOriginY = 0.0
    }
}
