//
//  PlistDocument.m
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "PlistDocument.h"

#define kPlistData @"PlistData"
#define DiaryInfo @"DiaryInfo"

@implementation PlistDocument
@synthesize plistDic;

- (void)dealloc
{
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

    return YES;
}

- (void)addItem:(NSDictionary *)dictionary forName:(NSString *)name
{
    if (self.plistDic == nil)
    {
        self.plistDic = [NSMutableDictionary dictionary];
    }
    
    if (![[self.plistDic allKeys] containsObject:name])
    {
        [self.plistDic setObject:dictionary forKey:name];
    }

    [self.undoManager setActionName:@"Item Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(addItem:) object:dictionary];
}
@end
