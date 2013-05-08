//
//  CancelTouchesScrollView.m
//  iDiary
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "CancelTouchesScrollView.h"

@implementation CancelTouchesScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.canCancelContentTouches = YES;
    }
    return self;
}
// called before scrolling begins if touches have already been delivered to a subview of the scroll view. 
// if it returns NO the touches will continue to be delivered to the subview and scrolling will not occur
// not called if canCancelContentTouches is NO. default returns YES if view isn't a UIControl
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    // 再滑动的时候是不允许响应button的点击事件
    return YES;
}

@end
