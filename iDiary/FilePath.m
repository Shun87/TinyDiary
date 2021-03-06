//
//  DocFile.m
//  iDiary
//
//  Created by chenshun on 13-1-9.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "FilePath.h"
#import "DocEntity.h"
#import "MonthSort.h"

@implementation FilePath

+ (NSURL *)localDocumentsDirectoryURL
{
    static NSURL *localDocumentsDirectoryURL = nil;
    if (localDocumentsDirectoryURL == nil)
    {
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                                NSUserDomainMask, YES ) objectAtIndex:0];
        localDocumentsDirectoryURL = [[NSURL fileURLWithPath:documentsDirectoryPath] retain];
    }
    return localDocumentsDirectoryURL;
}

+ (NSURL *)getDocURL:(NSString *)filename
{
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * url = [paths objectAtIndex:0];
    return [url URLByAppendingPathComponent:filename];
}

+ (NSString*)generateFileNameBy:(NSDate *)date extension:(NSString *)extension
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMdd HH-mm-ss"];
    if (extension != nil)
    {
        return [NSString stringWithFormat:@"%@.%@", [dateFormatter stringFromDate:date], extension];
    }
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}   

+ (NSDate *)timeFromURL:(NSURL *)url
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMdd HH-mm-ss"];
    NSString *dateString = [[url lastPathComponent] stringByDeletingPathExtension];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)monthAndYear:(NSDate *)date
{
     NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"LLLL yyyy"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromMonthAndYearStr:(NSString *)str
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"LLLL yyyy"];
    return [dateFormatter dateFromString:str];
}

+ (NSString *)dayString:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMdd"];

    return [dateFormatter stringFromDate:date];
}

+ (NSString *)monthAndDay:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"LLLL d"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)shortMonthAndYear:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"LLL yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)week:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"cccc"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)day:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d"];
    
    return [dateFormatter stringFromDate:date];
}

+ (void)sortInfoUsingDescending:(NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        
        NSURL *url1 = [NSURL fileURLWithPath:((DiaryInfo *)obj1).url];
        NSURL *url2 = [NSURL fileURLWithPath:((DiaryInfo *)obj2).url];
        NSDate *date1 = [FilePath timeFromURL:url1];
        NSDate *date2 = [FilePath timeFromURL:url2];
        NSComparisonResult result = [date1 compare:date2];
        if (result ==  NSOrderedAscending)
        {
            return NSOrderedDescending;
        }
        else if (result ==  NSOrderedDescending)
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

+ (NSString *)tempRoot
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return documentDirectory;
}

@end
