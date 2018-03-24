//
//  DisplayPhotosVC.m
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import "DisplayPhotosVC.h"
#import <Photos/Photos.h>
#import "Category.h"
#import <CoreLocation/CoreLocation.h>

@interface DisplayPhotosVC ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)CLGeocoder *geo;
@end

@implementation DisplayPhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Momment";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.collectionView registerClass:[DisCell class] forCellWithReuseIdentifier:NSStringFromClass([DisCell class])];
    self.collectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.collectionView registerClass:[DisResuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DisResuableView class])];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if ([super initWithCollectionViewLayout:layout]) {
        UICollectionViewFlowLayout *layoUT = (UICollectionViewFlowLayout *)layout;
        layoUT.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Collection view datasoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.images.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images[section].count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width - 3) / 4, (collectionView.frame.size.width - 3) / 4);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 42);
}



#pragma mark - Collection view datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DisCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DisCell class]) forIndexPath:indexPath];
    cell.disView.image = self.images[indexPath.section][indexPath.row][@"image"];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    DisResuableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DisResuableView class]) forIndexPath:indexPath];
    NSString *date = self.images[indexPath.section][indexPath.row][@"createDate"] ? : @"";
    NSString *country = self.images[indexPath.section][indexPath.row][@"country"] ? : @"";
    resuableView.label.text = [NSString stringWithFormat:@"%@ %@",date,country];
    return resuableView;
}


- (CLGeocoder *)geo{
    if (!_geo) {
        _geo = [CLGeocoder new];
    }
    return _geo;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation CaModel
+ (instancetype)shareWithDes:(NSString *)des images:(NSArray *)images date:(NSString *)date{
    CaModel *c_model = [CaModel new];
    c_model.des = des;
    c_model.dateSr = date;
    c_model.images = (NSMutableArray *)images;
    return c_model;
}
@end

@implementation DisCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.disView = [UIImageView new];
        [self.contentView addSubview:_disView];
        _disView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_disView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        _disView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}
@end

@implementation DisResuableView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.label = [UILabel new];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}
@end
