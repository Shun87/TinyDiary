//
//  Document.m
//  iDiary
//
//  Created by chenshun on 13-1-7.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "NoteDocument.h"
#import "Metadata.h"

#define METADATA_FILENAME   @"note.meta"
#define DATA_FILENAME       @"note.data"
#define ArchiveMetadataKey  @"ArchiveMetadataKey"

@interface NoteDocument()
{
    NSMutableArray *regularFiles;
    Metadata *metadata;
}
@property (nonatomic, strong) NSFileWrapper *fileWrapper;

@end

@implementation NoteDocument

@synthesize fileWrapper;
@synthesize metadata;

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
    if ([regularFiles count] <= 0)
    {
        return nil;
    }
    
    // note data
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    
    for (RegularFile *regularData in regularFiles)
    {
        [self addObject:regularData.data toWrappers:wrappers preferredFileName:regularData.fileName];
    }

    // metadata
    if (self.metadata != nil)
    {
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self.metadata forKey:ArchiveMetadataKey];
        [archiver finishEncoding];
        [self addObject:data toWrappers:wrappers preferredFileName:METADATA_FILENAME];
        [archiver release];
    }

    return [[[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers] autorelease];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.fileWrapper = contents;

    if (self.fileWrapper == nil)
    {
        return NO;
    }

    if (regularFiles == nil)
    {
        regularFiles = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *dictionary = self.fileWrapper.fileWrappers;
    for (int i=0; i<[[dictionary allKeys] count]; i++)
    {
        NSString *fileName = [[dictionary allKeys] objectAtIndex:i];
        NSFileWrapper *childFile = [dictionary objectForKey:fileName];
        RegularFile *regular = [[RegularFile alloc] initWithFileName:[childFile filename] 
                                                                data:[childFile regularFileContents]];
        [regularFiles addObject:regular];
        [regular release];
    }

     // metadata
    NSFileWrapper *metaWrapper = [self.fileWrapper.fileWrappers objectForKey:METADATA_FILENAME];
    if (metaWrapper != nil)
    {
        NSData * data = [metaWrapper regularFileContents];
        NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.metadata = [unarchiver decodeObjectForKey:ArchiveMetadataKey];
        [unarchiver release];
    }
    
    return YES;
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"Error: %@  reason = %@, localizedRecoverySuggestion = %@, userInfo=%@", error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion, 
          error.userInfo);
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
}

- (void)addRegularFile:(RegularFile *)data
{
    if (regularFiles == nil)
    {
        regularFiles = [[NSMutableArray alloc] init];
    }
    
    if (data != nil)
    {
        RegularFile *fileToDel = nil;
        for (RegularFile *file in regularFiles)
        {
            if ([file.fileName isEqualToString:data.fileName])
            {
                fileToDel = file;
                break;
            }
        }
        
        if (fileToDel != nil)
        {
            [regularFiles removeObject:fileToDel];
        }
        
        [regularFiles addObject:data];
    }
}

- (void)setThumbnail:(UIImage *)image
{
    if (self.metadata == nil)
    {
        Metadata *meta = [[Metadata alloc] init];
        self.metadata = meta;
        [meta release];
    }
    
    self.metadata.thumbnailImage = image;
}

- (void)setDetailText:(NSString *)text
{
    if (self.metadata == nil)
    {
        Metadata *meta = [[Metadata alloc] init];
        self.metadata = meta;
        [meta release];
    }
    
    self.metadata.detailText = text;
}

- (void)dealloc
{
    [regularFiles release];
    [metadata release];
    [fileWrapper release];
    [super dealloc];
}
@end
