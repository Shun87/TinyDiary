//
//  RegularFileMetadata.m
//  iDiary
//
//  Created by chenshun on 13-1-13.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "Metadata.h"

@implementation Metadata
@synthesize thumbnailImage;
@synthesize detailText;

#define kDetailText      @"detailText"
#define kThumbnailImage     @"thumbnailImage"
- (void)dealloc
{
    [detailText release];
    [thumbnailImage release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (thumbnailImage != nil)
    {
        NSData *photoData = UIImagePNGRepresentation(thumbnailImage);
        [aCoder encodeObject:photoData forKey:kThumbnailImage];
    }
   
    if (detailText != nil)
    {
        [aCoder encodeObject:self.detailText forKey:kDetailText];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *content = [aDecoder decodeObjectForKey:kDetailText];
    NSData *imageData = [aDecoder decodeObjectForKey:kThumbnailImage];
    UIImage *image = nil;
    if (imageData != nil)
    {
        image = [UIImage imageWithData:imageData];
    }
    
    self = [super init];
    if (self)
    {
        self.thumbnailImage = image;
        self.detailText = content;
        if (self.detailText == nil)
        {
            self.detailText = @"";
        }
    }

    return self;
}

@end
