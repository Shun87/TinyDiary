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

- (void)addObject:(id)data
       toWrappers:(NSMutableDictionary *)wrappers
preferredFileName:(NSString *)preferredFileName
{
    NSFileWrapper *childFile = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    [wrappers setObject:childFile forKey:preferredFileName];
    [childFile release];
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
  
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.plistDic forKey:kPlistData];

    [archiver finishEncoding];
    [self addObject:data toWrappers:wrappers preferredFileName:DiaryInfo];
    [archiver release];

    return [[[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers] autorelease];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    NSFileWrapper *wrapper = contents;
    
    NSFileWrapper *metaWrapper = [wrapper.fileWrappers objectForKey:DiaryInfo];
    if (metaWrapper != nil)
    {
        NSData * data = [metaWrapper regularFileContents];
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.plistDic = [unarchiver decodeObjectForKey:kPlistData];
        [unarchiver release];
    }

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
