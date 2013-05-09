//
//  RichEditView.h
//  iDiary
//
//  Created by chenshun on 12-11-27.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichEditViewDelegate;
@interface RichEditView : UIView<UIWebViewDelegate>
{
    UIWebView *webView;
    id<RichEditViewDelegate> delegate;
}
@property (nonatomic, assign)id<RichEditViewDelegate> delegate;
- (void)loadHtmlPath:(NSURL *)url;

- (void)bold;
- (void)italic;
- (void)underline;

// 缩进
- (void)indent;
- (void)outdent;

// 序号
- (void)insertUnorderedList;
- (void)insertOrderedList;

// align
- (void)justifyRight;
- (void)justifyLeft;
- (void)justifyCenter;

// font
- (NSUInteger)getCurrentFontSize;
- (void)setFontSize:(NSUInteger)size;
- (void)setFont:(NSString *)fonTName;
- (void)setFontColor:(NSString *)colorString;

- (void)backColor:(NSInteger)color;

- (void)closeKeyboard;
- (NSString *)outerHtml;
- (NSString *)innerHtml;
- (void)setInnerHtml:(NSString *)html;

- (NSString *)getCurrentFontName;

- (void)insertImage:(NSString *)imagePath size:(CGSize)size;
- (void)saveRange;
- (void)restoreRange;

- (NSString *)getGeneralText;

- (void)setAttribute:(NSString *)name value:(NSString *)value;
- (void)scrollBy:(float)count;

// edit
- (void)setEditable:(BOOL)editable;
- (void)undo;

//Image tag
- (NSString *)firstImageTagSrc;
@end

@protocol RichEditViewDelegate <NSObject>

- (void)richEditor:(RichEditView *)aRichEditor shouldStartLoadWithRequest:(NSURLRequest *)request;
- (void)richEditorDidFinishLoad:(RichEditView *)aRichEditor;
@end
