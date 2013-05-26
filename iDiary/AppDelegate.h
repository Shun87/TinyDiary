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
#import "MBProgressHUD.h"
#import "DocumentsAccess.h"
#import "PlistDocument.h"
#import "UIColor+HexColor.h"
@class PasswordViewController;

#define ReloadDiaryInfoUnits @"ReloadDiaryInfoUnits"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, 
MBProgressHUDDelegate, DocumentsAccessDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;
    
    UINavigationController *navigationController;
    PasswordViewController *passwordViewController;
   // GADBannerView *banner;
    
    MBProgressHUD *hud;
    
    NSMutableArray *diaryInfoArray;
    DocumentsAccess *docAccess;
}
@property (nonatomic, readonly)DocumentsAccess *docAccess;
@property (nonatomic, retain)NSMutableArray *diaryInfoArray;
@property (nonatomic, retain)MBProgressHUD *hud;
//@property (nonatomic, retain) GADBannerView *banner;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic)PasswordViewController *passwordViewController;
+ (AppDelegate *)app;

@end
