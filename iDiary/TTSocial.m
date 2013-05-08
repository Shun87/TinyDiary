//
//  Social.m
//  iDiary
//
//  Created by chenshun on 13-3-18.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "TTSocial.h"
#import <Social/Social.h>

@implementation TTSocial
@synthesize viewController;
- (void)dealloc
{
    [viewController release];
    [super dealloc];
}


- (void)showSina:(NSString *)text
{
    if([NSClassFromString(@"SLComposeViewController") class] != nil)
    {
        if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeSinaWeibo])
        {
            SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeFacebook];
            if (text != nil)
            {
                [slcomposeViewController setInitialText:text];
                slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result)
                {
                    [viewController dismissModalViewControllerAnimated:YES];
                };
                [viewController presentModalViewController:slcomposeViewController animated:YES];
            }
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No SinaWeibo Accounts"
                                      message:@"There are no Sina accounts configured.You can add or creat a SinaWeibo account in Settings"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:@"Cancel", nil];
            [alertView show];
        }
    }
}

- (void)showFaceBook:(NSString *)text
{
    
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
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No Facebook Accounts"
                                      message:@"There are no Facebook accounts configured.You can add or creat a Facebook account in Settings"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:@"Cancel", nil];
            [alertView show];
        }
    }
}

- (void)showTwitter:(NSString *)text
{
    
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
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No Facebook Accounts"
                                      message:@"There are no Twitter accounts configured.You can add or creat a Twitter account in Settings"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:@"Cancel", nil];
            [alertView show];
        }
    }
}

- (void)showWarning:(NSString *)text
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
    [alertView show];
    [alertView release];
}

- (void)sendEmail:(NSString *)title body:(NSString *)body recipient:(NSString *)address
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            if ([title length] > 0)
            {
                [picker setSubject:title];
            }
            
            if ([address length] > 0)
            {
                NSArray *toRecipients = [NSArray arrayWithObject:address];
                [picker setToRecipients:toRecipients];
            }
            
            
            if ([body length] > 0)
            {
                [picker setMessageBody:body isHTML:NO];
            }
            
            [viewController presentModalViewController:picker animated:YES];
            [picker release];
		}
		else
        {
			[self showWarning:NSLocalizedString(@"No mail account", nil)];
		}
	}
	else
    {
		[self showWarning: @"Device not configured to send mail."];
	}
}

- (void)sendFeedback:(NSString *)title body:(NSString *)body
{
    [self sendEmail:title body:body recipient:@"chenshun87@126.com"];
}


#pragma mark -
#pragma mark Workaround
// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet:(NSString *)text  to:(NSArray *)toRecipients cc:(NSArray *)ccRecipients bcc:(NSArray *)bccRecipients images:(NSArray *)images
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    if ([toRecipients count] > 0)
    {
        [picker setToRecipients:toRecipients];
    }
	
    if ([ccRecipients count] > 0)
    {
        [picker setCcRecipients:ccRecipients];
    }
	
    if ([bccRecipients count] > 0)
    {
        [picker setBccRecipients:bccRecipients];
    }
	
    //
    //	// Attach an image to the email
    for (int i=0; i<[images count]; i++)
    {
        UIImage *img = [images objectAtIndex:i];
        NSData *myData = UIImagePNGRepresentation(img);
        NSString *imageName = [NSString stringWithFormat:@"%d", [[NSDate date] timeIntervalSince1970]];
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:imageName];
    }
    
	// Fill out the email body text
    if (text != nil)
    {
        [picker setMessageBody:text isHTML:NO];
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
                   to:(NSArray *)toRecipients cc:(NSArray *)ccRecipients bcc:(NSArray *)bccRecipients images:(NSArray *)images
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
			[self displayMailComposerSheet:text to:toRecipients cc:ccRecipients bcc:bccRecipients images:images];
		}
		else
        {
			[self showWarning:NSLocalizedString(@"No mail account", nil)];
		}
	}
	else
    {
		[self showWarning: @"Device not configured to send mail."];
	}
}

// Displays an SMS composition interface inside the application.
-(void)displaySMSComposerSheet:(NSString *)text phones:(NSArray *)recipientArray
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    if ([recipientArray count] > 0)
    {
        picker.recipients = recipientArray;
    }
    
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


- (void)showSMSPicker:(NSString *)text phones:(NSArray *)recipientArray
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
			[self displaySMSComposerSheet:text phones:recipientArray];
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
