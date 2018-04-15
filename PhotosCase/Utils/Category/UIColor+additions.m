//
//  UIColor+additions.m
//  daheidou
//
//  Created by adu on 15/7/15.
//  Copyright (c) 2015年 adu. All rights reserved.
//

#import "UIColor+additions.h"

@implementation UIColor (additions)
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - 常用色系
+ (UIColor *)c1{
    return [self hexStringToColor:@"#FA8D49"];
}
//主色
+ (UIColor *)c2{
    return [self hexStringToColor:@"#5AB8CB"];
}
//辅助色
+ (UIColor *)w1{
    return [self hexStringToColor:@"#2F3237"];
}
//标题文字色
+ (UIColor *)w2{
    return [self hexStringToColor:@"#898FA5"];
}
//小标题文字色
+ (UIColor *)w3{
    return [self hexStringToColor:@"#4B5463"];
}
//输入框文字色

+ (UIColor *)w4{
    return [self hexStringToColor:@"#DDE5EA"];
}
//分割线颜色
+ (UIColor *)w5{
    return [self hexStringToColor:@"#C0CAD7"];
}
//线框色
+ (UIColor *)w6{
    return [self hexStringToColor:@"#F2EAE9"];
}
//默认进度背景色
+ (UIColor *)w7{
    return [self hexStringToColor:@"#E9DAD8"];
}
//默认进度底部文字色




@end
