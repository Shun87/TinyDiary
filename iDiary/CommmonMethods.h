//
//  CommmonMethods.h
//  iDiary
//
//  Created by chenshun on 12-11-25.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDiaryUnitPlist @"diaryUnit.plist"

#define kDiaryGeneralContent    @"generalContent"
#define kGeneratedDate          @"date"
#define kWeather                @"weather"
#define kFeeling                @"feeling"
#define kLabel                  @"label"
#define kHasImage               @"hanImage"
#define kHasVideo               @"hasVideo"
#define kHasAudio               @"hasAudio"
#define kHtmlPath               @"htmlPath"

#define kUseiCloud        @"iCloudOn"
#define kPsdOn          @"psdOn"
#define kPsdWasOn          @"psdWasOn"
#define kPassword       @"password"

#define HEXCOLOR(rgbValue, alpa) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpa]

#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]


@interface CommmonMethods : NSObject
+ (NSString *)documentPath;
+ (NSArray *)readLocalMonths;
+ (NSArray *)diaryListInYear:(NSUInteger)year month:(NSUInteger)month;
+ (NSString *)fileNameFromDate:(NSDate *)date;
+ (UIColor *)colorFromRGBValue:(NSString *)rgb;
+ (UIImage *)scaledImage:(UIImage *)srcImage size:(CGSize)imageSize;
+ (NSString *)saveImage:(UIImage *)image name:(NSString *)imgName;
+ (NSDateComponents *)componentsFromDate:(NSDate *)date;
@end


