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

}

- (IBAction)exitAction:(id)sender
{
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
    [textField resignFirstResponder];
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
            UITextField *textFeild = [[[UITextField alloc] initWithFrame:CGRectMake(100, 12, 180, 45)] autorelease];
            textFeild.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:textFeild];
            textFeild.tag = 1001;
            textFeild.textAlignment = UITextAlignmentRight;
            [textFeild addTarget:self action:@selector(exitEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            textFeild.returnKeyType = UIReturnKeyDone;
            textFeild.textColor = [UIColor colorFromHex:Light_blue];
            textFeild.font = [UIFont systemFontOfSize:16];
        }
        else
        {
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(150, 2, 130, 45)] autorelease];
            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:label];
            label.tag = 1002;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorFromHex:Light_blue];
            label.textAlignment = UITextAlignmentRight;
            label.lineBreakMode = UILineBreakModeCharacterWrap;
            label.font = [UIFont systemFontOfSize:16];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *textFeild = (UITextField *)[cell.contentView viewWithTag:1001];
    if (textFeild != nil)
    {
        textFeild.text = nil;
    }
    
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
            textFeild.text = @"标题";
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc
{
    [super dealloc];
}

@end
