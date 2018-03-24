//
//  ScanPhotosCell.h
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanPhotosCell : UITableViewCell
- (void)configureWithImageNamed:(UIImage *)image;

@property (nonatomic, strong)UIButton *addBt;

@property (nonatomic, assign)BOOL isSelectImage;
@end
