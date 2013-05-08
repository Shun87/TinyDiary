//
//  PasswordViewController.h
//  iDiary
//
//  Created by  on 13-2-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoCaretTextField.h"

@interface PasswordViewController : UIViewController
{
    IBOutlet  UILabel *tipLabel;
    
    NSString *password;
    NSString *passwordSecond;
    NSString *inputCharactor;
    
    BOOL firstTimeInput;
    BOOL settingPwd;
    BOOL changePwdOn;
    BOOL changePwd;
    BOOL newPwdReady;
    // 程序刚启动或者激活的时候这个为yes
    BOOL mustInputPwd;
    NoCaretTextField *textField;
    UINavigationItem *titleItem;
    UIBarButtonItem *cancelButton;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
}
@property (nonatomic, assign)BOOL changePwd;
@property (nonatomic, assign)BOOL changePwdOn;
@property (nonatomic, assign)BOOL settingPwd;
@property (nonatomic, assign)BOOL mustInputPwd;
@property (nonatomic, copy)NSString *inputCharactor;
@property (nonatomic, retain)IBOutlet UIImageView *imageView1;
@property (nonatomic, retain)IBOutlet UIImageView *imageView2;
@property (nonatomic, retain)IBOutlet UIImageView *imageView3;
@property (nonatomic, retain)IBOutlet UIImageView *imageView4;
@property (nonatomic, retain)IBOutlet UINavigationItem *titleItem;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain)IBOutlet NoCaretTextField *textField;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *passwordSecond;

- (IBAction)cancelAction:(id)sender;
- (void)reInput;
@end
