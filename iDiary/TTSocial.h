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

-(void)showMailPicker:(NSString *)text;
- (void)sendFeedback;
- (void)showSMSPicker:(NSString *)text;
- (void)showFaceBook:(NSString *)text;
- (void)showTwitter:(NSString *)text;
- (void)showSina:(NSString *)text;
@end
