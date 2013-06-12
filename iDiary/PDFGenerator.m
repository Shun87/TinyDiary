//
//  PDFGenerator.m
//  TinyDiaryPro
//
//  Created by chenshun on 13-6-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "PDFGenerator.h"

@implementation PDFGenerator

+ (void)creatPDFWithPrintFormatter:(UIPrintFormatter *)printFormatter
{
    CGSize pageSize = kPaperSizeA4;
    UIEdgeInsets pageMargins = UIEdgeInsetsMake(10, 5, 10, 5);
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    
    [render addPrintFormatter:printFormatter startingAtPageAtIndex:0];
    
    CGRect printableRect = CGRectMake(pageMargins.left,
                                      pageMargins.top,
                                      pageSize.width - pageMargins.left - pageMargins.right,
                                      pageSize.height - pageMargins.top - pageMargins.bottom);
    
    CGRect paperRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
    
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSData *pdfData = [render printToPDF];
    
    [pdfData writeToFile: [@"~/Documents/demo.pdf" stringByExpandingTildeInPath]  atomically: YES];
}
@end

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
}
@end
