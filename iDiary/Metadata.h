//
//  RegularFileMetadata.h
//  iDiary
//
//  Created by chenshun on 13-1-13.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Metadata : NSObject <NSCoding>

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, copy) NSString *detailText;

@end
