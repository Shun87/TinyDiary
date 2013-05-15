//
//  DiaryInfo.h
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryInfo : NSObject <NSCoding>
{
    NSString *url;
    NSString *creatTime;
    NSMutableArray *tags;
}

@property (nonatomic, readonly)NSString *url;
@property (nonatomic, readonly)NSString *creatTime;
@property (nonatomic, readonly)NSMutableArray *tags;

- (void)initWithObject:(id<NSCoding>)obj;
@end
