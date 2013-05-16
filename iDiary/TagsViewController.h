//
//  TagsViewController.h
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryTag : NSObject
{
    NSString *tagName;
    NSMutableArray *diaryInfoArray;
}
@property (nonatomic, copy)NSString *tagName;
@property (nonatomic, retain)NSMutableArray *diaryInfoArray;
@end

@interface TagsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tagArray;
    UITableView *mTableView;
}
@property (nonatomic, retain)IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *tagArray;
@end
