//
//  CalendarViewController.m
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "CalendarViewController.h"
#import "DiaryListViewController.h"
#import "AppDelegate.h"
#import "FilePath.h"
#import "NSDateAdditions.h"

@implementation CalendarViewController

- (void)dealloc
{
    [kalViewController release];
    [dayDiaryArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calendar", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"calendar"];
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
    kalViewController = [[KalViewController alloc] init];
    kalViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin 
    | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:kalViewController.view];
    
    dayDiaryArray = [[NSMutableArray alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"today.png"] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"today", nil) forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    [button addTarget:self
               action:@selector(today:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectkalDate:) name:@"SelectDate" object:nil];
}

- (void)selectkalDate:(NSNotification *)notification
{
    NSDate *date = (NSDate *)[notification object];
    NSString *day = [FilePath dayString:date];
    NSMutableArray *diaryArray = [NSMutableArray array];
    for (int i=0; i<[[AppDelegate app].diaryInfoArray count]; i++)
    {
        DiaryInfo *info = [[AppDelegate app].diaryInfoArray objectAtIndex:i];
        NSDate *infoDate = [FilePath timeFromURL:[NSURL fileURLWithPath:info.url]];
        NSString *dayStr = [FilePath dayString:infoDate];
        if ([day isEqualToString:dayStr])
        {
            [diaryArray addObject:info];
        }
    }
    DiaryListViewController *diaryListController = [[DiaryListViewController alloc] initWithNibName:@"DiaryListViewController"
                                                                                             bundle:nil];
    diaryListController.specDate = date;

    [self.navigationController pushViewController:diaryListController animated:YES];
    [diaryListController reloadDataFromArray:diaryArray];
    [diaryListController release];
}

- (IBAction)today:(id)sender
{
    [kalViewController showAndSelectDate:[NSDate date]];
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

- (void)didSelectDate:(KalDate *)date
{
    
}
@end
