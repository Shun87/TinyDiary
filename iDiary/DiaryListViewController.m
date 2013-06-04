//
//  DiaryListViewController.m
//  iDiary
//
//  Created by ; on 12-11-16.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "DiaryListViewController.h"
#import "DiaryContentViewController.h"
#import "CommmonMethods.h"
#import "DiaryDescription.h"
#import "NoteDocument.h"
#import "MonthSort.h"

#import "NSDateAdditions.h"
#import "FilePath.h"
#import "NSDate+FormattedStrings.h"
#import "AppDelegate.h"
#import "PlistDocument.h"
#import "UIColor+HexColor.h"

NSString *const TDDocumentsDirectoryName = @"Documents";
NSString *const HTMLExtentsion = @".html";


@interface DiaryListViewController ()
{    
    NoteDocument *document;
    
    NSIndexPath *indexPathToDel;
    NSIndexPath *indexPathToShare;
}
@property (nonatomic, retain)NSIndexPath *indexPathToShare;
@property (nonatomic, retain)NSIndexPath *indexPathToDel;
@property (nonatomic, retain)NSURL *iCloudRoot;
@property (nonatomic, retain) NoteDocument *document;

@end

@implementation DiaryListViewController
@synthesize mTableView;
@synthesize tmpCell, cellNib;
@synthesize deleteButton, addButton, cancelButton, editButton, settingsButton, toolbar;
@synthesize iCloudRoot;
@synthesize document;
@synthesize indexPathToDel, indexPathToShare;
@synthesize tagName, specDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Timeline", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"timeline"];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [mTableView release];
    [tmpCell release];
    [cellNib release];

    [deleteButton release];
    [addButton release];
    [cancelButton release];
    [editButton release];
    [toolbar release];
    [settingsButton release];
    
    [iCloudRoot release];
    [document release];
    [indexPathToDel release];
    [indexPathToShare release];
    [tagName release];
    [specDate release];
    [monthAndYearArray release];
    [super dealloc];
}


#pragma mark View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellNib = [UINib nibWithNibName:@"AdvancedCell" bundle:nil];
    
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    self.mTableView.rowHeight = 80;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundView = nil;
    mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.allowsSelectionDuringEditing = YES;
    
    mySocial = [[TTSocial alloc] init];
    mySocial.viewController = self;
    
    monthAndYearArray = [[NSMutableArray alloc] init];
    if ([tagName length] > 0 || specDate != nil)
    {
        // TAG页面
        if ([tagName length] > 0)
        {
             self.navigationItem.title = tagName;
        }
        else if (specDate != nil)
        {
            int width = 100;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
            view.backgroundColor = [UIColor clearColor];
            self.navigationItem.titleView = view;
            
            UILabel *dayLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)] autorelease];
            dayLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:dayLabel];
            dayLabel.textAlignment = UITextAlignmentCenter;
            dayLabel.textColor = [UIColor blackColor];
            dayLabel.font = [UIFont boldSystemFontOfSize:30];
            dayLabel.text = [FilePath day:self.specDate];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.shadowColor = [UIColor darkGrayColor];
            
            UILabel *weekLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 8, 150, 14)] autorelease];
            weekLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:weekLabel];
            weekLabel.textColor = [UIColor whiteColor];
            weekLabel.font = [UIFont systemFontOfSize:12];
            weekLabel.text = [FilePath week:self.specDate];
            weekLabel.shadowColor = [UIColor darkGrayColor];
            weekLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            
            UILabel *yearLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 22, 150, 14)] autorelease];
            yearLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:yearLabel];
            yearLabel.textColor = [UIColor whiteColor];
            yearLabel.font = [UIFont systemFontOfSize:12];
            yearLabel.text = [FilePath monthAndYear:self.specDate];
            yearLabel.shadowColor = [UIColor darkGrayColor];
            yearLabel.numberOfLines=0;
            yearLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            [view release];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 42, 40)];
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self
                   action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = rightItem;
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 40, 40)];
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self
                   action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    }
   
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentStateChange:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSourceChanged:)
                                                 name:@"DataSourceChanged" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive:) 
                                                 name:@"appillssResignActive" object:nil];
    // APP发消息通知重新加载数据源
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadSource:) 
                                                 name:ReloadDiaryInfoUnits object:nil];
}

- (void)reloadDataFromArray:(NSArray *)units
{
    [monthAndYearArray removeAllObjects];
    
    [self addSortedEntryByMonthAndYear:units];
    [self.mTableView reloadData];
}

- (void)resignActive:(NSNotification *)notification
{
    if ([self.tagName length] > 0 || specDate != nil)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)reloadSource:(NSNotification *)notification
{
    [self reloadDataFromArray:(NSArray *)[notification object]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)resolveConfict:(NSURL *)url
{
    // newest version wins
    [NSFileVersion removeOtherVersionsOfItemAtURL:url error:nil];
    NSArray* conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:url];
    for (NSFileVersion* fileVersion in conflictVersions) {
        fileVersion.resolved = YES;
    }
}

- (void)documentStateChange:(NSNotification *)notification
{
    UIDocument *doc = (UIDocument *)notification.object;
    if (doc != nil)
    {
        UIDocumentState state = doc.documentState;
        if (state & UIDocumentStateInConflict)
        {
            [self resolveConfict:doc.fileURL];
        }
    }
}

// 添加修改数据源的时候发送的消息处理函数
- (void)dataSourceChanged:(NSNotification *)notification
{
    DocEntity *entry = (DocEntity *)[notification object];
    NSDate *date = [FilePath timeFromURL:entry.docURL];
    NSString *monthAndYear = [FilePath monthAndYear:date];
    if (entry != nil)
    {
        if (entry.indexPath != nil)
        {
            int nSection = 0;
            int nRow = 0;
            for (int i=0; i<[monthAndYearArray count]; i++)
            {
                MonthSort *monthSort = [monthAndYearArray objectAtIndex:i];
                if ([monthSort.monthAndYear isEqualToString:monthAndYear])
                {
                    nSection = i;
                    if ([monthSort.entryArray containsObject:entry])
                    {
                        nRow = [monthSort.entryArray indexOfObject:entry];
                    }
                    break;
                }
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nRow inSection:nSection];
            [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            // 添加的情况
            NSInteger index = [self indexForMonthAndYear:monthAndYear];
            if (index >= 0 && index < [monthAndYearArray count])
            {
                MonthSort *monthSort = [monthAndYearArray objectAtIndex:index];
                [monthSort.entryArray insertObject:entry atIndex:0];

            }
            else
            {
                MonthSort *monthSort = [[MonthSort alloc] init];
                monthSort.monthAndYear = monthAndYear;
                [monthSort.entryArray addObject:entry];
                [monthAndYearArray addObject:monthSort];
            }

            [self.mTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
    
        }
    }
}

- (IBAction)addAction:(id)sender
{
    NSString *wrapperName = [FilePath generateFileNameBy:[NSDate date] extension:kNotePacketExtension];
    NSURL *wrapperURL = nil;

    NSURL *cloudRootURL = [[AppDelegate app].docAccess.ubiquityURL URLByAppendingPathComponent:TDDocumentsDirectoryName isDirectory:YES];
    if ([AppDelegate app].docAccess.iCloudAvailable && [[AppDelegate app].docAccess iCloudOn])
    {
        wrapperURL = [cloudRootURL URLByAppendingPathComponent:wrapperName];
    }
    else
    {
        wrapperURL = [FilePath getDocURL:wrapperName];
    }
    
    self.document = [[[NoteDocument alloc] initWithFileURL:wrapperURL] autorelease];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"index.html" ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path 
                                                  encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *htmlName = [[[wrapperURL lastPathComponent] stringByDeletingPathExtension] stringByAppendingFormat:HTMLExtentsion];
    RegularFile *htmlFile = [[RegularFile alloc] initWithFileName:htmlName data:data];
    [document addRegularFile:htmlFile];
    [htmlFile release];
    
    [document saveToURL:wrapperURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL creatSuccess) {
        
        if (creatSuccess)
        {
            Metadata * metadata = document.metadata;
            NSURL * fileURL = document.fileURL;
            UIDocumentState state = document.documentState;
            NSFileVersion * version = [NSFileVersion currentVersionOfItemAtURL:fileURL];
                        
            [document closeWithCompletionHandler:^(BOOL closeSuccess){
                
                if (closeSuccess)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        DocEntity *entity = [[[DocEntity alloc] initWithFileURL:fileURL
                                                            metadata:metadata
                                                               state:state
                                                             version:version] autorelease];
                        
                        [self showDiaryContent:entity newFile:YES];
                        
                        // 数据源的添加放在消息接受中处理, 这样可以避免在push页面时看到tableView的添加动画
                        
                    });
                }
            }];
        }
    }];
}

- (IBAction)editAction:(id)sender
{
    [self.mTableView setEditing:YES animated:YES];
    
    NSArray *items = self.toolbar.items;
    NSArray *array = [NSArray arrayWithObjects:[items objectAtIndex:0], self.deleteButton, nil];
    [self.toolbar setItems:array animated:YES];
    
    self.navigationItem.rightBarButtonItem = self.cancelButton;
}

- (IBAction)cancelAction:(id)sender
{
    [self.mTableView setEditing:NO animated:YES];
    
    NSArray *items = self.toolbar.items;
    NSArray *array = [NSArray arrayWithObjects:[items objectAtIndex:0], self.addButton, nil];
    [self.toolbar setItems:array animated:YES];
    
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (void)showDiaryContent:(DocEntity *)entity newFile:(BOOL)newFile
{
    NSString *htmlName = [[[entity.docURL lastPathComponent] stringByDeletingPathExtension] stringByAppendingFormat:HTMLExtentsion];
    NSURL *url = [entity.docURL URLByAppendingPathComponent:htmlName];
    DiaryContentViewController *contentViewController = [[DiaryContentViewController alloc] initWithNibName:@"DiaryContentViewController"
                                                                                                     bundle:nil];
    contentViewController.hidesBottomBarWhenPushed = YES;
    contentViewController.htmlFileURL = url;
    contentViewController.newFile = newFile;
    contentViewController.entity = entity;
    contentViewController.listViewController = self;

    UINavigationController *modalNavController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    [self presentModalViewController:modalNavController animated:YES];
    [contentViewController release];
    [modalNavController release];
}

- (void)deleteFile:(DocEntity *)entry
{
    // 删除文件
    if ([AppDelegate app].docAccess != nil)
    {
        [[AppDelegate app].docAccess deleteFile:entry.docURL];
    }
    
    // 删除数据源
    NSDate *date = [FilePath timeFromURL:entry.docURL];
    NSString *monthAndYear = [FilePath monthAndYear:date];
    
    int nSection = 0;
    int nRow = 0;
    for (int i=0; i<[monthAndYearArray count]; i++)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:i];
        if ([monthSort.monthAndYear isEqualToString:monthAndYear])
        {
            nSection = i;
            if ([monthSort.entryArray containsObject:entry])
            {
                nRow = [monthSort.entryArray indexOfObject:entry];
                [monthSort.entryArray removeObject:entry];
            }
            break;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nRow inSection:nSection];
    [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareText:(NSString *)text index:(NSInteger)index
{
    if (index == 0)
    {
        [mySocial showSMSPicker:text phones:nil];
    }
    else if (index == 1)
    {
        [mySocial showMailPicker:text to:nil cc:nil bcc:nil images:nil];
    }
    else if (index == 2)
    {
        [mySocial showFaceBook:text];
    }
    else if (index == 3)
    {
        [mySocial showTwitter:text];
    }
//    else if (index == 4)
//    {
//        //[mySocial showSina:text];
//    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // @"Automatically store your documents in the cloud to keep them up-to-date across all your devices and the web."
    // Cancel: @"Later"
    // Other: @"Use iCloud"
    if (alertView.tag == 1)
    {
        if (buttonIndex == alertView.firstOtherButtonIndex) 
        {
            [[AppDelegate app].docAccess setiCloudOn:YES];            
            [self reloadNotes:YES];
        }                
    } 
}

- (void)fillCell:(AdvancedCell *)cell withEntity:(DocEntity *)entity
{
    // 这个方法不要调用tableView reloadData的方法，会造成死循环
    NSDate *date = [FilePath timeFromURL:entity.docURL];
    [cell setData:date];
    if (entity.metadata != nil)
    {
        if (entity.metadata.detailText != nil)
        {
            [cell setcontent:entity.metadata.detailText];
        }
        
        if (entity.metadata.thumbnailImage != nil)
        {
            cell.thumbnail = entity.metadata.thumbnailImage;
        }
    }
    
    if ([entity.title length] == 0)
    {
        [cell setTitleStr:NSLocalizedString(@"No title", nil)];
    }
    else
    {
        [cell setTitleStr:entity.title];
    }
}

- (void)metadataLoadSuccess:(DocEntity *)entity
{
    if (entity != nil)
    {
        entity.downloadSuccess = YES;
        AdvancedCell *cell = (AdvancedCell *)[self.mTableView cellForRowAtIndexPath:entity.indexPath];
        if (cell != nil)
        {
            [self fillCell:cell withEntity:entity];
        }
    }
}

- (void)startLoadDoc:(DocEntity *)entity forIndexPath:(NSIndexPath *)indexPath
{
    // entity的indexPath一定要在这里赋值,因为滑动的时候会去进到这里,但是参数INDEXPATH可能和entity的不一样,所以要以参数为准
    entity.indexPath = indexPath;
    NoteDocument *doc = [[NoteDocument alloc] initWithFileURL:entity.docURL];
    [doc openWithCompletionHandler:^(BOOL success){
        if (success)
        {
            // 只有需要去加载的时候才去设置indexPath，默认的indexPath为空
            entity.metadata = doc.metadata;
            entity.state = doc.documentState;
            entity.version = [NSFileVersion currentVersionOfItemAtURL:entity.docURL];
            [doc closeWithCompletionHandler:^(BOOL closeSuccess){
                
                // Check status
                if (!closeSuccess) {
                    NSLog(@"Failed to close %@", entity.docURL);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[AppDelegate app].hud hide:YES];
                    
                    [self metadataLoadSuccess:entity];
                    [doc release];
                    
                });
            }];
        }
        else
        {
            [[AppDelegate app].hud hide:YES];
            NSLog(@"Failed to openWithCompletionHandler %@", entity.docURL);
        }
    }];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([monthAndYearArray count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MonthSort *monthSort = [monthAndYearArray objectAtIndex:[indexPath section]];
            DocEntity *entity = [monthSort.entryArray objectAtIndex:[indexPath row]];
            if (!entity.metadata) // avoid the app icon download if the app already has an icon
            {
                [self startLoadDoc:entity forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  MAX([monthAndYearArray count], 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([monthAndYearArray count] > 0)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:section];
        return [monthSort.entryArray count];
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([monthAndYearArray count] >= 1)
    {
        return 25;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UIImage *image = [UIImage imageNamed:@"sectionBk"];
    imageView.image = image;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 320, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [imageView addSubview:label];
    MonthSort *monthSort = nil;
    if ([monthAndYearArray count] > 0)
    {
        monthSort = [monthAndYearArray objectAtIndex:section];
    }

    label.text = monthSort.monthAndYear;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorFromHex:0x717171];
    return imageView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AdvancedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = tmpCell;
        cell.delegate = self;
        self.tmpCell = nil;
    }
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"cellBk" ofType:@"png"];
    [cell setBackgroundImageName:backgroundImagePath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if ([monthAndYearArray count] > section)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:section];
        if ([monthSort.entryArray count] > row)
        {
            DocEntity *entity = [monthSort.entryArray  objectAtIndex:row];
            [self fillCell:cell withEntity:entity];
            if (entity.metadata == nil)
            {
                // 如果为空则去加载填充
                [self startLoadDoc:entity forIndexPath:indexPath];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!mTableView.isEditing)
    {
        NSInteger section = [indexPath section];
        if ([monthAndYearArray count] > section)
        {
            MonthSort *monthSort = [monthAndYearArray objectAtIndex:section];
            DocEntity *entity = [monthSort.entryArray objectAtIndex:[indexPath row]];
            if (!entity.downloadSuccess)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil) 
                                                                    message:NSLocalizedString(@"downloading", nil) 
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                return;
            }
            [self showDiaryContent:entity newFile:NO];
        }
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

//// 前一篇
- (DocEntity *)preUrl:(DocEntity *)entry
{
    DocEntity *result = nil;
    NSDate *date = [FilePath timeFromURL:entry.docURL];
    NSString *monthAndYear = [FilePath monthAndYear:date];
    for (int i=0; i<[monthAndYearArray count]; i++)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:i];
        if ([monthSort.monthAndYear isEqualToString:monthAndYear])
        {
            NSInteger index = [monthSort.entryArray indexOfObject:entry];
            index--;
            if (index < 0 || index >= [monthSort.entryArray count])
            {
                if (i - 1 > 0)
                {
                    monthSort = [monthAndYearArray objectAtIndex:i - 1];
                    if ([monthSort.entryArray count] > 0)
                    {
                        result = [monthSort.entryArray lastObject];
                    }
                }
            }
            else
            {
                result = [monthSort.entryArray objectAtIndex:index];
            }
            break;
        }
    }
    
    return result;
}
//
//后一篇日记
- (DocEntity *)nextUrl:(DocEntity *)entry
{
    DocEntity *result = nil;
    NSDate *date = [FilePath timeFromURL:entry.docURL];
    NSString *monthAndYear = [FilePath monthAndYear:date];
    for (int i=0; i<[monthAndYearArray count]; i++)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:i];
        if ([monthSort.monthAndYear isEqualToString:monthAndYear])
        {
            NSInteger index = [monthSort.entryArray indexOfObject:entry];
            index++;
            if (index >= [monthSort.entryArray count])
            {
                if (i + 1 < [monthAndYearArray count])
                {
                    monthSort = [monthAndYearArray objectAtIndex:i + 1];
                    if ([monthSort.entryArray count] > 0)
                    {
                        result = [monthSort.entryArray objectAtIndex:0];
                    }
                }
            }
            else
            {
                result = [monthSort.entryArray objectAtIndex:index];
            }
            break;
        }
    }
    
    return result;
}

- (BOOL)isFirstObj:(DocEntity *)entry
{
    BOOL first = YES;
    if ([monthAndYearArray count] > 0)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:0];
        DocEntity *aEntry = [monthSort.entryArray objectAtIndex:0];
        if (aEntry == entry)
        {
            first = YES;
        }
        else
        {
            first = NO;
        }
    }

    return first;
}

- (BOOL)isLastObj:(DocEntity *)entry
{
    BOOL last = YES;
    if ([monthAndYearArray count] > 0)
    {
        MonthSort *monthSort = [monthAndYearArray lastObject];
        DocEntity *aEntry = [monthSort.entryArray lastObject];
        if (aEntry == entry)
        {
            last = YES;
        }
        else
        {
            last = NO;
        }
    }
    
    return last;
}

- (void)addSortedEntryByMonthAndYear:(NSArray *)array
{    
    // 安日期分类
    for (DiaryInfo *info in array)
    {
        NSDate *date = [FilePath timeFromURL:[NSURL fileURLWithPath:info.url]];
        NSString *monthAndYear = [FilePath monthAndYear:date];
        DocEntity *entry = [[DocEntity alloc] initWithFileURL:[NSURL fileURLWithPath:info.url]
                                                     metadata:nil
                                                        state:UIDocumentStateNormal
                                                      version:nil];
        entry.title = info.title;
        [entry.tags addObjectsFromArray:[info.tags componentsSeparatedByString:@"|"]];
        

        // 开始查找
        int j = 0;
        BOOL exist = NO;
        for (; j<[monthAndYearArray count]; j++)
        {
            MonthSort *monthSort = [monthAndYearArray objectAtIndex:j];
            if ([monthSort.monthAndYear isEqualToString:monthAndYear])
            {
                [monthSort.entryArray addObject:entry];
                exist = YES;
                break;
            }
            
            if (j >= [monthAndYearArray count])
            {
                exist = NO;
            }
        }
        
        // 没找到
        if (!exist)
        {
            MonthSort *monthSort = [[MonthSort alloc] init];
            monthSort.monthAndYear = monthAndYear;
            [monthSort.entryArray addObject:entry];
            [monthAndYearArray addObject:monthSort];
            
            [monthSort release];
        }
    }
}

- (NSInteger)indexForMonthAndYear:(NSString *)str
{
    NSInteger index = -1;
    for (int j = 0; j<[monthAndYearArray count]; j++)
    {
        MonthSort *monthSort = [monthAndYearArray objectAtIndex:j];
        if ([monthSort.monthAndYear isEqualToString:str])
        {
            index = j;
            break;
        }
    }
    
    return index;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
