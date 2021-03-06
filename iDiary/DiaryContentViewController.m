//
//  DiaryContentViewController.m
//  iDiary
//
//  Created by chenshun on 12-11-16.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "DiaryContentViewController.h"
#import "CommmonMethods.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NoteDocument.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageExtras.h"
#import "DocEntity.h"
#import "AppDelegate.h"
#import "DiaryListViewController.h"
#import "FilePath.h"
#import "DiaryInfoViewController.h"
#import "PlistDocument.h"
#import "TTSocial.h"

typedef enum
{
    none = 0x0, //表示没注名天气
    sunny,
    cloudy,
    overcast,    //阴天
    rain,
    snow,
}Weather;
typedef enum
{
    noneFeel = 0x0,//表示没注名心情
    excited,//激动
    happy,
    terrible,
    embarrassed,
    disappointed,
    sad,
    angry,
    cry,
    laugh,//大笑
    smaile,//微笑
}Feel;
const NSInteger ActionSheetDelete = 1020;
const NSInteger ActionSheetShare = 1021;
const NSInteger kActionSheetPickPhoto = 1000;

@interface DiaryContentViewController ()
{
    ScrollableToolView *scrollableToolView;
    float keyboardHeight;
    
    int index;
    Weather weather;
    Feel feel;
    NSString *label;
    BOOL hasImage;
    BOOL hasVideo;
    BOOL hasAudio;
    
    NSURL *localURL;
    
    NSMutableArray *regularFiles;
    
    NSString *insertImagePath;
    CGSize htmlImageSize;
    NSString *htmlPath;
    
    // doc 文件是否打开
    BOOL opened;
    
    TTSocial *social;
}
@property (nonatomic, copy)NSString *insertImagePath;
@property (nonatomic, copy)NSString *htmlPath;
@property (nonatomic, retain)ScrollableToolView *scrollableToolView;
@property (nonatomic, retain)NoteDocument *doc;
- (void)saveDocument:(BOOL)close;
- (void)removeBar;
- (void)getMedia:(UIImagePickerControllerSourceType)sourceType media:(CFStringRef)mediaType;
@end

@implementation DiaryContentViewController
@synthesize richEditor, resaveDate;
@synthesize htmlFileURL,scrollableToolView;
@synthesize filePathToSave;
@synthesize doc;
@synthesize insertImagePath, htmlPath;
@synthesize newFile;
@synthesize shareButton, deleteButton, saveButton, editButton, addButton, cancleButton;
@synthesize innerHtmlAtStart;
@synthesize entity;
@synthesize imagePickerController;
@synthesize toolbar;
@synthesize listViewController, preButton, nextButton;
@synthesize title, tagStr, creatTime, modifyTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        newFile = YES;
        opened = NO;
        
        editMode = NO;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }
    
    CGRect rect = app.adBanner.frame;
    rect.origin.y = 0;
    app.adBanner.frame = rect;
    app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:app.adBanner];
    [app.adBanner setRootViewController:self];
}

- (void)viewDidLoad
{
    feel = noneFeel;
    weather = none;
    regularFiles = [[NSMutableArray alloc] init];
    htmlImageSize = CGSizeZero;
    
    social = [[TTSocial alloc] init];
    social.viewController = self;
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton setFrame:CGRectMake(0, 0, 40, 40)];
    [editButton addTarget:self
                   action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(0, 0, 42, 42)];
    [searchButton addTarget:self
                     action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIDevice currentDevice].systemVersion compare:@"6.0"] == NSOrderedSame
        || [[UIDevice currentDevice].systemVersion compare:@"6.0"] == NSOrderedDescending)
    {
        aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    }
    else
    {
        aSearchBar = [[InputSeachBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    }
    [self.navigationController.navigationBar addSubview:aSearchBar];
    aSearchBar.delegate = self;
    aSearchBar.showsCancelButton = YES;
    aSearchBar.tintColor = [UIColor colorFromHex:0x40adbc];
    aSearchBar.alpha = 0.0;
    searchlabel.textColor = [UIColor blackColor];
    searchlabel.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *searchItem = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    UIBarButtonItem *editItem = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    if (!newFile)
    {
        self.navigationItem.rightBarButtonItems = @[searchItem, editItem];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_select"] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
                   action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *date = [FilePath timeFromURL:htmlFileURL];
    int width = 100;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = view;

    dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    dayLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:dayLabel];
    dayLabel.textAlignment = UITextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:30];
    dayLabel.text = [FilePath day:date];
    dayLabel.textColor = [UIColor darkGrayColor];
    
    weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 150, 14)];
    weekLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:weekLabel];
    weekLabel.textColor = [UIColor darkGrayColor];
    weekLabel.font = [UIFont systemFontOfSize:12];
    weekLabel.text = [FilePath week:date];
    weekLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    myLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 150, 14)];
    myLable.backgroundColor = [UIColor clearColor];
    [view addSubview:myLable];
    myLable.textColor = [UIColor darkGrayColor];
    myLable.font = [UIFont systemFontOfSize:12];
    myLable.text = [FilePath monthAndYear:date];
    myLable.numberOfLines=0;
    myLable.lineBreakMode = UILineBreakModeCharacterWrap;
    [view release];

    [self.toolbar setTintColor:HEXCOLOR(0xfcfcfc, 1)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbarbk"]
                  forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];

    keyboardHeight = 0;

    CGRect rc = self.view.bounds;
    rc.origin.y = 50;
    rc.size.height -= 106;
    self.richEditor = [[[RichEditView alloc] initWithFrame:rc] autorelease];
    self.richEditor.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleWidth;
    self.richEditor.delegate = self;
    [self.view addSubview:self.richEditor];

    NSArray *images = [NSArray arrayWithObjects:@"bold.png", @"italic", @"underline",@"fontp", @"fontj", @"pic.png", @"indent.png", @"outdent.png", @"list.png",
                       @"list123.png",@"justLeft",@"justCenter",@"justRight",@"HideKey.png", nil];
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.scrollableToolView = [[[ScrollableToolView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 68)
                                                              imageNames:images
                                                              titleArray:nil
                                                                delegate:self] autorelease];
    scrollableToolView.editView = self.richEditor;
    
    [self.view addSubview:scrollableToolView];
    
    self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePickerController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive:) 
                                                 name:@"appillssResignActive" object:nil];
    headView.backgroundColor = [UIColor redColor];
    
    [self loadContent];
}

- (void)loadContent
{
    BOOL firstObj = YES;
    BOOL lastObj = YES;
    if (!newFile)
    {
        firstObj = [(DiaryListViewController *)self.listViewController isFirstObj:self.entity];
        lastObj = [(DiaryListViewController *)self.listViewController isLastObj:self.entity];
    }
 
    if (firstObj && lastObj)
    {
        self.preButton.enabled = NO;
        self.nextButton.enabled = NO;
    }
    else
    {
        if (!firstObj)
        {
            self.preButton.enabled = YES;
        }
        else
        {
            self.preButton.enabled = NO;
        }
        
        if (!lastObj)
        {
            self.nextButton.enabled = YES;
        }
        else
        {
            self.nextButton.enabled = NO;
        }
    }

    [self.richEditor loadHtmlPath:htmlFileURL];
    
    NSURL *docURL = [self.htmlFileURL URLByDeletingLastPathComponent];
    NoteDocument *document = [[NoteDocument alloc] initWithFileURL:docURL];
    self.doc = document;
    [document release];
    
    // 查询存储的文件, 需要打开以查询文件夹已经包含的文件,便于编辑
    if (!newFile)
    {
        [self.doc openWithCompletionHandler:^(BOOL success){
            
            opened = success;
            
            if (!success)
            {
                NSLog(@"failed to open file %@", docURL);
            }
            else
            {
                [self.doc closeWithCompletionHandler:^(BOOL closeSuccess){}];
            }
        }];
    }
    
    NSDate *date = [FilePath timeFromURL:htmlFileURL];
    dayLabel.text = [FilePath day:date];
    weekLabel.text = [FilePath week:date];
    myLable.text = [FilePath monthAndYear:date];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)exitAction:(id)sender
{
    NSURL *plistUrl = [[self.doc.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"DiaryInfoLog"];
    
    BOOL newDiary = NO;
    DiaryInfo *info = nil;
    NSArray *array = [AppDelegate app].diaryInfoArray;
    for (int i=0; i<[array count]; i++)
    {
        DiaryInfo *tmpInfo = [array objectAtIndex:i];
        if ([tmpInfo.url isEqualToString:[self.doc.fileURL path]])
        {
            info = tmpInfo;
            break;
        }
    }
    
    if (info == nil)
    {
        newDiary = YES;
        info = [[DiaryInfo alloc] init];
        [[AppDelegate app].diaryInfoArray addObject:info];
    }
   
    info.url = [self.doc.fileURL path];
    info.title = entity.title;
    
    for (int i=0; i<[entity.tags count]; i++)
    {
        if (i == 0)
        {
            info.tags = [entity.tags objectAtIndex:0];
        }
        else
        {
            info.tags = [info.tags stringByAppendingFormat:@"|%@", [entity.tags objectAtIndex:i]];
        }
    }

    info.creatTime = entity.creatTime; 
    
    PlistDocument *plistDoc = [[PlistDocument alloc] initWithFileURL:plistUrl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[plistUrl path]])
    {
        // 如果存在就先打开
        [plistDoc openWithCompletionHandler:^(BOOL success){
            
            if (success)
            {
                [plistDoc saveDiaryInfo:info];
                [plistDoc saveToURL:plistUrl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
                [plistDoc closeWithCompletionHandler:nil];
            }
            
            if (newDiary)
            {
                [info release];
            }
            
        }];
    }
    else
    {
        [plistDoc saveDiaryInfo:info];
        [plistDoc saveToURL:plistUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            
            if (success)
            {
                [plistDoc closeWithCompletionHandler:nil];
            }
            
            if (newDiary)
            {
                [info release];
            }
        }];
    }
    [self.richEditor removeAllHighlights];
    [self saveDocument:YES];
    
    // 重新ReloadData 刷新资源列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSourceChanged" object:self.entity];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 只有是新建的日记,才需要在页面加载完成时去reload tableView
    if (newFile)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataSourceChanged" object:entity];
    }
}

- (IBAction)editAction:(id)sender
{
    if (!editMode)
    {
        [editButton setImage:[UIImage imageNamed:@"edit_select"] forState:UIControlStateNormal];
        [self.richEditor setEditable:YES];
    }
    else
    {
        [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [self.richEditor closeKeyboard];
        [self.richEditor setEditable:NO];
    }
    
    editMode = !editMode;
}

- (IBAction)searchAction:(id)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        
        CGRect rc = aSearchBar.frame;
        rc.origin.y = 0;
        aSearchBar.frame = rc;
        [self.navigationController.navigationBar bringSubviewToFront:aSearchBar];
        [aSearchBar becomeFirstResponder];
        aSearchBar.alpha = 1.0;
    }
                     completion:^(BOOL finished){}];
}

- (IBAction)preResult:(id)sender
{
    if (totalSeachResult == 0)
    {
        return;
    }
    
    curIndex--;
    if (curIndex == -1)
    {
        curIndex = totalSeachResult - 1;
    }
    [self.richEditor showResult:curIndex];
    
    searchlabel.text = [NSString stringWithFormat:@"%d/%d", curIndex+1, totalSeachResult];
}

- (IBAction)nextResult:(id)sender
{
    if (totalSeachResult == 0)
    {
        searchlabel.text = NSLocalizedString(@"No Matches", nil);
        return;
    }

    curIndex = (curIndex + 1) % totalSeachResult;
    
    [self.richEditor showResult:curIndex];
    
    searchlabel.text = [NSString stringWithFormat:@"%d/%d", curIndex+1, totalSeachResult];
}

- (IBAction)cancelAction:(id)sender
{
}

- (IBAction)saveAction:(id)sender
{
    [self saveDocument:YES];
}

- (IBAction)shareAction:(id)sender
{
    UIActionSheet *actionSheet = nil;
    if ([[UIDevice currentDevice].systemVersion compare:@"6.0"] == NSOrderedDescending
        || [[UIDevice currentDevice].systemVersion compare:@"6.0"] == NSOrderedSame)
    {
       actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                        destructiveButtonTitle:nil
                             otherButtonTitles:NSLocalizedString(@"SMS", nil),NSLocalizedString(@"Email", nil)
           ,NSLocalizedString(@"Facebook", nil)
           ,NSLocalizedString(@"Twitter", nil),
           NSLocalizedString(@"Sina", nil), nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"SMS", nil),NSLocalizedString(@"Email", nil), nil];
    }

    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = ActionSheetShare;
    actionSheet.delegate = self;
	[actionSheet showInView:self.view];
}

- (IBAction)deleteAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
                                                    otherButtonTitles:nil, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
    actionSheet.tag = ActionSheetDelete;
    actionSheet.delegate = self;
	[actionSheet release];
}

- (IBAction)addAction:(id)sender
{
    
}

- (void)askPhotoSourceType
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"snapshot", nil), NSLocalizedString(@"PhotoLibray", nil), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = kActionSheetPickPhoto;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)saveDocument:(BOOL)close
{
    
    // 插入图片需要先保存图片,在插入HTML标签,所以获取outerHtml有滞后性,获取的是插入图片标签前的内容
    // edited表示是否编辑了,如果插入图片,点击保存按钮相对于重复调用了saveDocument, 所以退出页面的时候不需要再保存了.
    // edited就是在点击保存安扭的函数中设置为NO的.
    
    
    NSString *newInnerHtml = [self.richEditor innerHtml];

    // 如果HTML内容发生改变或者插入图片都需要保存(插入图片时两个HTMLString可能是一样的)
    if (![self.innerHtmlAtStart isEqualToString:newInnerHtml] || self.insertImagePath.length > 0)
    {
        self.innerHtmlAtStart = newInnerHtml;
    }
    else
    {
        // 不需要保存
        return;
    }
 
    UIImage *thumbnail = nil;
    NSString *firstImgSrc = [self.richEditor firstImageTagSrc];
    
    if (firstImgSrc.length > 0)
    {
        NSURL *url = [[self.htmlFileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:firstImgSrc];
        UIImage *image = [UIImage imageWithContentsOfFile:url.path];
        thumbnail = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
    }
    
    if (self.doc != nil)
    {
        [self.doc setThumbnail:thumbnail];
        if (entity.metadata == nil)
        {
            entity.metadata = [[[Metadata alloc] init] autorelease];
        }
        
        // UIImagePNGRepresentation不知道为什么会使得图片的大小加倍,但是由于iCloud存储这样用了,为了统一,所以这里也去
        // UIImagePNGRepresentation一下.
        NSData *pngData = UIImagePNGRepresentation(thumbnail);
        
        // 设置entiry后就发消息出去更新UI
        entity.metadata.thumbnailImage = [UIImage imageWithData:pngData];
    }
    
    NSString *detailText = [self.richEditor getGeneralText];
    [self.doc setDetailText:detailText];
    entity.metadata.detailText = detailText;
    
    NSString *htmlString = [self.richEditor outerHtml];
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *docName = [self.htmlFileURL lastPathComponent];
    RegularFile *htmlFile = [[RegularFile alloc] initWithFileName:docName data:data];
    [self.doc addRegularFile:htmlFile];
    [htmlFile release];
    
    NSURL *docURL = [self.htmlFileURL URLByDeletingLastPathComponent];
    [self.doc saveToURL:docURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        
        dispatch_async(dispatch_get_main_queue(), ^{                        
            if (success)
            {
                if (self.insertImagePath.length > 0)
                {
                    if (richEditor != nil)
                    {
                        [self.richEditor restoreRange];
                        [self.richEditor insertImage:self.insertImagePath size:htmlImageSize];
                        self.insertImagePath = nil;
                    }
                }
                
                if (close)
                {
                    [self.doc closeWithCompletionHandler:^(BOOL closeSuccess){}];
                }
            }
        });
    }];
}

- (void)loadOtherContent:(DocEntity *)entry direction:(BOOL)pre
{
    UIViewAnimationOptions options = pre ? UIViewAnimationOptionTransitionCurlDown : UIViewAnimationOptionTransitionCurlUp;
    [UIView transitionWithView:self.view
                      duration:0.65
                       options:options
                    animations:nil
                    completion:^(BOOL complete){
                        
                        if (entry != nil)
                        {
                            NSString *htmlName = [[[entry.docURL lastPathComponent] stringByDeletingPathExtension] stringByAppendingFormat:HTMLExtentsion];
                            NSURL *url = [entry.docURL URLByAppendingPathComponent:htmlName];
                            NSLog(@"%@", [url path]);
                            self.htmlFileURL = url;
                            self.newFile = NO;
                            self.entity = entry;
                            
                            [self loadContent];
                        }
                        
                    }];

}

- (IBAction)loadNextContent:(id)sender
{
    DocEntity *entry = [(DiaryListViewController *)self.listViewController nextUrl:self.entity];
    if (entry != nil)
    {
        [self loadOtherContent:entry direction:NO];
    }
    [self.editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
}

- (IBAction)loadPreContent:(id)sender
{
    DocEntity *entry = [(DiaryListViewController *)self.listViewController preUrl:self.entity];
    if (entry != nil)
    {
        [self loadOtherContent:entry direction:YES];
    }
    
    [self.editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
}

- (IBAction)diaryInfoView:(id)sender
{
    DiaryInfoViewController *infoViewController = [[DiaryInfoViewController  alloc] initWithNibName:@"DiaryInfoViewController"
                                                                                             bundle:nil];
    infoViewController.entity = self.entity;
    [self.navigationController pushViewController:infoViewController animated:YES];
    [infoViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kActionSheetPickPhoto)
    {
        if (buttonIndex == 0)
        {
            [self.richEditor saveRange];
            [self getMedia: UIImagePickerControllerSourceTypeCamera media:kUTTypeImage];
        }
        else if (buttonIndex == 1)
        {
            [self.richEditor saveRange];
            [self getMedia: UIImagePickerControllerSourceTypePhotoLibrary media:kUTTypeImage];
        }
    }
    else if (actionSheet.tag == ActionSheetDelete)
    {
        if (buttonIndex == 0)
        {
            [self deleteFile];
        }
    }
    else if (actionSheet.tag == ActionSheetShare)
    {
        NSString *text = [self.richEditor getGeneralText];
        [self shareText:text index:buttonIndex];
    }
}

- (void)shareText:(NSString *)text index:(NSInteger)aIndex
{
    if (aIndex == 0)
    {
        [social showSMSPicker:text phones:nil];
    }
    else if (aIndex == 1)
    {
        [social showMailPicker:text to:nil cc:nil bcc:nil images:nil];
    }
    else if (aIndex == 2)
    {
        [social showFaceBook:text];
    }
    else if (aIndex == 3)
    {
        [social showTwitter:text];
    }
    else if (aIndex == 4)
    {
        [social showSina:text];
    }
}

- (void)keyboardWillShow:(NSNotification *)notice
{

    [self performSelector:@selector(removeBar) withObject:nil afterDelay:0];
    
}

- (void)keyboardWillHide:(NSNotification *)notice
{
    
}

- (void)keyboardFrameChanged:(NSNotification *)notice
{
    NSValue *rectValue= [[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardHeight = [rectValue CGRectValue].size.height;
}

- (void)removeBar
{
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if (![[testWindow class] isEqual:[UIWindow class]])
        {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIWebFormView.
    for (UIView *possibleFormView in [keyboardWindow subviews])
    {
        // iOS 5 sticks the UIWebFormView inside a UIPeripheralHostView.
        if ([[possibleFormView description] rangeOfString:@"UIPeripheralHostView"].location != NSNotFound)
        {
            for (UIView *subviewWhichIsPossibleFormView in [possibleFormView subviews])
            {
                if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound)
                {
                    [subviewWhichIsPossibleFormView removeFromSuperview];
                }
        
                // iOS 6 leaves a grey border / shadow above the hidden accessory row
                if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIImageView"].location != NSNotFound) {
                    // we need to add the QuartzCore framework for the next line
                    [[subviewWhichIsPossibleFormView layer] setOpacity: 0.0];
                }
            }
            
        }
    }
}

- (IBAction)closeKeyboard:(id)sender
{
    if (richEditor != nil)
    {
        [self.richEditor closeKeyboard];
    }
}

- (void)scrollWindow:(float)caretPos
{
    // 根据光标的位置来确定需要scroll的值
    float height = self.view.frame.size.height;
    float dontScroll = height - keyboardHeight;
    if (caretPos >= dontScroll)
    {
        if (richEditor != nil)
        {
            [self.richEditor scrollBy:(caretPos - dontScroll + 10)];
        }
    }
}

- (void)deleteFile
{
    NSArray *array = [AppDelegate app].diaryInfoArray;
    for (int i=0; i<[array count]; i++)
    {
        DiaryInfo *tmpInfo = [array objectAtIndex:i];
        if ([tmpInfo.url isEqualToString:[self.doc.fileURL path]])
        {
            [[AppDelegate app].diaryInfoArray removeObject:tmpInfo];
            break;
        }
    }
    
    NSURL *plistUrl = [[self.doc.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"DiaryInfoLog"];
    PlistDocument *plistDoc = [[PlistDocument alloc] initWithFileURL:plistUrl];
    [plistDoc openWithCompletionHandler:^(BOOL success){
        
        if (success)
        {
            [plistDoc removeKey:[self.doc.fileURL path]];
            [plistDoc saveToURL:plistUrl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
            [plistDoc closeWithCompletionHandler:nil];
        }
        
        [plistDoc release];
    }];


    [(DiaryListViewController *)listViewController deleteFile:self.entity];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark RichEditViewDelegate

- (void)richEditor:(RichEditView *)aRichEditor shouldStartLoadWithRequest:(NSURLRequest *)request
{
    NSString *string = [[request URL] absoluteString];
    NSLog(@"%@", string);
    NSArray *array = [string componentsSeparatedByString:@":"];
    if ([array count] > 0)
    {
        NSString *subString = [array objectAtIndex:0];
        if ([subString isEqualToString:@"cmd"])
        {
            subString = [array objectAtIndex:1];
            array = [subString componentsSeparatedByString:@"@"];
            if ([array count] > 0)
            {
                NSString *function = [array objectAtIndex:0];
                if ([function isEqualToString:@"scrollWindow"])
                {
                     NSArray *parameters = [[array objectAtIndex:1] componentsSeparatedByString:@"&"];
                    float height = [[parameters objectAtIndex:1] floatValue];
                    
                    [self scrollWindow:height];
                }
            }
            
        }
    }
}

- (void)richEditorDidFinishLoad:(RichEditView *)aRichEditor
{
    // 如果是查看模式时,刚开始将html 设置成不可编辑
    if (!newFile)
    {
        [self.richEditor setEditable:NO];
    }
    
    self.innerHtmlAtStart = [aRichEditor innerHtml];
}

#pragma mark ScrollableToolViewDelegate

- (BOOL)shouldBeFirstResponder
{
    return ![aSearchBar isFirstResponder];
}

- (void)selectItemOnScrollTool:(id)sender
{
    if (richEditor == nil)
    {
        return;
    }
    
    UIButton *aButton = (UIButton *)sender;
    NSUInteger tag = aButton.tag;
    switch (tag)
    {
        case 1000:
        {
            [self.richEditor bold];
        }break;
        case 1001:
        {
            [self.richEditor italic];
        }break;
        case 1002:
        {
            [self.richEditor underline];
        }break;
        case 1003:
        {
            NSInteger fontSize = [self.richEditor getCurrentFontSize];
            [self.richEditor setFontSize:fontSize + 1];
        }break;
        case 1004:
        {
            NSInteger fontSize = [self.richEditor getCurrentFontSize];
            [self.richEditor setFontSize:fontSize - 1];
        }break;
        case 1005:
        {
            [self askPhotoSourceType];

        }break;
        case 1006:
        {
            [self.richEditor indent];
        }break;
        case 1007:
        {
            [self.richEditor outdent];
        }break;
        case 1008:
        {
            [self.richEditor insertUnorderedList];
        }break;
        case 1009:
        {
            [self.richEditor insertOrderedList];
            
        }break;
        case 1010:
        {
            [self.richEditor justifyLeft];
        }break;
        case 1011:
        {
            [self.richEditor justifyCenter];
        }break;
        case 1012:
        {
            [self.richEditor justifyRight];
        }break;
        case 1013:
        {
            [self.richEditor closeKeyboard];
        }break;
        default:
        break;
    }
}

- (void)getMedia:(UIImagePickerControllerSourceType)sourceType media:(CFStringRef)mediaType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        self.imagePickerController.sourceType = sourceType;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave = nil;

    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            imageToSave = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            // 拍照片
            editedImage = (UIImage *) [info objectForKey:
                                       UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey:
                                         UIImagePickerControllerOriginalImage];
            if (editedImage)
            {
                imageToSave = editedImage;
            }
            else
            {
                imageToSave = originalImage;
            }
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        }
        
        CGSize size;
        if (imageToSave.size.width / imageToSave.size.height >= 1)
        {
            size.width = 280;
            size.height = (imageToSave.size.height / imageToSave.size.width) * size.width;
        }
        else
        {
            size.width = 280;
            size.height = (imageToSave.size.height / imageToSave.size.width) * size.width;
        }

        UIImage *scaledImage = [imageToSave imageByBestFitForSize:size];
        NSData *imgData = UIImagePNGRepresentation(scaledImage);
        
        time_t time = [[NSDate date] timeIntervalSince1970];
        NSString *imgName = [NSString stringWithFormat:@"%lu.png", time];
        self.insertImagePath = imgName;
        htmlImageSize = size;
        
        // 开始保存
        RegularFile *imageFile = [[RegularFile alloc] initWithFileName:imgName
                                                                  data:imgData];
        [self.doc addRegularFile:imageFile];
        [self saveDocument:NO];
        
        [imageFile release];
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void)resignActive:(NSNotification *)notification
{
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark -- SearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.richEditor removeAllHighlights];
    if (!newFile)
    {
        [self.richEditor setEditable:YES];
    }
    curIndex = -1;
    searchlabel.text = nil;
    totalSeachResult = [self.richEditor highlightAllOccurencesOfString:searchBar.text];
    [searchBar resignFirstResponder];
    
    [self.view addSubview:searchResultBar];
    [self.view bringSubviewToFront:searchResultBar];
    searchResultBar.frame = CGRectMake(0, self.view.frame.size.height - 44, 320, 44);
    [self nextResult:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [aSearchBar resignFirstResponder];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                selector:@selector(enableCancelButton)
                                                userInfo:nil repeats:YES];
}

- (void)enableCancelButton
{
    for(id subview in [aSearchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subview;
            if (!button.enabled)
            {
                [subview setEnabled:YES];
            }
            else
            {
                [self.timer invalidate];
            }
            
            break;
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.richEditor removeAllHighlights];
    [aSearchBar resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        
        CGRect rc = aSearchBar.frame;
        rc.origin.y = -44;
        aSearchBar.frame = rc;
        aSearchBar.alpha = 0.0;
    }
                     completion:^(BOOL finished){}];
    curIndex = -1;
    searchlabel.text = nil;
    aSearchBar.text = nil;
    [UIView animateWithDuration:0.35 animations:^{
        
        CGRect rect = searchResultBar.frame;
        rect.origin.y += 50;
        searchResultBar.frame = rect;
    }
                     completion:^(BOOL finished){
                     
                         [searchResultBar removeFromSuperview];
                     }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
    [dayLabel release];
    [myLable release];
    [weekLabel release];
    [aSearchBar release];
    [richEditor release];
    [resaveDate release];
    [htmlFileURL release];
    [scrollableToolView release];
    [searchlabel release];
    [searchResultBar release];
    [filePathToSave release];
    [doc release];
    
    [regularFiles release];
    
    [insertImagePath release];
    [htmlPath release];
    [shareButton release];
    [deleteButton release];
    [saveButton release];
    [editButton release];
    [addButton release];
    [cancleButton release];
    
    [innerHtmlAtStart release];
    [entity release];
    [imagePickerController release];
    [rightItems release];
    [toolbar release];
    
    [preButton release];
    [nextButton release];
    
    [tagStr release];
    [title release];
    [creatTime release];
    [modifyTime release];

    [super dealloc];
}
@end
