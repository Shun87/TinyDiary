//
//  DocFile.h
//  iDiary
//
//  Created by chenshun on 13-1-9.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePath : NSObject 
+ (NSURL *)localDocumentsDirectoryURL;
+ (NSURL *)getDocURL:(NSString *)filename;
+ (NSString*)generateFileNameBy:(NSDate *)date extension:(NSString *)extension;
+ (NSString *)tempRoot;
+ (NSDate *)timeFromURL:(NSURL *)url;
+ (void)sortUsingDescending:(NSMutableArray *)array;
@end
