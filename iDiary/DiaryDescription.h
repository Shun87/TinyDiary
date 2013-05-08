//
//  DiaryDescription.h
//  iDiary
//
//  Created by chenshun on 12-12-4.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryDescription : NSObject
{
    NSString *date;
    NSString *generalContent;
    NSString *weather;
    NSString *feeling;
    NSString *label;
    NSString *hasImage;
    NSString *hasVideo;
    NSString *hasAudio;
    NSString *htmlPath;
}
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *generalContent;
@property (nonatomic, copy)NSString *weather;
@property (nonatomic, copy)NSString *feeling;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *hasImage;
@property (nonatomic, copy)NSString *hasVideo;
@property (nonatomic, copy)NSString *hasAudio;
@property (nonatomic, copy)NSString *htmlPath;
- (id)initWith:(NSDictionary *)dictionary;
@end
