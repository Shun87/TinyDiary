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
#import "TDBadgedCell.h"

const CGFloat kLeftMargin = 10;
const CGFloat kRightMargin = 70;


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
    badgeArray = [[NSMutableArray alloc] init];
    time.font = [UIFont systemFontOfSize:10];
    week.font = [UIFont systemFontOfSize:11];
    day.font = [UIFont boldSystemFontOfSize:35];
    time.textColor = HEXCOLOR(Time_light_gray, 1);
    week.textColor = HEXCOLOR(Time_light_gray, 1);

    day.textColor = HEXCOLOR(Day_Color, 1);
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:11];
    contentLabel.textColor = HEXCOLOR(Time_light_gray, 1);
    title.numberOfLines = 0;
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textColor = HEXCOLOR(Title_Color, 1);
    
    thumbImageView.layer.masksToBounds = YES;
    thumbImageView.layer.cornerRadius = 4.0;
    
    CGRect rect = title.frame;
    rect.origin.x = kLeftMargin;
    rect.size.width = self.bounds.size.width - kRightMargin - rect.origin.x;
    title.frame = rect;
    
    rect = contentLabel.frame;
    rect.origin.x = kLeftMargin;
    rect.size.width = self.bounds.size.width - kRightMargin - rect.origin.x;
    contentLabel.frame = rect;
    

    UIView *subView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)] autorelease];
    [self.contentView addSubview:subView];
    subView.backgroundColor = HEXCOLOR(0xe0e0e0, 1);
    subView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

- (void)setDiaryTag:(NSArray *)tags
{
    if ([tags count] <= 0)
    {
        return;
    }
    
    CGRect rect = contentLabel.frame;
    for (int i=0; i<[tags count]; i++)
    {
        TDBadgeView *badgeView = [[[TDBadgeView alloc] initWithFrame:CGRectZero] autorelease];
        [self.contentView addSubview:badgeView];

        NSString *subTag = [tags objectAtIndex:i];

        CGSize badgeSize = [subTag sizeWithFont:[UIFont boldSystemFontOfSize: 12]];
        rect.origin.y = self.frame.size.height - 20;
        rect.size = badgeSize;
        badgeView.frame = rect;
        badgeView.badgeString = subTag;
        badgeView.badgeColor = HEXCOLOR(0x40adbc, 1.0);
        if (i == 1)
        {
            badgeView.badgeString = @". . .";
            rect.size.width = 30;
            badgeView.frame = rect;
        }
        
        [badgeArray addObject:badgeView];
        rect.origin.x += rect.size.width + 5;
        
        if (i == 1)
        {
            break;
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setDayColor:(UIColor *)color
{
    day.textColor = color;
}

- (void)setBackgroundImageName:(NSString *)imagePath
{
    if (!self.backgroundView)
    {
//        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:imagePath]
//                                    stretchableImageWithLeftCapWidth:0.0 topCapHeight:3.0];
//
//        UIImageView *contentImageView = [[UIImageView alloc] initWithImage:backgroundImage];
//        contentImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
//        contentImageView.frame = self.bounds;
//        self.backgroundView = contentImageView;
//        [contentImageView release];
        
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
}

- (void)setcontent:(NSString *)text
{
    contentLabel.text = text;
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
    
    for (int i=0; i<[badgeArray count]; i++)
    {
        TDBadgeView *badgeView = [badgeArray objectAtIndex:i];
        CGRect badgetRect = badgeView.frame;
        badgetRect.origin.x += size.width + kLeftMargin;
        badgeView.frame = badgetRect;
    }
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
    
    [dateFormatter setDateFormat:@"e"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:date];
    if ([dayOfWeek integerValue] <= 3)
    {
        day.textColor = HEXCOLOR(0x40adbc, 1.0);
    }
}

- (void)dealloc
{
    [thumbnail release];
    [day release];
    [week release];
    [title release];
    [time release];
    [badgeArray release];
    [super dealloc];
}
@end
