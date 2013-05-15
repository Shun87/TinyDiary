//
//  PlistDocument.m
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "PlistDocument.h"


#define kPlistData @"PlistData"

@implementation PlistDocument
@synthesize plistDic;
@synthesize diaryUnit;

- (void)dealloc
{
    [diaryUnit release];
    [plistDic release];
    [super dealloc];
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.plistDic];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.plistDic = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)contents];
    self.diaryUnit = [[[DiaryUnit alloc] initWithDic:self.plistDic] autorelease];
    return YES;
}

- (void)saveDiaryInfo:(DiaryInfo *)info
{
    NSString *title = info.title;
    if (title == nil)
    {
        title = @"";
    }
    
    NSString *tag = @"";
    for (int i=0; i<[info.tags count]; i++)
    {
        if (i == 0)
        {
            tag = [info.tags objectAtIndex:i];
        }
        else
        {
            tag = [tag stringByAppendingFormat:[NSString stringWithFormat:@"|%@", [info.tags objectAtIndex:i]]];
        }
    }
    
    NSString *creatTime = @"";
    if (info.creatTime != nil)
    {
        creatTime = info.creatTime;
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjects:
                         [NSArray arrayWithObjects:title, tag, creatTime, nil]
                                                    forKeys:[NSArray arrayWithObjects:DIC_KEY_TITLE, DIC_TAG, DIC_CREAT_TIME, nil]];
    if (self.plistDic == nil)
    {
        self.plistDic = [NSMutableDictionary dictionary];
    }
    [self.plistDic setObject:dic forKey:info.url];
    
//    [self.undoManager setActionName:@"Item Change"];
//    [self.undoManager registerUndoWithTarget:self selector:@selector(modify:) object:info];
}

- (NSArray *)units
{
    return self.diaryUnit.diaryArray;
}

@end
