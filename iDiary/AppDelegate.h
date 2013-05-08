//
//  AppDelegate.h
//  iDiary
//
//  Created by chenshun on 12-11-13.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
//#import "GADBannerView.h"

@class PasswordViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;
    
    UINavigationController *navigationController;
    PasswordViewController *passwordViewController;
   // GADBannerView *banner;
}

//@property (nonatomic, retain) GADBannerView *banner;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic)PasswordViewController *passwordViewController;
+ (AppDelegate *)app;

@end
