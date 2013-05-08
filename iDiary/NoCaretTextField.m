//
//  NoCursorT.m
//  iDiary
//
//  Created by chenshun on 13-3-11.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "NoCaretTextField.h"

@implementation NoCaretTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

@end
