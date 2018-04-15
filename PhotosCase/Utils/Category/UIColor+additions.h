//
//  UIColor+additions.h
//  daheidou
//
//  Created by adu on 15/7/15.
//  Copyright (c) 2015年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (additions)
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 常用色系
/**主色*/
+ (UIColor *)c1;
/**辅助色*/
+ (UIColor *)c2;
/**标题文字色*/
+ (UIColor *)w1;
/**小标题文字色*/
+ (UIColor *)w2;
/**输入框文字色*/
+ (UIColor *)w3;
/**分割线颜色*/
+ (UIColor *)w4;
/**默认进度文字色 线框色*/
+ (UIColor *)w5;
/**默认进度背景色*/
+ (UIColor *)w6;
+ (UIColor *)w7;


@end
