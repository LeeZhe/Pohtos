//
//  UIView+AD.h
//  cangu
//
//  Created by 杜林伟 on 16/8/22.
//  Copyright © 2016年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, LineViewType) {
    LineViewTypeNone = 0,
    LineViewTypeTop = 1,
    LineViewTypeLeft = 1<<1,
    LineViewTypeRight = 1<<2,
    LineViewTypeBottom = 1<<3,
    LineViewTypeBottom_15 = 1<<4
};

@interface UIView (AD)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

- (UIViewController *)getParentsViewController;
- (void)addLineWithLineType:(LineViewType)type;
- (void)addLineWithLineType:(LineViewType)type color:(UIColor *)color;
- (void)addAllLine;
- (void)removeAllLines;

@end
