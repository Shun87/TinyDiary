//
//  DiaryInfoViewController.m
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "DiaryInfoViewController.h"
#import "UIColor+HexColor.h"
#import "NSDate+FormattedStrings.h"
#import "FilePath.h"
#import "DiaryContentViewController.h"

#define kTextFieldWidth	260.0
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			6.0

#define kTextFieldHeight		30.0

@implementation DiaryInfoViewController
@synthesize entity;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_select"] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = UITextAlignmentCenter;
    lable.text =  NSLocalizedString(@"Diary info", nil);
    lable.font = [UIFont boldSystemFontOfSize:18];
    lable.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = lable;
    [lable release];
    
    caretheight = 44;
     CGRect frame = CGRectMake(50, 8.0, kTextFieldWidth, kTextFieldHeight);
    tokenField = [[TITokenField alloc] initWithFrame:frame];
    tokenField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [tokenField addTarget:self action:@selector(tokenFieldFrameWillChange:) forControlEvents:TITokenFieldControlEventFrameWillChange];
    tokenField.delegate = self;
    for (int i=0; i<[entity.tags count]; i++)
    {
        [tokenField addTokenWithTitle:[entity.tags objectAtIndex:i]];
    }
    
    [tokenField resignFirstResponder];
}

- (IBAction)exitAction:(id)sender
{
    [atextField resignFirstResponder];
    [entity.tags removeAllObjects];
    [entity.tags addObjectsFromArray:tokenField.tokenTitles];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)exitEdit:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    entity.title = textField.text;
    [textField resignFirstResponder];
}

- (IBAction)tokenFieldFrameWillChange:(id)sender
{
    caretheight = CGRectGetMaxY(tokenField.frame);
    if (tokenField.editing)
    {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    caretheight = CGRectGetMaxY(tokenField.frame);
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    if (tokenField.frame.size.height > cell.frame.size.height)
    {
        caretheight = tokenField.frame.size.height;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44.0;
    if ([indexPath section] == 0 && [indexPath row] == 1)
    {
        return caretheight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if ([indexPath section] == 0 && [indexPath row] == 0)
        {
            atextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 190, 45)];
            atextField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            atextField.tag = 1001;
            atextField.textAlignment = UITextAlignmentRight;
            [atextField addTarget:self action:@selector(exitEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            atextField.returnKeyType = UIReturnKeyDone;
            atextField.textColor = [UIColor colorFromHex:Light_blue];
            atextField.font = [UIFont systemFontOfSize:17];
            atextField.backgroundColor = [UIColor clearColor];
        }
        else
        {
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(150, 2, 140, 45)] autorelease];
            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:label];
            label.tag = 1002;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorFromHex:Light_blue];
            label.textAlignment = UITextAlignmentRight;
            label.lineBreakMode = UILineBreakModeCharacterWrap;
            label.font = [UIFont systemFontOfSize:16];
            
            if ([indexPath section] == 0 && [indexPath row] == 1)
            {
                [cell.contentView addSubview:tokenField];

            }
        }
    }
    
    // 将要显示创建日期的section时候，可能会复用第一列。 但是创建日期还没显示出来时tempIndexPath还是第一列，在此时久需要把textfield的text设为空
    // 下次在近来的时候猜会进到[atextField removeFromSuperview];
    UITextField *field = (UITextField *)[cell.contentView viewWithTag:1001];
    if (field != nil)
    {
        field.text = nil;
    }
    UITableViewCell *targetCell = (UITableViewCell *)[[atextField superview] superview];
    if (targetCell == cell && ([indexPath section] != 0 || ([indexPath section] == 0 && [indexPath row] != 0) ) )
    {
        [atextField removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1002];
    if (label != nil)
    {
        label.text = nil;
    }
    
    NSString *text = nil;
    UIImage *image = nil;
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0)
    {
        if (row == 0)
        {
            text = NSLocalizedString(@"Title", nil);
            if ([atextField superview] == nil)
            {
                [cell.contentView addSubview:atextField];
            }
            
            atextField.text = entity.title;
        }
        else
        {
            text = NSLocalizedString(@"Tags", nil);

        }
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            text = NSLocalizedString(@"Modified", nil);
            if (self.entity != nil)
            {
                NSDate *date = nil;
                [self.entity.docURL getResourceValue:&date forKey:NSURLContentModificationDateKey error:nil];
                label.text = [date mediumString];
            }
        }
        else if (row == 1)
        {
            text = NSLocalizedString(@"Created", nil);
            if (self.entity != nil)
            {
                NSDate *date = [FilePath timeFromURL:self.entity.docURL];
               label.text = [date mediumString];
            }
        }
    }
    
    cell.textLabel.text = text;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 0)
    {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dealloc
{
    [tokenField release];
    [atextField release];
    [entity release];
    [super dealloc];
}

@end
