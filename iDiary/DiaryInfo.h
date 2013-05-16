//
//  DiaryInfo.h
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIC_KEY_TITLE @"Title"
#define DIC_CREAT_TIME @"CreatTime"
#define DIC_TAG @"Tag"

@interface DiaryInfo : NSObject
{
    NSString *url;
    NSString *title;
    NSString *creatTime;
    NSString *tags;
}
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *creatTime;
@property (nonatomic, copy)NSString *tags;

@end

@interface DiaryUnit : NSObject
{
    NSMutableArray *diaryArray;
}
@property (nonatomic, retain)NSMutableArray *diaryArray;

- (id)initWithDic:(NSMutableDictionary *)mutableDictionary;
@end