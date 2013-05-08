//
//  DiarySimpleInfo.h
//  iDiary
//
//  Created by chenshun on 13-1-10.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Metadata.h"

@interface DocEntity : NSObject
@property (nonatomic, strong) NSURL * docURL;
@property (nonatomic, assign) BOOL downloadSuccess;
@property (nonatomic, strong) Metadata *metadata;
@property (nonatomic, assign) UIDocumentState state;
@property (nonatomic, strong) NSFileVersion * version;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (id)initWithFileURL:(NSURL *)fileURL metadata:(Metadata *)metadata state:(UIDocumentState)state version:(NSFileVersion *)version;
- (NSString *)name;
@end