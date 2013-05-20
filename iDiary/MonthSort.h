//
//  MonthSort.h
//  TinyDiaryPro
//
//  Created by  on 13-5-20.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthSort : NSObject
{
    NSString *monthAndYear;
    NSMutableArray *entryArray;
}
@property (nonatomic, copy)NSString *monthAndYear;
@property (nonatomic, retain)NSMutableArray *entryArray;
@end
