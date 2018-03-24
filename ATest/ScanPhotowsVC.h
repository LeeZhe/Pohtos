//
//  ScanPhotowsVC.h
//  ATest
//
//  Created by KiddieBao on 2018/3/24.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SS(strongSelf)  __strong __typeof(weakSelf)strongSelf
#import "XMNPhotoPickerController.h"

@interface ScanPhotowsVC : UITableViewController

@end
