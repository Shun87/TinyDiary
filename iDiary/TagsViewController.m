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
#import "DiaryListViewController.h"
#import "TDBadgedCell.h"
#import "DiaryListViewController.h"

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
        self.tabBarItem.image = [UIImage imageNamed:@"tag"];
        tagArray = [[NSMutableArray alloc] init];
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
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
    self.title = NSLocalizedString(@"Tags", nil);
}

- (void)reloadSource
{
    [tagArray removeAllObjects];
    
    NSArray *unitArray = [AppDelegate app].diaryInfoArray;
    
    for (int i=0; i<[unitArray count]; i++)
    {
        DiaryInfo *info = [unitArray objectAtIndex:i];
        NSArray *tags = [info.tags componentsSeparatedByString:@"|"];
        for (int j=0; j<[tags count]; j++)
        {
            NSString *subTag = [tags objectAtIndex:j];
            if ([subTag length] == 0)
            {
                break;
            }
            
            if ([tagArray count] == 0)
            {
                DiaryTag *diaryTag = [[DiaryTag alloc] init];
                diaryTag.tagName = subTag;
                [diaryTag.diaryInfoArray addObject:info];
                [tagArray addObject:diaryTag];
                [diaryTag release];
            }
            else
            {
                int k = 0;
                for (; k<[tagArray count]; k++)
                {
                    DiaryTag *diaryTag = [tagArray objectAtIndex:k];
                    if ([diaryTag.tagName isEqualToString:subTag])
                    {
                        [diaryTag.diaryInfoArray addObject:info];
                        break;
                    }
                }
                
                // 到最后一个还没找到
                if (k >= [tagArray count])
                {
                    DiaryTag *diaryTag = [[DiaryTag alloc] init];
                    diaryTag.tagName = subTag;
                    [diaryTag.diaryInfoArray addObject:info];
                    [tagArray addObject:diaryTag];
                    [diaryTag release];
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadSource];
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
    TDBadgedCell *cell = (TDBadgedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    cell.textLabel.backgroundColor = [UIColor clearColor];
    DiaryTag *tag = [tagArray objectAtIndex:[indexPath row]];

    cell.badgeString = [NSString stringWithFormat:@"%d", [tag.diaryInfoArray count]];
    cell.textLabel.text = tag.tagName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DiaryTag *tag = [tagArray objectAtIndex:[indexPath row]];
    
    DiaryListViewController *diarylistController = [[DiaryListViewController alloc] initWithNibName:@"DiaryListViewController"
                                                                                             bundle:nil];
    diarylistController.tagName = tag.tagName;
    [self.navigationController pushViewController:diarylistController animated:YES];
    [diarylistController reloadDataFromArray:tag.diaryInfoArray];
    [diarylistController release];
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
