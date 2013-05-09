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

@implementation AppDelegate
@synthesize window ;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize passwordViewController;
//@synthesize banner;

- (void)dealloc
{
    [window release];
    [tabBarController release];
    [navigationController release];
    [passwordViewController release];
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
    
    UIViewController *viewController = [[[DiaryListViewController alloc] initWithNibName:@"DiaryListViewController" bundle:nil] autorelease];
    UINavigationController *aNavigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    self.navigationController = aNavigationController;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
   
    [[UINavigationBar appearance] setTintColor:HEXCOLOR(0x282626, 1.0)];
     self.window.rootViewController = self.navigationController;
    
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
    
    [[UINavigationBar appearance] setTintColor:HEXCOLOR(0xb33e2d, 1)];
    
    NSString*dateTime=@"2013-01-24 18:30 PM";
    //dateTime=@"2013-01-24 06:30 AM";
    NSDateFormatter *dtFormatter=[[NSDateFormatter alloc]init];
    [dtFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    NSDate *AptDate=[NSDate date];
    [dtFormatter setDateFormat:@"MMM dd,yyyy hh:mm a"];
    NSString *strDate=[dtFormatter stringFromDate:AptDate];
    
    NSLog(@"===> %@",AptDate);
    NSLog(@"===> %@",strDate);
    
    return YES;
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

+ (AppDelegate *)app
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
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

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
