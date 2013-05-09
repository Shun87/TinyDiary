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

const CGFloat kLeftMargin = 10;
const CGFloat kRightMargin = 40;

@implementation AdvancedCell
@synthesize dateText, detailText, thumbnail;
@synthesize opened;
@synthesize delegate;

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    dateLabel.backgroundColor = [UIColor clearColor];
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

    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = HEXCOLOR(0x145dd6, 1);
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = HEXCOLOR(0x7a7f88, 1);
    thumbImageView.layer.masksToBounds = YES;
    thumbImageView.layer.cornerRadius = 6.0;
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


        
        // front view
        UIImageView *contentImageView = [[UIImageView alloc] initWithImage:backgroundImage];
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

- (void)setContentFrontroundFrame:(CGRect)rect
{
    self.contentView.frame = rect;
    contentFrontView.frame = rect;
}

- (void)setDateText:(NSString *)text
{
    [dateText release];
    dateText = [text copy];
    dateLabel.text = text;
}

- (void)setDetailText:(NSString *)text
{
    [detailText release];
    detailText = [text copy];
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
    CGSize size = CGSizeMake(image.size.width / 2, image.size.height / 2);
    float x = kLeftMargin;
    float y = (cellSize.height - size.height) / 2;
    thumbImageView.image = image;
    thumbImageView.frame = CGRectMake(x, y, size.width, size.height);
    
    CGRect rect = contentLabel.frame;
    x += size.width + kLeftMargin;
    rect.origin.x = x;
    rect.size.width = self.bounds.size.width - x - kRightMargin;
    contentLabel.frame = rect;
}

- (void)dealloc
{
    [dateText release];
    [detailText release];
    [thumbnail release];
    [contentFrontView release];
    [optionButtonView release];
    [super dealloc];
}
@end
