//
//  PDFGenerator.h
//  TinyDiaryPro
//
//  Created by chenshun on 13-6-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeLetter CGSizeMake(612,792)

@class NDHTMLtoPDF;

@protocol NDHTMLtoPDFDelegate <NSObject>

@optional
- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF;
- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF;

@end

@interface PDFGenerator : NSObject

+ (void)creatPDFWithPrintFormatter:(UIPrintFormatter *)printFormatter;
@end
