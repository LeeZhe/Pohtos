//
//  ScanPhotosCell.m
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import "ScanPhotosCell.h"
#import "Category.h"
@interface ScanPhotosCell()

@property (nonatomic, strong)UIImageView *layOutView;
@end
@implementation ScanPhotosCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.addBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_addBt];
        _addBt.frame = self.contentView.frame;
        _addBt.userInteractionEnabled = false;
        [_addBt setTitle:@"Add photos" forState:UIControlStateNormal];
        
        self.layOutView = [UIImageView new];
//        _layOutView.contentMode = UIViewContentModeScaleAspectFill;
        _layOutView.hidden = true;
        [self.contentView addSubview:_layOutView];
        [self.layOutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)configureWithImageNamed:(UIImage *)image{
    if (image) {
        self.addBt.hidden = true;
    }
    
    _layOutView.image = image;
    _layOutView.hidden = false;
    _isSelectImage = _layOutView.image != nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
