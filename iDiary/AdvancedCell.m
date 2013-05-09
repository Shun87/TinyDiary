//
//  DiaryGeneralContentCell.m
//  iDiary
//
//  Created by chenshun on 12-11-21.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "AdvancedCell.h"
#import "CommmonMethods.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+FormattedStrings.h"
#import "NSDateAdditions.h"

const CGFloat kLeftMargin = 10;
const CGFloat kRightMargin = 70;

#define Time_light_gray 0x7a7f88
#define Tip_Blue    0x145dd6
#define Day_Color   0x4c5a65
#define Title_Color 0x3b3b3b

@implementation AdvancedCell
@synthesize thumbnail;
@synthesize delegate;
@synthesize thumbImageView, day, week, title, time, contentLabel;

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    time.backgroundColor = [UIColor clearColor];
    week.backgroundColor = [UIColor clearColor];
    day.backgroundColor = [UIColor clearColor];
    title.backgroundColor = [UIColor clearColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    opened = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    time.font = [UIFont systemFontOfSize:10];
    week.font = [UIFont systemFontOfSize:12];
    day.font = [UIFont systemFontOfSize:28];
    time.textColor = HEXCOLOR(Time_light_gray, 1);
    week.textColor = HEXCOLOR(Time_light_gray, 1);
    day.textColor = HEXCOLOR(Day_Color, 1);
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:11];
    contentLabel.textColor = HEXCOLOR(Time_light_gray, 1);
    title.numberOfLines = 0;
    title.font = [UIFont boldSystemFontOfSize:15];
    title.textColor = HEXCOLOR(Title_Color, 1);
    
    thumbImageView.layer.masksToBounds = YES;
    thumbImageView.layer.cornerRadius = 4.0;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setBackgroundImageName:(NSString *)imagePath
{
    if (!self.backgroundView)
    {
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:imagePath]
                                    stretchableImageWithLeftCapWidth:0.0 topCapHeight:3.0];

        UIImageView *contentImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        contentImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        contentImageView.frame = self.bounds;
        self.backgroundView = contentImageView;
        [contentImageView release];
    }
}

- (IBAction)handleTouched:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(handleTouchOnCell:tag:)])
    {
        [delegate handleTouchOnCell:self tag:button.tag];
    }
}

- (void)setTitleStr:(NSString *)text
{
    title.text = text;
    CGRect rect = title.frame;
    rect.origin.x = kLeftMargin;
    rect.size.width = self.bounds.size.width - kRightMargin - rect.origin.x;
    title.frame = rect;
}

- (void)setcontent:(NSString *)text
{
    contentLabel.text = text;
    CGRect rect = contentLabel.frame;
    rect.origin.x = kLeftMargin;
    rect.size.width = self.bounds.size.width - kRightMargin - rect.origin.x;
    contentLabel.frame = rect;
}

- (void)setThumbnail:(UIImage *)image
{
    if (image == nil)
    {
        return;
    }
    
    [thumbnail release];
    thumbnail = [image retain];
    
    CGSize cellSize = self.bounds.size;
    CGSize size = CGSizeMake(72, 72);
    float x = kLeftMargin;
    float y = (cellSize.height - size.height) / 2;
    thumbImageView.image = image;
    thumbImageView.frame = CGRectMake(x, y, size.width, size.height);
    
    CGRect rect = contentLabel.frame;
    x += size.width + kLeftMargin;
    rect.origin.x = x;
    rect.size.width = self.bounds.size.width - x - kRightMargin;
    contentLabel.frame = rect;
    
    CGRect titleRect = title.frame;
    titleRect.origin.x = rect.origin.x;
    title.frame = titleRect;
}

- (void)setData:(NSDate *)date
{
     [date mediumString];
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"hh:mm a"]; //HH 24H hh:12h
    
    self.time.text = [dateFormatter stringFromDate:date];
    
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd"];
    self.day.text = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"EEEE"];
    self.week.text = [dateFormatter stringFromDate:date];
}

- (void)dealloc
{
    [thumbnail release];
    [day release];
    [week release];
    [title release];
    [time release];
    [super dealloc];
}
@end
