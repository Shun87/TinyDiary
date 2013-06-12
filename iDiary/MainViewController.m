//
//  MainViewController.m
//  TinyDiaryPro
//
//  Created by chenshun on 13-6-10.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "MainViewController.h"
#import "TDBadgedCell.h"
#import "AppDelegate.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize mTableView;

- (void)dealloc
{
    [mTableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBk.png"]];
    self.mTableView.rowHeight = 55;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundView = nil;
    mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TDBadgedCell *cell = (TDBadgedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier] autorelease];
//        UIView *subView = [[[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1)] autorelease];
//        [cell.contentView addSubview:subView];
//        subView.backgroundColor = [UIColor colorFromHex:0xe0e0e0];
//        subView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    if (row == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Timeline", nil);
    }
    else if (row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"Calendar", nil);
    }
    else if (row == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"Tags", nil);
    }
    else if (row == 3)
    {
        cell.textLabel.text = NSLocalizedString(@"Settings", nil);
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

@end
