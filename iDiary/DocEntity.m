//
//  DiarySimpleInfo.m
//  iDiary
//
//  Created by chenshun on 13-1-10.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "DocEntity.h"

@implementation DocEntity
@synthesize docURL = _docURL;
@synthesize metadata = _metadata;
@synthesize state = _state;
@synthesize version = _version;
@synthesize indexPath = _indexPath;
@synthesize downloadSuccess = _downloadSuccess;

- (id)initWithFileURL:(NSURL *)fileURL metadata:(Metadata *)metadata state:(UIDocumentState)state version:(NSFileVersion *)version {
    
    if ((self = [super init])) {
        self.docURL = fileURL;
        self.metadata = metadata;
        self.state = state;
        self.version = version;
        self.downloadSuccess = NO;
    }
    return self;
    
}

- (NSString *)name {
    return [[self.docURL lastPathComponent] stringByDeletingPathExtension];
}

- (void)dealloc
{
    [_docURL release];
    [_metadata release];
    [_indexPath release];
    [super dealloc];
}
@end
