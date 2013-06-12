//
//  MainViewController.h
//  TinyDiaryPro
//
//  Created by chenshun on 13-6-10.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    UITableView *mTableView;
}
@property (nonatomic, retain)IBOutlet UITableView *mTableView;
@end
