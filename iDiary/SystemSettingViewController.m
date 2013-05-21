//
//  SystemSettingViewController.m
//  iDiary
//
//  Created by chenshun on 12-11-17.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "CommmonMethods.h"
#import "PasswordViewController.h"
#import "TTSocial.h"
#import "UIColor+HexColor.h"

@interface SystemSettingViewController ()

- (void)saveParameter;
@end

@implementation SystemSettingViewController
@synthesize appArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"Setting"];
    }
    return self;
}

- (void)dealloc
{
    [appArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    mTableView.backgroundView = nil;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveParameter];
}

- (BOOL)passcodeLock
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
}

- (void)saveParameter
{
    NSArray *visiblePaths = [mTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        NSInteger row = [indexPath row];
        UITableViewCell *cell = [mTableView cellForRowAtIndexPath:indexPath];
        if ([indexPath section] == 0)
        {
            if (row == 0)
            {
                UISwitch *switchCtrl = [cell.contentView.subviews objectAtIndex:1];

            }
        }
    }

}

- (IBAction)switchAction:(id)sender
{
    UISwitch *switchCtrl = (UISwitch *)sender;
    if (switchCtrl.tag == 1000)
    {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:switchCtrl.on] forKey:kUseiCloud];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"StorageLocationChanged" object:nil];
    }
    else if (switchCtrl.tag == 1001)
    {
        // 打开／关闭密保
        PasswordViewController *pwdViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController"
                                                                                             bundle:nil];
        pwdViewController.settingPwd = switchCtrl.on;
        pwdViewController.changePwdOn = YES;
        pwdViewController.view.bounds = self.view.bounds;
        [self presentModalViewController:pwdViewController animated:YES];
    }
}

- (UITableViewCell *)initCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"parameter"] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.backgroundColor = [UIColor clearColor];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (section == 0)
    {
        if (row == 0)
        {
            UISwitch *switchCtrl = [[[UISwitch alloc] initWithFrame:CGRectMake(210, 11.0f, 100, 40)] autorelease];
            [cell.contentView addSubview:switchCtrl];
            switchCtrl.tag = 1001 + row;
            cell.imageView.image = [UIImage imageNamed:@"lock"];
        }
        else if (row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"changePsd"];
        }

    }
    else if (section == 1)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Invite By Email", nil);
            cell.imageView.image = [UIImage imageNamed:@"email"];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"Invite By SMS", nil);
            cell.imageView.image = [UIImage imageNamed:@"sms"];
        }
        else if (row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"Send feekback", nil);
            cell.imageView.image = [UIImage imageNamed:@"feedback"];
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
            cell.imageView.image = [UIImage imageNamed:@"like"];
        }
    }
    else if (section == 2)
    {
        if (row == 0)
        {
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(250, 2, 60, 45)] autorelease];
            [cell.contentView addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            label.tag = 1008;
            label.textColor = HEXCOLOR(0x4a5364, 1);
        }
    }

    return cell;
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];

    if (section == 0)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"PsdOn", @"");
            UISwitch *switchCtrl = (UISwitch *)[cell.contentView viewWithTag:1001];
            BOOL pwdLock = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
            switchCtrl.on = pwdLock;
            [switchCtrl addTarget:self
                           action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"Change Passcode", @"");
        }
    }
    else if (section == 2)
    {
        
    }
    else if (section == 3)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Version", @"");
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:1008];
            label.text = @"v1.0";
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"PsdOn", nil);
        
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"Feedback", nil);
    }
    else if (section == 2)
    {
        return NSLocalizedString(@"More Apps", nil);
    }
    else if (section == 3)
    {
        return NSLocalizedString(@"About", nil);
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {        
        BOOL psdLock = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
        if (psdLock)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if (section == 1)
    {
        return 4;
    }
    else if (section == 2)
    {
        return [appArray count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [self initCellWithIndexPath:indexPath];
    }

    [self configCell:cell indexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     if ([indexPath section] == 0 && [indexPath row] == 1)
     {
         PasswordViewController *pwdViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController"
                                                                                              bundle:nil];
         pwdViewController.settingPwd = NO;
         pwdViewController.changePwdOn = NO;
         pwdViewController.changePwd = YES;
         pwdViewController.view.bounds = self.view.bounds;
         [self presentModalViewController:pwdViewController animated:YES];
     }
     else if ([indexPath section] == 1 )
     {
         TTSocial *social = [[TTSocial alloc] init];
         social.viewController = self;
   
         NSInteger row = [indexPath row];

         if (row == 0)
         {
             [social sendEmail:NSLocalizedString(@"FontDesigner", nil) body:NSLocalizedString(@"invite", nil) recipient:nil];
         }
         else if (row == 1)
         {
             [social showSMSPicker:NSLocalizedString(@"invite", nil) phones:nil];
         }
         else if (row == 2)
         {
             [social sendFeedback:NSLocalizedString(@"FontDesigner", nil) body:nil];
         }
     }
}

@end
