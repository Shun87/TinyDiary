//
//  DiaryListViewController.m
//  iDiary
//
//  Created by chenshun on 12-11-16.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "DiaryListViewController.h"
#import "DiaryContentViewController.h"
#import "CommmonMethods.h"
#import "DiaryDescription.h"
#import "NoteDocument.h"

#import "NSDateAdditions.h"
#import "FilePath.h"
#import "NSDate+FormattedStrings.h"
#import "AppDelegate.h"
#import "PlistDocument.h"

NSString *const TDDocumentsDirectoryName = @"Documents";
NSString *const HTMLExtentsion = @".html";


@interface DiaryListViewController ()
{    
    NoteDocument *document;
    
    NSInteger fileCount;
    
    NSIndexPath *indexPathToDel;
    NSIndexPath *indexPathToShare;
}
@property (nonatomic, retain)NSIndexPath *indexPathToShare;
@property (nonatomic, retain)NSIndexPath *indexPathToDel;
@property (nonatomic, retain)NSURL *iCloudRoot;
@property (nonatomic, retain) NoteDocument *document;
- (void)reloadNotes:(BOOL)needReload;
- (void)loadLocalNotes;
- (int)indexOfEntryWithFileURL:(NSURL *)fileURL;
@end

@implementation DiaryListViewController
@synthesize mTableView;
@synthesize tmpCell, cellNib;
@synthesize deleteButton, addButton, cancelButton, editButton, settingsButton, toolbar;
@synthesize iCloudRoot;
@synthesize document;
@synthesize indexPathToDel, indexPathToShare;

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
    
    [entityArray release];
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
    [super dealloc];
}


#pragma mark View cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mTableView.rowHeight = 80;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    fileCount = 0;
    
    //cell的背景颜色和tableview的一样
    self.mTableView.backgroundColor = HEXCOLOR(0xfdfdfd, 1.0);
    self.view.backgroundColor = HEXCOLOR(0xfdfdfd, 1.0);
    
    self.cellNib = [UINib nibWithNibName:@"AdvancedCell" bundle:nil];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self
               action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    entityArray = [[NSMutableArray alloc] init];
    
    self.mTableView.allowsSelectionDuringEditing = YES;

    mySocial = [[TTSocial alloc] init];
    mySocial.viewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentStateChange:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSourceChanged:)
                                                 name:@"DataSourceChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storageLocationChanged:)
                                                 name:@"StorageLocationChanged" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadSource:) 
                                                 name:ReloadDiaryInfoUnits object:nil];
}

- (void)reloadDataFromArray:(NSArray *)units
{
    [entityArray removeAllObjects];
    
    for (int i=0; i<[units count]; i++)
    {
        DiaryInfo *info = [units objectAtIndex:i];
        NSURL *url = [NSURL fileURLWithPath:info.url];
        [self addOrUpdateEntryWithURL:url metadata:nil state:UIDocumentStateNormal version:nil needReload:NO
                            diaryInfo:info];
    }
    
    [FilePath sortUsingDescending:entityArray];
    [self.mTableView reloadData];
}

- (void)reloadSource:(NSNotification *)notification
{
    [self reloadDataFromArray:(NSArray *)[notification object]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaionBarRed.png"] forBarMetrics:UIBarMetricsDefault];
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
    DocEntity *entity = (DocEntity *)[notification object];
    
    if (entity != nil)
    {
        int index = [self indexOfEntryWithFileURL:entity.docURL];
        if (index >= 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [entityArray insertObject:entity atIndex:0];
            [self.mTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] 
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)updataDataSource:(NSArray *)urlArray
{
    NSURL *iCloudDocURL = [[AppDelegate app].docAccess iCloudDocURL];
    int nCount = [entityArray count];
    [entityArray enumerateObjectsUsingBlock:^(DocEntity * entry, NSUInteger idx, BOOL *stop) 
    {
        if (idx < nCount)
        {
            NSString *fileName = entry.docURL.lastPathComponent;
            entry.docURL = [iCloudDocURL URLByAppendingPathComponent:fileName];
            
            NSLog(@"updataDataSource %@", entry.docURL);
        }
        else
        {
            *stop = YES;
        }
    }];
}

- (void)storageLocationChanged:(NSNotification *)notification
{
    [self reloadNotes:YES];
}

- (void)loadLocalNotes
{
    [entityArray removeAllObjects];
    NSURL *localDocURL = [FilePath localDocumentsDirectoryURL];
    NSURL *infoURL = [localDocURL URLByAppendingPathComponent:DiaryInfoLog];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[infoURL path]])
    {
        PlistDocument *plistDoc = [[PlistDocument alloc] initWithFileURL:infoURL];
        [plistDoc openWithCompletionHandler:^(BOOL success){
        
            if (success)
            {
                NSArray *units = [plistDoc units];
                for (int i=0; i<[units count]; i++)
                {
                    DiaryInfo *info = [units objectAtIndex:i];
                    NSURL *url = [NSURL fileURLWithPath:info.url];
                    [self addOrUpdateEntryWithURL:url metadata:nil state:UIDocumentStateNormal version:nil needReload:NO];
                }
            }
        }];
    }
    
//    NSArray * localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:localDocURL
//                                                             includingPropertiesForKeys:nil 
//                                                                                options:0 
//                                                                                  error:nil];
//    fileCount = [localDocuments count];
//    for (int i=0; i < fileCount; i++)
//    {
//        NSURL * fileURL = [localDocuments objectAtIndex:i];
//
//        
//        if ([[fileURL pathExtension] isEqualToString:kNotePacketExtension])
//        {
//            [self addOrUpdateEntryWithURL:fileURL metadata:nil state:UIDocumentStateNormal version:nil needReload:NO];
//        }
//    }
//    
    [FilePath sortUsingDescending:entityArray];
    [self.mTableView reloadData];
}

- (int)indexOfEntryWithFileURL:(NSURL *)fileURL 
{
    __block int retval = -1;
    [entityArray enumerateObjectsUsingBlock:^(DocEntity * entry, NSUInteger idx, BOOL *stop) {
        if ([entry.docURL isEqual:fileURL]) {
            retval = idx;
            *stop = YES;
        }
    }];
    return retval;    
}

- (void)addOrUpdateEntryWithURL:(NSURL *)fileURL
                       metadata:(Metadata *)metadata
                          state:(UIDocumentState)state
                        version:(NSFileVersion *)version
                     needReload:(BOOL)reload
diaryInfo:(DiaryInfo *)info
{
    DocEntity *entity = nil;
    int index = [self indexOfEntryWithFileURL:fileURL];
    if (index >= 0)
    {
        entity = [entityArray objectAtIndex:index];
        entity.title = info.title;
        [entity.tags addObjectsFromArray:[info.tags componentsSeparatedByString:@"|"]];
        entity.metadata = metadata;
        entity.state = state;
        entity.version = version;
        if (reload)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] 
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else
    {
        entity = [[[DocEntity alloc] initWithFileURL:fileURL
                                                      metadata:metadata
                                                         state:state
                                                       version:version] autorelease];
        entity.title = info.title;
        [entity.tags addObjectsFromArray:[info.tags componentsSeparatedByString:@"|"]];
        [entityArray insertObject:entity atIndex:0];
        if (reload)
        {
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
    NoteDocument *doc = [[NoteDocument alloc] initWithFileURL:entity.docURL];
    [doc openWithCompletionHandler:^(BOOL success){
        if (success)
        {
            // 只有需要去加载的时候才去设置indexPath，默认的indexPath为空
            entity.metadata = doc.metadata;
            entity.state = doc.documentState;
            entity.version = [NSFileVersion currentVersionOfItemAtURL:entity.docURL];
            entity.indexPath = indexPath;
            [doc closeWithCompletionHandler:^(BOOL closeSuccess){
                
                // Check status
                if (!closeSuccess) {
                    NSLog(@"Failed to close %@", entity.docURL);
                    // Continue anyway...
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                 
                    [self metadataLoadSuccess:entity];
                    [doc release];
                    
                });
            }];
        }
        else
        {
            NSLog(@"Failed to openWithCompletionHandler %@", entity.docURL);
        }
    }];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([entityArray count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            DocEntity *entity = [entityArray objectAtIndex:indexPath.row];
            
            if (!entity.metadata) // avoid the app icon download if the app already has an icon
            {
                [self startLoadDoc:entity forIndexPath:indexPath];
            }
        }
    }
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

- (void)deleteFile:(NSURL *)url
{
    __block int index = -1;
    [entityArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
    
        DocEntity *entiy = (DocEntity *)obj;
        if ([entiy.docURL.path isEqualToString:url.path])
        {
            index = idx;
            *stop = YES;
        }
    }];

    if (index < 0 || index >= [entityArray count])
    {
        return;
    }
    
    DocEntity *entity = [entityArray objectAtIndex:index];
    if (entity != nil && [AppDelegate app].docAccess != nil)
    {
        [[AppDelegate app].docAccess deleteFile:entity.docURL];
    }
    [entityArray removeObject:entity];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
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
//    // @"What would you like to do with the documents currently on this iPad?" 
//    // Cancel: @"Continue Using iCloud" 
//    // Other 1: @"Keep a Local Copy"
//    // Other 2: @"Keep on iCloud Only"
//    else if (alertView.tag == 2) {
//        
//        if (buttonIndex == alertView.cancelButtonIndex) {
//            
//            [self setiCloudOn:YES];
//            [self refresh];
//            
//        } else if (buttonIndex == alertView.firstOtherButtonIndex) {
//            
//            if (_iCloudURLsReady) {
//                [self iCloudToLocalImpl];
//            } else {
//                _copyiCloudToLocal = YES;
//            }
//            
//        } else if (buttonIndex == alertView.firstOtherButtonIndex + 1) {            
//            
//            // Do nothing
//            
//        } 
//        
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [entityArray count];
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
    
    if ([entityArray count] > 0)
    {
        DocEntity *entity = [entityArray objectAtIndex:[indexPath row]];
        [self fillCell:cell withEntity:entity];

        if (entity.metadata == nil)
        {
            // 如果为空则去加载填充
            [self startLoadDoc:entity forIndexPath:indexPath];
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
        DocEntity *entity = [entityArray objectAtIndex:[indexPath row]];
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

// 前一篇
- (DocEntity *)preUrl:(DocEntity *)entry
{
    NSInteger index = [entityArray indexOfObject:entry];
    index--;
    if (index < 0 || index >= [entityArray count])
    {
        return nil;
    }
    
    return [entityArray objectAtIndex:index];
}

//后一篇日记
- (DocEntity *)nextUrl:(DocEntity *)entry
{
    NSInteger index = [entityArray indexOfObject:entry];
    index++;
    if (index >= [entityArray count])
    {
        return nil;
    }
    return [entityArray objectAtIndex:index];
}

- (NSInteger)indexForEntry:(DocEntity *)entry
{
    return [entityArray indexOfObject:entry];
}

- (NSInteger)totalCount
{
    return [entityArray count];
}
@end
