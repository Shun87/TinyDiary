//
//  TagsViewController.m
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "TagsViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexColor.h"

@implementation DiaryTag
@synthesize tagName, diaryInfoArray;

- (id)init
{
    self = [super init];
    if (self) {
        self.diaryInfoArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [tagName release];
    [diaryInfoArray release];
    [super dealloc];
}
@end

@implementation TagsViewController
@synthesize tagArray, mTableView;

- (void)dealloc
{
    [tagArray release];
    [mTableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Tags", nil);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    self.mTableView.backgroundView = nil;
    self.mTableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadSource:) 
                                                 name:ReloadDiaryInfoUnits object:nil];
}

- (void)reloadSource:(NSNotification *)notification
{
    NSArray *unitArray = (NSArray *)[notification object];
    
    for (int i=0; i<[unitArray count]; i++)
    {
        DiaryInfo *info = [unitArray objectAtIndex:i];
        NSArray *tags = [info.tags componentsSeparatedByString:@"|"];
        for (int j=0; j<[tags count]; j++)
        {
            NSString *subTag = [tags objectAtIndex:j];
            
            if ([tagArray count] == 0)
            {
                DiaryTag *diaryTag = [[DiaryTag alloc] init];
                diaryTag.tagName = subTag;
                [diaryTag.diaryInfoArray addObject:info];
            }
            else
            {
                [tagArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
                    
                    DiaryTag *diaryTag = (DiaryTag *)obj;
                    if ([diaryTag.tagName isEqualToString:subTag])
                    {
                        [diaryTag.diaryInfoArray addObject:info];

                        *stop = YES;
                    }
                    
                    // 没找到
                    if (index == [tagArray count] - 1)
                    {
                        DiaryTag *diaryTag = [[DiaryTag alloc] init];
                        diaryTag.tagName = subTag;
                        [diaryTag.diaryInfoArray addObject:info];
                    }
                }];
            }
        }
    }
    
    [self.mTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    NSString *title = @"";
//    if (section == 0)
//    {
//        title = NSLocalizedString(@"SetiCloudOn", @"");
//    }
//    else if (section == 1)
//    {
//        title = NSLocalizedString(@"PsdOn", @"");
//    }
//    else if (section == 2)
//    {
//        title = NSLocalizedString(@"about", @"");
//    }
//    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tagArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:CellIdentifier] autorelease];
        
        CGRect rect = cell.frame;
        rect.origin.x = cell.contentView.frame.size.width - 40;
        rect.size.width = 40;
        UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 100;
        [cell.contentView addSubview:label];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor colorFromHex:Light_blue];
        
        label.textAlignment = UITextAlignmentCenter;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    DiaryTag *tag = [tagArray objectAtIndex:[indexPath row]];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%d", [tag.diaryInfoArray count]];
    cell.textLabel.text = tag.tagName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
