//
//  DiaryDescription.m
//  iDiary
//
//  Created by chenshun on 12-12-4.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "DiaryDescription.h"
#import "CommmonMethods.h"

@implementation DiaryDescription

@synthesize date;
@synthesize generalContent;
@synthesize weather;
@synthesize feeling;
@synthesize label;
@synthesize hasImage;
@synthesize hasVideo;
@synthesize hasAudio;
@synthesize htmlPath;

- (void)dealloc
{
    [date release];
    [generalContent release];
    [weather release];
    [feeling release];
    [label release];
    [hasImage release];
    [hasVideo release];
    [hasAudio release];
    [htmlPath release];
    [super dealloc];
}

- (id)initWith:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.generalContent = [dictionary objectForKey:kDiaryGeneralContent];
        self.date = [dictionary objectForKey:kGeneratedDate];
        self.weather = [dictionary objectForKey:kWeather];
        self.feeling = [dictionary objectForKey:kFeeling];
        self.label = [dictionary objectForKey:kLabel];
        self.hasImage = [dictionary objectForKey:kHasImage];
        self.hasVideo = [dictionary objectForKey:kHasVideo];
        self.hasAudio = [dictionary objectForKey:kHasAudio];
        self.htmlPath = [dictionary objectForKey:kHtmlPath];
    }
    
    return self;
}
@end
