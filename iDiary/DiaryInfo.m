//
//  DiaryInfo.m
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "DiaryInfo.h"

@implementation DiaryInfo
@synthesize url, creatTime, tags;

- (void)dealloc
{
    [tags release];
    [url release];
    [creatTime release];
    [super dealloc];
}

- (void)initWithObject:(id<NSCoding>)obj
{
    
}

@end
