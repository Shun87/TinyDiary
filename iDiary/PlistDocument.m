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
    
    NSString *tag = info.tags;
    if (tag == nil)
    {
        tag = @"";
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
}

- (void)removeKey:(NSString *)key
{
    [self.plistDic removeObjectForKey:key];
}

- (NSArray *)units
{
    return self.diaryUnit.diaryArray;
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"Error: %@  reason = %@, localizedRecoverySuggestion = %@, userInfo=%@", error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion,
          error.userInfo);
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
}
@end
