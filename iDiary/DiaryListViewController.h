//
//  DiaryListViewController.h
//  iDiary
//
//  Created by chenshun on 12-11-16.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvancedCell.h"
#import "DocumentsAccess.h"
#import "DocEntity.h"
#import "TTSocial.h"

extern NSString *const TDDocumentsDirectoryName;
extern NSString *const HTMLExtentsion;

@interface DiaryListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, AdvancedCellDelegate,
DocumentsAccessDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *mTableView;
    
    AdvancedCell *tmpCell;
    UINib *cellNib;
    
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *addButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *settingsButton;
    UIToolbar *toolbar;
    
    TTSocial *mySocial;
    
    NSString *tagName;
    
    NSMutableArray *monthAndYearArray;
}
@property (nonatomic, copy)NSString *tagName;
@property (nonatomic, retain)IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet AdvancedCell *tmpCell;
@property (nonatomic, retain) UINib *cellNib;

@property (nonatomic, retain)IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *settingsButton;

@property (nonatomic, retain)IBOutlet UIToolbar *toolbar;

- (IBAction)addAction:(id)sender;
- (IBAction)editAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

- (void)showDiaryContent:(DocEntity *)entity newFile:(BOOL)newFile;
- (void)deleteFile:(DocEntity *)entry;

- (void)reloadDataFromArray:(NSArray *)units;

- (DocEntity *)preUrl:(DocEntity *)entry;
- (DocEntity *)nextUrl:(DocEntity *)entry;
- (BOOL)isFirstObj:(DocEntity *)entry;
- (BOOL)isLastObj:(DocEntity *)entry;

@end
