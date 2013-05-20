//
//  MonthSort.m
//  TinyDiaryPro
//
//  Created by  on 13-5-20.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "MonthSort.h"

@implementation MonthSort
@synthesize monthAndYear, entryArray;

- (id)init
{
    if (self = [super init])
    {
        entryArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [monthAndYear release];
    [entryArray release];
    [super dealloc];
}
@end
