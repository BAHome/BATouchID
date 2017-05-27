//
//  UIView+BARectCorner.m
//  BAButton
//
//  Created by boai on 2017/5/19.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "UIView+BARectCorner.h"
#import <objc/runtime.h>

static void *viewRectCornerTypeKey = @"viewRectCornerTypeKey";
static void *viewCornerRadiusKey = @"viewCornerRadiusKey";

@implementation UIView (BARectCorner)

- (void)ba_view_setBAViewRectCornerType:(BAViewRectCornerType)type viewCornerRadius:(CGFloat)viewCornerRadius
{
    self.viewCornerRadius = viewCornerRadius;
    self.viewRectCornerType = type;
}

#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupButtonCornerType
{
    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.viewCornerRadius, self.viewCornerRadius);
    if (self.viewCornerRadius == 0)
    {
        cornerRadii = CGSizeMake(0, 0);
    }
    
    switch (self.viewRectCornerType)
    {
        case BAViewRectCornerTypeBottomLeft:
        {
            corners = UIRectCornerBottomLeft;
        }
            break;
        case BAViewRectCornerTypeBottomRight:
        {
            corners = UIRectCornerBottomRight;
        }
            break;
        case BAViewRectCornerTypeTopLeft:
        {
            corners = UIRectCornerTopLeft;
        }
            break;
        case BAViewRectCornerTypeTopRight:
        {
            corners = UIRectCornerTopRight;
        }
            break;
        case BAViewRectCornerTypeBottomLeftAndBottomRight:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
            break;
        case BAViewRectCornerTypeTopLeftAndTopRight:
        {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
            break;
        case BAViewRectCornerTypeBottomLeftAndTopLeft:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        }
            break;
        case BAViewRectCornerTypeBottomRightAndTopRight:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        }
            break;
        case BAViewRectCornerTypeBottomRightAndTopRightAndTopLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        }
            break;
        case BAViewRectCornerTypeBottomRightAndTopRightAndBottomLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        }
            break;
        case BAViewRectCornerTypeAllCorners:
        {
            corners = UIRectCornerAllCorners;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

#pragma mark - setter / getter

- (void)setViewRectCornerType:(BAViewRectCornerType)viewRectCornerType
{
    objc_setAssociatedObject(self, viewRectCornerTypeKey, @(viewRectCornerType), OBJC_ASSOCIATION_ASSIGN);
    [self setupButtonCornerType];
}

- (BAViewRectCornerType)viewRectCornerType
{
    return [objc_getAssociatedObject(self, viewRectCornerTypeKey) integerValue];
}

- (void)setViewCornerRadius:(CGFloat)viewCornerRadius
{
    objc_setAssociatedObject(self, viewCornerRadiusKey, @(viewCornerRadius), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)viewCornerRadius
{
    return [objc_getAssociatedObject(self, viewCornerRadiusKey) floatValue];
}

@end
