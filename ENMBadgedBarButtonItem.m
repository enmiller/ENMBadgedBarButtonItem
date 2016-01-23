//
//  ENMBadgedBarButtonItem.h
//  TestBadge
//
//  Created by Eric Miller on 5/21/14.
//  Copyright (c) 2014 Frozen Panda. All rights reserved.
//

#import "ENMBadgedBarButtonItem.h"

@interface ENMBadgedBarButtonItem ()

@property (nonatomic, assign) CGFloat badgePadding;
@property (nonatomic, assign) CGFloat badgeMinSize;
@property (nonatomic, assign) CGFloat badgeOriginX;
@property (nonatomic, assign) CGFloat badgeOriginY;

@end

@implementation ENMBadgedBarButtonItem

- (instancetype)initWithCustomView:(UIView *)customView {
    self = [super initWithCustomView:customView];
    if (self) {
        _badgeBackgroundColor = [UIColor greenColor];
        _badgeTextColor = [UIColor blackColor];
        _badgeFont = [UIFont systemFontOfSize:12.0];
        _badgePadding = 1.f;
        _badgeMinSize = 6.f;
        _badgeOriginX = customView.frame.size.width - _badgeLabel.frame.size.width/2;;
        _badgeOriginY = 0.f;
        _shouldHideBadgeAtZero = YES;
        _shouldAnimateBadge = YES;
        self.customView.clipsToBounds = NO;
    }
    return self;
}


#pragma mark - Utility

- (void)refreshBadgeLabelProperties {
    if (self.badgeLabel) {
        self.badgeLabel.textColor = self.badgeTextColor;
        self.badgeLabel.backgroundColor = self.badgeBackgroundColor;
        self.badgeLabel.font = self.badgeFont;
    }
}

- (void)updateBadgeValueAnimated:(BOOL)animated {
    if (animated &&
        self.shouldAnimateBadge &&
        (![self.badgeLabel.text isEqualToString:self.badgeValue])) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badgeLabel.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    self.badgeLabel.text = self.badgeValue;
    
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView
     animateWithDuration:duration
     animations:^{
         [self updateBadgeFrame];
     }];
}

- (void)updateBadgeFrame {
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    CGFloat minHeight = expectedLabelSize.height;
    
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    
    if (self.badgeLabel) {
        self.badgeLabel.frame = CGRectMake(self.badgeOriginX,
                                           self.badgeOriginY,
                                           minWidth + padding,
                                           minHeight + padding);
        self.badgeLabel.layer.cornerRadius = (minHeight + padding) / 2;
        self.badgeLabel.layer.masksToBounds = YES;
    }
}

- (void)removeBadge {
    [UIView
     animateWithDuration:0.2f
     animations:^{
         self.badgeLabel.transform = CGAffineTransformMakeScale(0.f, 0.f);
     }
     completion:^(BOOL finished) {
         [self.badgeLabel removeFromSuperview];
         self.badgeLabel = nil;
     }];
}


#pragma mark - Getter/Setter Overrides

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    if ([self shouldBadgeHide:badgeValue]) {
        [self removeBadge];
        return;
    }
    
    if (self.badgeLabel) {
        [self updateBadgeValueAnimated:YES];
    } else {
        self.badgeLabel = [self newBadgeLabel];
        [self updateBadgeProperties];
        [self.customView addSubview:self.badgeLabel];
        
        // Pull the setting of the value and layer border radius off onto the next event loop.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.badgeLabel.text = self.badgeValue;
            [self updateBadgeFrame];
        });
    }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = [badgeBackgroundColor copy];
    [self refreshBadgeLabelProperties];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    _badgeTextColor = [badgeTextColor copy];
    [self refreshBadgeLabelProperties];
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    _badgeFont = [badgeFont copy];
    [self refreshBadgeLabelProperties];
}


#pragma mark - Internal

- (UILabel *)newBadgeLabel {
    CGRect frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, 15, 15);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = self.badgeTextColor;
    label.font = self.badgeFont;
    label.backgroundColor = self.badgeBackgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (CGSize)badgeExpectedSize {
    UILabel *frameLabel = [self duplicateLabel:self.badgeLabel];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy {
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    
    return duplicateLabel;
}

- (BOOL)shouldBadgeHide:(NSString *)badgeValue {
    if (((badgeValue == nil) ||
         ([badgeValue isEqualToString:@""]) ||
         ([badgeValue isEqualToString:@"0"])) &&
        self.shouldHideBadgeAtZero) {
        return YES;
    }
    
    return NO;
}

- (void)updateBadgeProperties {
    self.badgeOriginX = self.customView.frame.size.width - self.badgeLabel.frame.size.width/2;
}

@end
