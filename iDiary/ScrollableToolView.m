//
//  ScrollableScrollableToolView.m
//  iDiary
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "ScrollableToolView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CommmonMethods.h"
@implementation ScrollableToolView
@synthesize scrollView;
@synthesize delegate, editView;

- (void)dealloc
{
    [editView release];
    [textArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame imageNames:(NSArray *)names titleArray:(NSArray *)array delegate:(id)aDelegate
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
     
        const int originY = 30;
        const int scrollWidth = 273;
        const int scrollHeight = 39;
        self.delegate = aDelegate;
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, originY, self.bounds.size.width, scrollHeight)] autorelease];
        imageView.image = [UIImage imageNamed:@"toolbar.png"];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        textArray = [[NSMutableArray alloc] initWithArray:array];
        
        
        self.scrollView = [[CancelTouchesScrollView alloc] initWithFrame:CGRectMake(0, originY, scrollWidth, scrollHeight)];
        [self addSubview:scrollView];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleWidth;
        UIImageView *imageView2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HideBK.png"]] autorelease];
        imageView2.frame = CGRectMake(scrollWidth, originY, self.bounds.size.width - scrollWidth, scrollHeight);
        [self addSubview:imageView2];
        
        float currentWidth = 5;
        for (int i = 0; i < 14; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.tag = i + 1000;
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
            
            UIImage *buttonImage = [UIImage imageNamed:[names objectAtIndex:i]];
            [button setImage:buttonImage forState:UIControlStateNormal];
            [button setImage:buttonImage forState:UIControlStateHighlighted];
            
            CGRect rect = CGRectMake(0, 1, 47, scrollHeight);
            rect.origin.x = currentWidth;
            button.frame = rect;

            currentWidth += 40 + 5;
            
            if (i == 13)
            {
                rect = imageView.bounds;
                rect.origin.x = scrollWidth + 4;
                rect.size.width = 41;
                button.frame = rect;


                [imageView addSubview:button];
                [button setImage:[UIImage imageNamed:@"hideKey.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"hideKey.png"] forState:UIControlStateHighlighted];
            }
            else
            {
                [scrollView addSubview:button];
            }
        }

        scrollView.contentSize = CGSizeMake(32*20, scrollHeight);
        _maxContentOffset = 32*20 - 320;
        _minContentOffset = 0.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (IBAction)touchDown:(id)sender
{
    AudioServicesPlaySystemSound(1104);
}

- (IBAction)click:(id)sender
{
    if (delegate != nil && [delegate respondsToSelector:@selector(selectItemOnScrollTool:)])
    {
        [delegate selectItemOnScrollTool:sender];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint contentOffset = aScrollView.contentOffset;
    if (contentOffset.x < _minContentOffset)
    {
        contentOffset.x = _minContentOffset;
        scrollView.contentOffset = contentOffset;
    }
    else if (contentOffset.x > _maxContentOffset)
    {
        contentOffset.x = _maxContentOffset;
        scrollView.contentOffset = contentOffset;
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, keyboardRect.origin.y - 87, rect.size.width, self.bounds.size.height);
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0, rect.size.height, rect.size.width, self.bounds.size.height);
    [UIView commitAnimations];
}

- (NSString *)buttonTextOfIndex:(NSInteger)index
{
    NSString *text = nil;
    switch (index)
    {
        case 0:
        {
            text = @"B";
        }break;
        case 1:
        {
            text = @"I";
        }break;
        case 2:
        {
            text = @"U";
        }break;
        case 3:
        {
            text = @"+";
        }break;
        case 4:
        {
            text = @"-";
        }break;
//        case 5:
//        {
//            text = @"Color";    //Font
//        }break;
//        case 6:
//        {
//            text = @"Font";
//        }break;
        case 5:
        {
            text = @"photo";
        }break;
        case 6:
        {
            text = @"indent";
        }break;
        case 7:
        {
            text = @"outdent";
        }break;
        case 8:
        {
            text = @"insertOrderedList";
        }break;
        case 9:
        {
            text = @"insertUnorderedList";
        }break;
        case 10:
        {
            text = @"justifyLeft";
        }break;
        case 11:
        {
            text = @"justifyCenter";
        }break;
        case 12:
        {
            text = @"justifyRight";
        }break;
        case 13:
        {
           
        }break;
        default:
            break;
    }
    
    return text;
}

@end
