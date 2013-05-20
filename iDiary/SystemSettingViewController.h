//
//  SystemSettingViewController.h
//  iDiary
//
//  Created by chenshun on 12-11-17.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *mTableView;
    NSArray *appArray;
}
@property (nonatomic, retain)NSArray *appArray;
@end
