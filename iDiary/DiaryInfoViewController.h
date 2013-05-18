//
//  DiaryInfoViewController.h
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocEntity.h"
#import "TITokenField.h"
@interface DiaryInfoViewController : UITableViewController<TITokenFieldDelegate>
{
    DocEntity *entity;
    UITextField *atextField;
    
    float caretheight;
    TITokenField *tokenField;
}
@property (nonatomic, retain)DocEntity *entity;
@end
