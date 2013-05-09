//
//  NoteData.h
//  iDiary
//
//  Created by chenshun on 13-1-7.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegularFile : NSObject
{
    NSData *data;
    NSString *fileName;
}
@property (nonatomic, retain)NSData *data;
@property (nonatomic, copy)NSString *fileName;

- (id)initWithFileName:(NSString *)aFileName data:(NSData *)aData;

@end
