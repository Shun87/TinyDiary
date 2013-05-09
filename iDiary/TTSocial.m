//
//  Social.m
//  iDiary
//
//  Created by chenshun on 13-3-18.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "TTSocial.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
#import <Social/Social.h>
#endif

@implementation TTSocial
@synthesize viewController;
- (void)dealloc
{
    [viewController release];
    [super dealloc];
}

- (void)showWarning:(NSString *)text
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [alertView release];
}

- (void)showSina:(NSString *)text
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
    if([NSClassFromString(@"SLComposeViewController") class] != nil)
    {
        if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeSinaWeibo])
        {
            SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeFacebook];
            if (text != nil)
            {
                [slcomposeViewController setInitialText:text];
                // [slcomposeViewController addImage:nil];
                slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result)
                {
                    [viewController dismissModalViewControllerAnimated:YES];
                };
                [viewController presentModalViewController:slcomposeViewController animated:YES];
            }
            
        }
        else
        {
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Facebook账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [loginAlert show];
            [loginAlert release];
        }
    }
    else
    {
        UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Facebook的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [osAlert show];
        [osAlert release];
    }
#endif
}

- (void)showFaceBook:(NSString *)text
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
    if([NSClassFromString(@"SLComposeViewController") class] != nil)
    {
        if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeFacebook];
            if (text != nil)
            {
                [slcomposeViewController setInitialText:text];
               // [slcomposeViewController addImage:nil];
                slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result)
                {
                    [viewController dismissModalViewControllerAnimated:YES];
                };
                [viewController presentModalViewController:slcomposeViewController animated:YES];
            }
            
        }
        else
        {
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Facebook账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [loginAlert show];
            [loginAlert release];
        }
    }
    else
    {
        UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Facebook的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [osAlert show];
        [osAlert release];
    }
#endif
}

- (void)showTwitter:(NSString *)text
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0
    if([NSClassFromString(@"SLComposeViewController") class] != nil){
        if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeTwitter];
            if (text != nil)
            {
                [slcomposeViewController setInitialText:text];
                //[slcomposeViewController addImage:socialControllerService.socialData.shareImage];
                slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
                    [viewController.presentingViewController dismissModalViewControllerAnimated:YES];
                };
                [viewController presentModalViewController:slcomposeViewController animated:YES];
            }
        }
        else
        {
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Twitter账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [loginAlert show];
            [loginAlert release];
        }
    }
    else
    {
        UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Twitter的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [osAlert show];
       [osAlert release];
    }
#endif
}

- (void)sendFeedback
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"TinyNote"];
    NSArray *toRecipients = [NSArray arrayWithObject:@"chenshun87@126.com"];
    [picker setToRecipients:toRecipients];
    [viewController presentModalViewController:picker animated:YES];
	[picker release];
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet:(NSString *)text
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"TinyNote"];
	
	
	// Set up recipients
    //	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    //
    //	[picker setToRecipients:toRecipients];
    //	[picker setCcRecipients:ccRecipients];
    //	[picker setBccRecipients:bccRecipients];
    //
    //	// Attach an image to the email
    //	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    //	NSData *myData = [NSData dataWithContentsOfFile:path];
    //	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	// Fill out the email body text
    if (text != nil)
    {
        [picker setMessageBody:text isHTML:YES];
    }
    
	
	[viewController presentModalViewController:picker animated:YES];
	[picker release];
}

#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
    //	feedbackMsg.hidden = NO;
    //	// Notifies users about errors associated with the interface
    //	switch (result)
    //	{
    //		case MFMailComposeResultCancelled:
    //			feedbackMsg.text = @"Result: Mail sending canceled";
    //			break;
    //		case MFMailComposeResultSaved:
    //			feedbackMsg.text = @"Result: Mail saved";
    //			break;
    //		case MFMailComposeResultSent:
    //			feedbackMsg.text = @"Result: Mail sent";
    //			break;
    //		case MFMailComposeResultFailed:
    //			feedbackMsg.text = @"Result: Mail sending failed";
    //			break;
    //		default:
    //			feedbackMsg.text = @"Result: Mail not sent";
    //			break;
    //	}
	[viewController dismissModalViewControllerAnimated:YES];
}

-(void)showMailPicker:(NSString *)text
{
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil)
    {
        //[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
        {
			[self displayMailComposerSheet:text];
		}
		else
        {
			[self showWarning:@"Device not configured to send mail."];
		}
	}
	else
    {
		[self showWarning: @"Device not configured to send mail."];
	}
}

// Displays an SMS composition interface inside the application.
-(void)displaySMSComposerSheet:(NSString *)text
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.body = text;
	[viewController presentModalViewController:picker animated:YES];
	[picker release];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
    //	switch (result)
    //	{
    //		case MessageComposeResultCancelled:
    //			feedbackMsg.text = @"Result: SMS sending canceled";
    //			break;
    //		case MessageComposeResultSent:
    //			feedbackMsg.text = @"Result: SMS sent";
    //			break;
    //		case MessageComposeResultFailed:
    //			feedbackMsg.text = @"Result: SMS sending failed";
    //			break;
    //		default:
    //			feedbackMsg.text = @"Result: SMS not sent";
    //			break;
    //	}
	[viewController dismissModalViewControllerAnimated:YES];
}


- (void)showSMSPicker:(NSString *)text
{
    //	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    //	So, we must verify the existence of the above class and log an error message for devices
    //		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil)
    {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText])
        {
			[self displaySMSComposerSheet:text];
		}
		else
        {
            
			[self showWarning: @"Device not configured to send SMS."];
            
		}
	}
	else
    {
        
		[self showWarning:@"Device not configured to send SMS."];
	}
}
@end
