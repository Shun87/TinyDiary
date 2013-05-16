//
//  AppDelegate.m
//  iDiary
//
//  Created by chenshun on 12-11-13.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "AppDelegate.h"

#import "SystemSettingViewController.h"
#import "DiaryListViewController.h"
#import "CommmonMethods.h"
#import "PasswordViewController.h"
#import "NSDate+FormattedStrings.h"
#import "AboutViewController.h"

#import "CalendarViewController.h"
#import "TagsViewController.h"


@implementation AppDelegate
@synthesize window ;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize passwordViewController;
@synthesize hud, diaryInfoArray;
//@synthesize banner;

- (void)dealloc
{
    [hud release];
    [window release];
    [tabBarController release];
    [navigationController release];
    [passwordViewController release];
    [diaryInfoArray release];
    [super dealloc];
}

- (void)showPsdView
{
    PasswordViewController *psdViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController"
                                                                                         bundle:nil];
    self.passwordViewController = psdViewController;
    [psdViewController release];
    
    self.passwordViewController.mustInputPwd = YES;
    
    [self.window addSubview:self.passwordViewController.view];
    CGRect rect = self.passwordViewController.view.frame;
    rect.origin.y = 20;
    self.passwordViewController.view.frame = rect;
}

- (void)hidePsdView
{
    if (passwordViewController != nil)
    {
        if ([passwordViewController.view superview] != nil)
        {
            [passwordViewController.view removeFromSuperview];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    diaryInfoArray = [[NSMutableArray alloc] init];
    
    UIViewController *viewController = [[[DiaryListViewController alloc] initWithNibName:@"DiaryListViewController" bundle:nil] autorelease];
    UINavigationController *aNavigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    self.navigationController = aNavigationController;
    
    UIViewController *settingController = [[[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil] autorelease];
    UINavigationController *nav2 = [[[UINavigationController alloc] initWithRootViewController:settingController] autorelease];

    UIViewController *calendarController = [[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil] autorelease];
    UINavigationController *nav3 = [[[UINavigationController alloc] initWithRootViewController:calendarController] autorelease];
    
    UIViewController *tagController = [[[TagsViewController alloc] initWithNibName:@"TagsViewController" bundle:nil] autorelease];
    UINavigationController *nav4 = [[[UINavigationController alloc] initWithRootViewController:tagController] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:aNavigationController, nav3, nav4, nav2, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:HEXCOLOR(0xb33e2d, 1)];
    self.window.rootViewController = self.tabBarController;
    
    // Initialize the banner at the bottom of the screen.
//    CGPoint origin = CGPointMake(0.0,
//                                 self.window.frame.size.height -
//                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
//    // Use predefined GADAdSize constants to define the GADBannerView.
//    self.banner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
//                                                    origin:origin]
//                     autorelease];
//    
//    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
//    // before compiling.
//    self.banner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    self.banner.adUnitID = @"a15176d8687d52a";
//    self.banner.delegate = self;
//    [self.banner setRootViewController:self.navigationController];
//    self.banner.center =
//    CGPointMake(self.window.center.x, self.banner.center.y);
//    [self.banner loadRequest:[self createRequest]];
    
    [self.window makeKeyAndVisible];
    
    [self hidePsdView];
    BOOL pwdLock = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
    if (pwdLock)
    {
        [self showPsdView];
    }
    
// icloud的一些操作
    docAccess = [[DocumentsAccess alloc] initWithDelegate:self];
    hud = [[MBProgressHUD alloc] initWithView:self.window];


    return YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)ahud
{
	// Remove HUD from screen when the HUD was hidded
	[ahud removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // 程序切换到后台，这里总是先进，然后再触发注册UIApplicationWillResignActiveNotification消息的函数。
    // 密保需要先关闭再切后台，所以这里加了一个消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appillssResignActive"
                                                        object:nil];
    [self hidePsdView];
    
    BOOL pwdLock = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
    if (pwdLock)
    {
        [self showPsdView];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self reloadNotes];
}

- (void)reloadNotes
{
    [self.window addSubview:hud];
	hud.labelText = @"Loading";
	[hud show:YES];
    
    [diaryInfoArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadDiaryInfoUnits
                                                        object:self.diaryInfoArray];

    [docAccess initializeiDocAccess:^(BOOL available){
        
        if (available)
        {
            // 询问是否把数据存入ICLOUD, 并且是在没有提示过的情况下,如果提示过了下次就不再提示
            if (![docAccess iCloudOn] && ![docAccess iCloudPrompted])
            {
                // 设置为提示过
                [docAccess setiCloudPrompted:YES];
                //                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"iCloud is Available" 
                //                                                                     message:@"Automatically store your documents in the cloud to keep them up-to-date across all your devices and the web." 
                //                                                                    delegate:self 
                //                                                           cancelButtonTitle:@"Later" 
                //                                                           otherButtonTitles:@"Use iCloud", nil];
                //                alertView.tag = 1;
                //                [alertView show];
                [docAccess setiCloudOn:YES];
                [self reloadNotes];
            }
            
            // move iCloud docs to local
            if (![docAccess iCloudOn] && [docAccess iCloudWasOn])
            {
//                [docAccess iCloudToLocal:kNotePacketExtension completion:^(NSArray *fileArray){
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [self loadLocalNotes];
//                    });
//                }];
            }
            
            // move local docs to iCloud
            if ([docAccess iCloudOn] && ![docAccess iCloudWasOn])
            {
//                [docAccess localToiCloud:kNotePacketExtension completion:^(NSArray *fileArray){
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [self updataDataSource:fileArray];
//                    });
//                }]; 
                
            }
            
            if ([docAccess iCloudOn])
            {
                NSString * filePattern = [NSString stringWithFormat:DiaryInfoLog];
                [docAccess startQueryForPattern:filePattern];
            }
            
            // No matter what, refresh with current value of iCloudOn
            [docAccess setiCloudWasOn:[docAccess iCloudOn]];
        }
        else
        {
            // If iCloud isn't available, set promoted to no (so we can ask them next time it becomes available)
            [docAccess setiCloudPrompted:NO];
            
            // If iCloud was toggled on previously, warn user that the docs will be loaded locally
            if ([docAccess iCloudWasOn]) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"You're Not Using iCloud" message:@"Your documents were removed from this iPhone but remain stored in iCloud." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
            
            // No matter what, iCloud isn't available so switch it to off.
            [docAccess setiCloudOn:NO]; 
            [docAccess setiCloudWasOn:NO];
        }
        
        // 查询本地
        if (![docAccess iCloudOn])
        {
            [self loadLocalNotes];
        }
    }];
}

#pragma mark - iCloudAvailableDelegate

- (void)queryDidFinished:(NSArray *)array
{
    if (![docAccess iCloudOn])
    {
        return;
    }
    
    [diaryInfoArray removeAllObjects];
    
    for (NSMetadataItem *item in array)
    {
        NSURL *fileURL = [item valueForAttribute:NSMetadataItemURLKey];
        NSNumber *hide = nil;
        
        // Don't include hidden files
        [fileURL getResourceValue:&hide forKey:NSURLIsHiddenKey error:nil];
        if (hide && ![hide boolValue] && [[fileURL lastPathComponent] isEqualToString:DiaryInfoLog])
        {
            PlistDocument *plistDoc = [[PlistDocument alloc] initWithFileURL:fileURL];
            [plistDoc openWithCompletionHandler:^(BOOL success){
                
                if (success)
                {
                    [self.diaryInfoArray addObjectsFromArray:[plistDoc units]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadDiaryInfoUnits
                                                                        object:self.diaryInfoArray];
                }
                else
                {
                    [self.hud hide:YES];
                }
                
                [plistDoc release];
            }];
        }
    }
}

+ (AppDelegate *)app
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//#pragma mark GADRequest generation
//
//// Here we're creating a simple GADRequest and whitelisting the application
//// for test ads. You should request test ads during development to avoid
//// generating invalid impressions and clicks.
//- (GADRequest *)createRequest {
//    GADRequest *request = [GADRequest request];
//    
//#if DEBUG
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
//#endif
//    return request;
//}
//
//#pragma mark GADBannerViewDelegate impl
//
//// We've received an ad successfully.
//- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//    NSLog(@"Received ad successfully");
//}
//
//- (void)adView:(GADBannerView *)view
//didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
//}
@end
