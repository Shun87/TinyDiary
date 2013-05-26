//
//  DiaryContentViewController.h
//  iDiary
//
//  Created by chenshun on 12-11-16.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollableToolView.h"
#import "RichEditView.h"


@class NoteDocument;
@class DocEntity;

@interface DiaryContentViewController : UIViewController<UIWebViewDelegate,
ScrollableToolViewDelegate, RichEditViewDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UIActionSheetDelegate, UISearchBarDelegate>
{
    RichEditView *richEditor;
    NSURL *htmlFileURL;
    NSString *filePathToSave;
    NSDate *resaveDate; //将选择的日期作为保存日记的名称 类似2012－11－02.html
    
    NoteDocument *doc;
    DocEntity *entity;
    NSString *innerHtmlAtStart;
    
    BOOL  newFile;      // 是否是新添加的文件
    
    UIBarButtonItem *shareButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *saveButton;
    UIButton *editButton;
    UIBarButtonItem *cancleButton;
    UIBarButtonItem *addButton;
    UIButton *preButton;
    UIButton *nextButton;
    
    UIImagePickerController *imagePickerController;
    
    NSArray *rightItems;
    
    IBOutlet UIView *headView;
    
    BOOL editMode;
    UIToolbar *toolbar;
    
    UIViewController *listViewController;
    
    NSString *title;
    NSString *creatTime;
    NSString *modifyTime;
    NSString *tagStr;
    UISearchBar *aSearchBar;
    NSInteger totalSeachResult;
    NSInteger curIndex;
    UILabel *searchlabel;
}

@property (nonatomic, assign)UIViewController *listViewController;
@property (nonatomic, retain)IBOutlet  UIToolbar *toolbar;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain)DocEntity *entity;
@property (nonatomic, copy)NSString *innerHtmlAtStart;

@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *cancleButton;
@property (nonatomic, retain)IBOutlet UIButton *preButton;
@property (nonatomic, retain)IBOutlet UIButton *nextButton;

@property (nonatomic, assign)BOOL newFile;

@property(nonatomic, retain)NSDate *resaveDate;
@property (nonatomic, copy)NSString *filePathToSave;
@property (nonatomic, retain)NSURL *htmlFileURL;
@property (nonatomic, retain)RichEditView *richEditor;

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *creatTime;
@property (nonatomic, copy)NSString *tagStr;
@property (nonatomic, copy) NSString *modifyTime;

- (IBAction)editAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)addAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

- (IBAction)loadNextContent:(id)sender;
- (IBAction)loadPreContent:(id)sender;
- (IBAction)diaryInfoView:(id)sender;
- (IBAction)outGoing:(id)sender;
@end
