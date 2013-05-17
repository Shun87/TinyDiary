//
//  DiaryInfoViewController.h
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocEntity.h"

@interface DiaryInfoViewController : UITableViewController
{
    DocEntity *entity;
    UITextField *atextField;
}
@property (nonatomic, retain)DocEntity *entity;
@end
