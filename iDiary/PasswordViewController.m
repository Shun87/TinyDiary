//
//  PasswordViewController.m
//  iDiary
//
//  Created by  on 13-2-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "PasswordViewController.h"
#import "CommmonMethods.h"

@implementation PasswordViewController
@synthesize password;
@synthesize passwordSecond;
@synthesize textField, titleItem, cancelButton;
@synthesize imageView1, imageView2, imageView3, imageView4;
@synthesize inputCharactor;
@synthesize settingPwd;
@synthesize mustInputPwd;
@synthesize changePwdOn, changePwd;

- (void)dealloc
{
    [textField release];
    [passwordSecond release];
    [password release];
    [titleItem release];
    [cancelButton release];
    [imageView1 release];
    [imageView2 release];
    [imageView3 release];
    [imageView4 release];
    [inputCharactor release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mustInputPwd = NO;
        settingPwd = NO;
        newPwdReady = NO;
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
    
    UIView *subView = [self.view viewWithTag:1020];
    [subView becomeFirstResponder];
    
    tipLabel.textColor = HEXCOLOR(0x4a5364, 1);
    tipLabel.text = NSLocalizedString(@"EnterPasscode", nil);
    tipLabel.font = [UIFont boldSystemFontOfSize:17];
    
    self.view.backgroundColor = HEXCOLOR(0xd2dbec, 1);
    self.textField.borderStyle = UITextBorderStyleNone;
    //[self.textField becomeFirstResponder];
    self.titleItem.title = NSLocalizedString(@"PsdOn", nil);
    self.cancelButton.title = NSLocalizedString(@"Cancel", nil);
    
    firstTimeInput = YES;
    
    [self reInput];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive:)
                                                 name:@"appillssResignActive"
                                               object:nil];
    textField.hidden = YES;
    
    if (self.mustInputPwd)
    {
        self.titleItem.rightBarButtonItem = nil;
    }
    
    if (self.changePwd)
    {
        tipLabel.text = NSLocalizedString(@"EnterOldPwd", nil);
    }
}

- (void)resignActive:(NSNotification *)noticefication
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)responderView:(UIView *)view
{
    [view becomeFirstResponder];
}

- (BOOL)psdRight
{
    return YES;
}

- (void)inputCorrect
{
    [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kPsdOn];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kPsdWasOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)reInput
{
    //
    textField.text = nil;
    self.inputCharactor = nil;

    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    self.imageView3.hidden = YES;
    self.imageView4.hidden = YES;
}

- (void)inputAgain
{
    [self reInput];
    tipLabel.textColor = HEXCOLOR(0x4a5364, 1);
    tipLabel.text = NSLocalizedString(@"ReEnterPasscode", nil);
}

- (void)enterNewPwd
{
    
}

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string length] <= 0)
    {
        // 按了删除键
        if ([self.inputCharactor length] > 0)
        {
            //又数据可以删
            int index = [self.inputCharactor length] - 1;
            if (index > 0)
            {
                 self.inputCharactor = [self.inputCharactor substringToIndex:index];
            }
            else
            {
                self.inputCharactor = nil;
            }
        }
    }
    
    if (self.inputCharactor == nil)
    {
        self.inputCharactor = string;
    }
    else
    {
        self.inputCharactor = [self.inputCharactor stringByAppendingString:string];
    }
    
    
    NSInteger length = [self.inputCharactor length];
    if (length <=0 )
    {
        self.imageView1.hidden = YES;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
    }
    if (length == 1)
    {
        self.imageView1.hidden = NO;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
    }
    else if (length == 2)
    {
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = YES;
        self.imageView4.hidden = YES;
    }
    else if (length == 3)
    {
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = YES;
    }
    else if (length == 4)
    {
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = NO;
        self.imageView4.hidden = NO;
        
        if (firstTimeInput)
        {
            self.password = self.inputCharactor;
            self.inputCharactor = nil;
            
            // 如果是设置密码
            if (settingPwd)
            {
                firstTimeInput = NO;
                [self performSelector:@selector(inputAgain) withObject:nil
                           afterDelay:0.1];
            }
            else
            {
                // 验证密码
                NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
                if (![pwd isEqualToString:self.password])
                {
                    // 验证错误，重新输入
                    firstTimeInput = YES;
                    tipLabel.text = NSLocalizedString(@"PsdNotCorrect", nil);
                    tipLabel.textColor = HEXCOLOR(0xff7471, 1);
                    [self performSelector:@selector(reInput) withObject:nil
                               afterDelay:0.1];
                }
                else
                {
                    //如果验证通过
                    if (mustInputPwd)
                    {
                        //如果是程序启动或者激活进入的密码验证需要去remove
                        [self.view removeFromSuperview];
                    }
                    else
                    {
                        // 从setting页面进来的，可能是修改密码，有可能是开关密保
                        if (changePwdOn)
                        {
                            BOOL pwdLock = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
                            pwdLock = !pwdLock;
                            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kPassword];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:pwdLock]
                                                                      forKey:kPsdOn];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self dismissModalViewControllerAnimated:YES];
                        }
                        else if (changePwd)
                        {
                            self.inputCharactor = nil;
                            tipLabel.text = NSLocalizedString(@"EnterNewPwd", nil);
                            tipLabel.textColor = HEXCOLOR(0x4a5364, 1);
                            
                            // 开始设置密码
                            settingPwd = YES;
                            firstTimeInput = YES;
                            [self performSelector:@selector(reInput) withObject:nil
                                       afterDelay:0.1];
                        }
                    }
                }
            }
        }
        else
        {
            // 肯定是设置密码
            self.passwordSecond = self.inputCharactor;
            if (![self.passwordSecond isEqualToString:self.password])
            {
                // 两次设置的密码不一样，重新设置
                firstTimeInput = YES;
                tipLabel.text = NSLocalizedString(@"PsdNotSame", nil);
                tipLabel.textColor = HEXCOLOR(0xff7471, 1);
                [self performSelector:@selector(reInput) withObject:nil
                           afterDelay:0.1];
            }
            else
            {
                [self inputCorrect];
            }
        }
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
