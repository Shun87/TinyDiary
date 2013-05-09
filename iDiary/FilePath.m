//
//  DocFile.m
//  iDiary
//
//  Created by chenshun on 13-1-9.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "FilePath.h"
#import "DocEntity.h"

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

+ (void)sortUsingDescending:(NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        
        NSURL *url1 = ((DocEntity *)obj1).docURL;
        NSURL *url2 = ((DocEntity *)obj2).docURL;
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
