//
//  DisplayPhotosVC.h
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNPhotoPickerController.h"
#import "ScanPhotowsVC.h"
#import <Photos/Photos.h>
@interface DisplayPhotosVC : UICollectionViewController
@property (nonatomic, strong)NSArray <NSArray *> *images;
@end

@interface CaModel : NSObject
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *dateSr;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSMutableArray <UIImage *> *images;

+ (instancetype)shareWithDes:(NSString *)des images:(NSArray *)images date:(NSString *)date;
@end


@interface DisCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *disView;
@end

@interface DisResuableView : UICollectionReusableView
@property (nonatomic, strong)UILabel *label;
@end


