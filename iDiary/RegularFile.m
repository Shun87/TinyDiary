//
//  NoteData.m
//  iDiary
//
//  Created by chenshun on 13-1-7.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "RegularFile.h"

@interface RegularFile()
@end

@implementation RegularFile
@synthesize data;
@synthesize fileName;

- (id)initWithFileName:(NSString *)aFileName data:(NSData *)aData
{
    if (self = [super init])
    {
        self.data = aData;
        self.fileName = aFileName;
    }
    return self;
}

- (void)dealloc
{
    [fileName release];
    [data release];
    [super dealloc];
}
@end
