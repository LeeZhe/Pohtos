//
//  UIView+AD.m
//  cangu
//
//  Created by 杜林伟 on 16/8/22.
//  Copyright © 2016年 adu. All rights reserved.
//

#import "UIView+AD.h"
#import "Masonry.h"
#import "UIColor+additions.h"

@implementation UIView (AD)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
- (CGFloat)tail {
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail {
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom {
    [self setTail:bottom];
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (UIViewController *)getParentsViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - 添加边框

- (void)addLineWithLineType:(LineViewType)type color:(UIColor *)color{
    UIView *layer = [[UIView alloc]init];
    layer.backgroundColor = color;
    if (type & LineViewTypeLeft) {
        [self addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_offset(0.5);
        }];
    }
    if (type & LineViewTypeRight) {
        [self addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_offset(0.5);
        }];
    }
    if (type & LineViewTypeTop) {
        [self addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(self);
            make.height.mas_offset(0.5);
        }];
    }
    if (type & LineViewTypeBottom) {
        [self addSubview:layer];
        [layer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(self);
            make.height.mas_offset(0.5);
        }];
    }
    if (type & LineViewTypeBottom_15) {
        CALayer *layer = [CALayer new];
        layer.backgroundColor = [UIColor w4].CGColor;
        layer.frame = CGRectMake(15, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds) - 30, .5);
        [self.layer addSublayer:layer];
        
    }
}

- (void)addLineWithLineType:(LineViewType)type{
    UIColor *color = [UIColor w5];
    [self addLineWithLineType:type color:color];
}


- (void)addAllLine{
    [self addLineWithLineType:LineViewTypeLeft];
    [self addLineWithLineType:LineViewTypeRight];
    [self addLineWithLineType:LineViewTypeTop];
    [self addLineWithLineType:LineViewTypeBottom];
}

@end
