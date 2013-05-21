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

// sort
+ (void)sortUsingDescending:(NSMutableArray *)array;
+ (void)sortDateUsingDescending:(NSMutableArray *)array;

+ (NSString *)monthAndYear:(NSDate *)date;
+ (NSDate *)dateFromMonthAndYearStr:(NSString *)str;
+ (NSString *)monthAndDay:(NSDate *)date;

+ (NSString *)dayString:(NSDate *)date;
@end

/*
 Date Format Options are as follows:
 
 Now you want all the string formats that can be used with NSDateFormatter. Here is that
 
 a: AM/PM
 
 A: 0~86399999 (Millisecond of Day)
 
 c/cc: 1~7 (Day of Week)
 
 ccc: Sun/Mon/Tue/Wed/Thu/Fri/Sat
 
 cccc: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
 
 d: 1~31 (0 padded Day of Month)
 
 D: 1~366 (0 padded Day of Year)
 
 e: 1~7 (0 padded Day of Week)
 
 E~EEE: Sun/Mon/Tue/Wed/Thu/Fri/Sat
 
 EEEE: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
 
 F: 1~5 (0 padded Week of Month, first day of week = Monday)
 
 g: Julian Day Number (number of days since 4713 BC January 1)
 
 G~GGG: BC/AD (Era Designator Abbreviated)
 
 GGGG: Before Christ/Anno Domini
 
 h: 1~12 (0 padded Hour (12hr))
 
 H: 0~23 (0 padded Hour (24hr))
 
 k: 1~24 (0 padded Hour (24hr)
 
 K: 0~11 (0 padded Hour (12hr))
 
 L/LL: 1~12 (0 padded Month)
 
 LLL: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 
 LLLL: January/February/March/April/May/June/July/August/September/October/November/December
 
 m: 0~59 (0 padded Minute)
 
 M/MM: 1~12 (0 padded Month)
 
 MMM: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 
 MMMM: January/February/March/April/May/June/July/August/September/October/November/December
 
 q/qq: 1~4 (0 padded Quarter)
 
 qqq: Q1/Q2/Q3/Q4
 
 qqqq: 1st quarter/2nd quarter/3rd quarter/4th quarter
 
 Q/QQ: 1~4 (0 padded Quarter)
 
 QQQ: Q1/Q2/Q3/Q4
 
 QQQQ: 1st quarter/2nd quarter/3rd quarter/4th quarter
 
 s: 0~59 (0 padded Second)
 
 S: (rounded Sub-Second)
 
 u: (0 padded Year)
 
 v~vvv: (General GMT Timezone Abbreviation)
 
 vvvv: (General GMT Timezone Name)
 
 w: 1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year)
 
 W: 1~5 (0 padded Week of Month, 1st day of week = Sunday)
 
 y/yyyy: (Full Year)
 
 yy/yyy: (2 Digits Year)
 
 Y/YYYY: (Full Year, starting from the Sunday of the 1st week of year)
 
 YY/YYY: (2 Digits Year, starting from the Sunday of the 1st week of year)
 
 z~zzz: (Specific GMT Timezone Abbreviation)
 
 zzzz: (Specific GMT Timezone Name)
 
 Z: +0000 (RFC 822 Timezone)
 
 ==========================================
 
 Set the format as you like..
*/