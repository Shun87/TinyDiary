//
//  Document.h
//  iDiary
//
//  Created by chenshun on 13-1-7.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegularFile.h"

#define kNotePacketExtension @"notePacket"
#define kDetail @".detail"

@class Metadata;

@interface NoteDocument : UIDocument

@property (nonatomic, strong) Metadata *metadata;

- (void)addRegularFile:(RegularFile *)data;

- (void)setThumbnail:(UIImage *)image;
- (void)setDetailText:(NSString *)text;
@end
