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
#import "XMNAssetModel.h"
#import <CoreLocation/CoreLocation.h>

@interface DisplayPhotosVC ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)CLGeocoder *geo;
@property (nonatomic, strong)NSMutableArray<CaModel *> *sources;
@end

@implementation DisplayPhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.collectionView registerClass:[DisCell class] forCellWithReuseIdentifier:NSStringFromClass([DisCell class])];
    self.collectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Collection view datasoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sources.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sources[section].images.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

#pragma mark - Collection view datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DisCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DisCell class]) forIndexPath:indexPath];
    cell.disView.image = self.sources[indexPath.section].images[indexPath.row];
    return cell;
}







- (void)setAssets:(NSArray<PHAsset *> *)assets{
    if (_assets != assets) {
        _assets = assets;
    }
    WS(weakSelf);
    [_assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj;
        NSString *createDate = [asset.creationDate stringFromDateWithFormatter:@"yyyy-MM-dd"];
        CLLocation *location = asset.location;
        
        [weakSelf.geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            NSString *countryName = placemarks.firstObject.country;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateSr == %@",createDate];
            NSArray *models = [weakSelf.sources filteredArrayUsingPredicate:predicate];
            @try
            {
                if (!models.count) {
                    NSMutableArray *array = [NSMutableArray arrayWithObject:weakSelf.images[idx]];
                    CaModel *c_model = [CaModel shareWithDes:countryName images:array date:createDate];
                    [weakSelf.sources addObject:c_model];
                }
                else{
                    CaModel *c_model = weakSelf.sources[idx];
                    [c_model.images addObject:weakSelf.images[idx]];
                    [weakSelf.sources addObject:c_model];
                }
            }
            @catch(NSException *e){
                NSLog(@"%@",e.reason);
            }
            [weakSelf.collectionView reloadData];
        }];
    }];
}

- (NSMutableArray<CaModel *> *)sources{
    if (!_sources) {
        _sources = [NSMutableArray array];
    }
    return _sources;
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
    }
    return self;
}
@end
