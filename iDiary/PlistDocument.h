//
//  PlistDocument.h
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryInfo.h"

#define DiaryInfoLog @"DiaryInfoLog"

@interface PlistDocument : UIDocument
{
    NSMutableDictionary *plistDic;
    
    DiaryUnit *diaryUnit;
}
@property (nonatomic, retain)NSMutableDictionary *plistDic;
@property (nonatomic, retain)DiaryUnit *diaryUnit;

- (void)saveDiaryInfo:(DiaryInfo *)info;
- (NSArray *)units;
@end
