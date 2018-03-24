//
//  ScanPhotowsVC.m
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import "ScanPhotowsVC.h"
#import "ScanPhotosCell.h"
#import "DisplayPhotosVC.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>
#import "Category.h"
#import <CoreLocation/CoreLocation.h>
@interface ScanPhotowsVC ()
@property (nonatomic, strong)NSMutableArray *imageSoures;

@property (nonatomic, strong)NSMutableArray *images;

@property (nonatomic, strong)NSMutableArray *dicts;

@property (nonatomic, strong)NSMutableDictionary *resultDic;

@property (nonatomic, strong)NSMutableArray *results;
@end

@implementation ScanPhotowsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Select title";
    [self.tableView registerClass:[ScanPhotosCell class] forCellReuseIdentifier:NSStringFromClass([ScanPhotosCell class])];
    [self addObserver:self forKeyPath:@"resultDic" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"resultDic"]) {
        if (self.dicts.count == self.imageSoures.count) {
            NSArray *dates = [self.dicts valueForKey:@"createDate"];
            NSSet *dateSet = [NSSet setWithArray:dates];
            NSMutableArray *resultArray = [NSMutableArray array];
            [[dateSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate == %@",obj];
                NSArray *dArray = [self.dicts filteredArrayUsingPredicate:predicate];
                [resultArray addObject:dArray];
            }];
            self.results = resultArray;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.width;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        WS(weakSelf);
//        XMNPhotoPickerController *photosVC = [[XMNPhotoPickerController alloc] initWithMaxCount:50 delegate:nil];
//        [self.navigationController presentViewController:photosVC animated:true completion:nil];
//        WS(weakSelf);
//        photosVC.didFinishPickingPhotosBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
////            SS(strongSelf);
//            ScanPhotosCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            [cell configureWithImageNamed:images.firstObject];
//            [weakSelf.imageSoures addObjectsFromArray:assets];
//            [weakSelf dismissViewControllerAnimated:true completion:nil];
//        };
        
        ZLPhotoActionSheet *sheet = [ZLPhotoActionSheet new];
        sheet.configuration.maxSelectCount = 100;
        sheet.sender = self;
        [sheet showPreviewAnimated:true];
        sheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            ScanPhotosCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell configureWithImageNamed:images.firstObject];
            [weakSelf.imageSoures addObjectsFromArray:assets];
            [weakSelf.images addObjectsFromArray:images];
            [weakSelf onHandleDataWithImages:weakSelf.images assets:weakSelf.imageSoures];
        };
        return;
    }
    
    ScanPhotosCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (!cell.isSelectImage) return;
    
    if (indexPath.row == 1) {
        DisplayPhotosVC *dVC = [[DisplayPhotosVC alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
        dVC.images = self.results;
        [self.navigationController pushViewController:dVC animated:true];
    }
}

- (void)onHandleDataWithImages:(NSArray<UIImage *> *)images assets:(NSArray <PHAsset *> *)assets{
    [self.dicts removeAllObjects];
    WS(weakSelf);
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = images[idx];
        NSString *createDate = [obj.creationDate stringFromDate];
        CLLocation *location = obj.location;
        CLGeocoder *grocoder = [CLGeocoder new];
        __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"createDate"] = createDate;
        dict[@"image"] = image;
        [grocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            dict[@"country"] = placemarks.firstObject.country;
            [weakSelf.dicts addObject:dict];
            weakSelf.resultDic = dict;
        }];
    }];
}

- (NSMutableArray *)dicts{
    if (!_dicts) {
        _dicts = [NSMutableArray array];
    }
    return _dicts;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScanPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScanPhotosCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row > 0) {
        cell.addBt.hidden = true;
    }
    return cell;
}

#pragma mark - Getter
- (NSMutableArray *)imageSoures{
    if (!_imageSoures) {
        _imageSoures = [NSMutableArray array];
    }
    return _imageSoures;
}
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
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
