//
//  CommmonMethods.m
//  iDiary
//
//  Created by chenshun on 12-11-25.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "CommmonMethods.h"
#import "NSDateAdditions.h"

@implementation CommmonMethods

+ (NSString *)documentPath
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return documentDirectory;
}

+ (NSArray *)readLocalMonths
{
    NSString *documentDirectory = [CommmonMethods documentPath];
    
//    NSError *error = nil;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    // 月份
//    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentDirectory error:&error];
//    
//    return [NSMutableArray arrayWithArray:contents];
    
    NSString *diaryPlist = [documentDirectory stringByAppendingPathComponent:kDiaryUnitPlist];
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:diaryPlist];
    return [mutableDictionary allKeys];
}

+ (NSArray *)diaryListInYear:(NSUInteger)year month:(NSUInteger)month
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    NSString *text = [NSString stringWithFormat:@"%4u-%2u", year, month];
    NSString *documentDirectory = [CommmonMethods documentPath];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:text];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSError *error = nil;
        NSDictionary *dictionary = [fileManager attributesOfItemAtPath:filePath error:&error];
        
        NSArray *arrya = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
        [mutableArray addObjectsFromArray:arrya];
    }
    
    return [mutableArray autorelease];
}

+ (NSString *)fileNameFromDate:(NSDate *)date
{
    NSDateComponents *components = [date cc_componentsForMonthDayAndYear];
    return [NSString stringWithFormat:@"%04u%02u%02u", [components year], [components month], [components day]];
}

+ (NSDateComponents *)componentsFromDate:(NSDate *)date
{
    return [date cc_componentsForMonthDayAndYear];
}

+ (UIColor *)colorFromRGBValue:(NSString *)rgb
{ // General format is 'rgb(red, green, blue)'
    if ([rgb rangeOfString:@"rgb"].location == NSNotFound)
        return nil;
    
    NSMutableString *mutableCopy = [rgb mutableCopy];
    [mutableCopy replaceCharactersInRange:NSMakeRange(0, 4) withString:@""];
    [mutableCopy replaceCharactersInRange:NSMakeRange(mutableCopy.length-1, 1) withString:@""];
    
    NSArray *components = [mutableCopy componentsSeparatedByString:@","];
    int red = [[components objectAtIndex:0] intValue];
    int green = [[components objectAtIndex:1] intValue];
    int blue = [[components objectAtIndex:2] intValue];
    
    UIColor *retVal = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return retVal;
}

+ (UIImage *)scaledImage:(UIImage *)srcImage size:(CGSize)imageSize
{
    UIImage *dstImage = nil;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), srcImage.CGImage);
    dstImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return dstImage;
}

+ (NSString *)saveImage:(UIImage *)image name:(NSString *)imgName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imgName];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:imagePath atomically:YES];
    return imagePath;
}

@end
