//
//  DiaryInfo.m
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "DiaryInfo.h"

@implementation DiaryInfo
@synthesize url, creatTime, tags, title;

- (id)init
{
    if (self = [super init])
    {
        self.tags = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    [tags release];
    [url release];
    [creatTime release];
    [title release];
    [super dealloc];
}

@end

@implementation DiaryUnit
@synthesize diaryArray;

- (id)initWithDic:(NSMutableDictionary *)mutableDictionary
{
    if (self = [super init])
    {
        self.diaryArray = [NSMutableArray array];
        for (int i=0; i<[[mutableDictionary allKeys] count]; i++)
        {
            NSString *key = [[mutableDictionary allKeys] objectAtIndex:i];
            
            NSDictionary *dictionary = [mutableDictionary objectForKey:key];
            
            DiaryInfo *diary = [[DiaryInfo alloc] init];
            diary.url = key;
            diary.title = [dictionary objectForKey:DIC_KEY_TITLE];
            NSLog(@"%@", diary.title);
            diary.creatTime = [dictionary objectForKey:DIC_CREAT_TIME];
            NSString *strTag = [dictionary objectForKey:DIC_CREAT_TIME];
            [diary.tags addObject:[strTag componentsSeparatedByString:@"|"]];
            
            [diaryArray addObject:diary];
            
            [diary release];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [diaryArray release];
    [super dealloc];
}

@end
