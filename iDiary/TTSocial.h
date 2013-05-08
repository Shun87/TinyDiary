//
//  Social.h
//  iDiary
//
//  Created by chenshun on 13-3-18.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TTSocial : NSObject<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    UIViewController *viewController;
}
@property (nonatomic, retain)UIViewController *viewController;

-(void)showMailPicker:(NSString *)text  to:(NSArray *)toRecipients
                   cc:(NSArray *)ccRecipients bcc:(NSArray *)bccRecipients images:(NSArray *)images;

- (void)sendFeedback:(NSString *)title body:(NSString *)body;
- (void)sendEmail:(NSString *)title body:(NSString *)body recipient:(NSString *)address;

- (void)showSMSPicker:(NSString *)text phones:(NSArray *)recipientArray;

- (void)showFaceBook:(NSString *)text;
- (void)showTwitter:(NSString *)text;
- (void)showSina:(NSString *)text;
@end
