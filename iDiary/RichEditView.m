//
//  RichEditView.m
//  iDiary
//
//  Created by chenshun on 12-11-27.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import "RichEditView.h"

@interface RichEditView()
- (void) hideGradientBackground:(UIView*)theView;

@end
@implementation RichEditView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        webView = [[UIWebView alloc] initWithFrame:self.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
                                    | UIViewAutoresizingFlexibleBottomMargin
                                    | UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleLeftMargin
                                    | UIViewAutoresizingFlexibleRightMargin
                                    | UIViewAutoresizingFlexibleWidth;
        webView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [webView setOpaque:NO];
        [self addSubview:webView];
        
        [self hideGradientBackground:webView];
//        NSMutableArray *extraItems = [[NSMutableArray alloc] init];
//        UIMenuItem *boldItem = [[UIMenuItem alloc] initWithTitle:@"Bold" action:@selector(bold:)];
//        [extraItems addObject:boldItem];
//        [UIMenuController sharedMenuController].menuItems = extraItems;
 //       webView.scrollView.scrollEnabled = NO;
    }
    return self;
}

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(bold:))
    {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)loadHtmlPath:(NSURL *)url
{
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)bold
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Bold\")"];
}

- (void)italic
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Italic\")"];
}

- (void)underline
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Underline\")"];
}

- (void)indent
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Indent\")"];
}

- (void)outdent
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Outdent\")"];
}

// 序号
- (void)insertUnorderedList
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"InsertUnorderedList\")"];
}

- (void)insertOrderedList
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"InsertOrderedList\")"];
}

// align
- (void)justifyRight
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"JustifyRight\")"];
}

- (void)justifyLeft
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"JustifyLeft\")"];
}

- (void)justifyCenter
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"JustifyCenter\")"];
}


- (void)backColor:(NSInteger)color

{
    //document.execCommand('BackColor',true,'#FFbbDD');//true或false都可以
}

- (void)closeKeyboard
{
    // JS的这个方法在模拟器上没作用
    //[webView endEditing:YES];
    [webView stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
    //execCommand("Undo")
    
    //execCommand("Redo")
    //execCommand("ForeColor","",CColor)
    
}

- (NSString *)getGeneralText
{
    return [webView stringByEvaluatingJavaScriptFromString:@"getGeneralText()"];
}

- (NSString *)firstImageTagSrc
{
    return [webView stringByEvaluatingJavaScriptFromString:@"firstImageTagSrc()"];
}

- (void)setAttribute:(NSString *)name value:(NSString *)value
{
    NSString *jsCode = [NSString stringWithFormat:@"setAttribute(\"%@\", \"%@\")", name, value];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (NSString *)outerHtml
{
    return [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
}

- (NSString *)innerHtml
{
    return [webView stringByEvaluatingJavaScriptFromString:@"getInnertHtml()"];
}

- (void)setInnerHtml:(NSString *)html
{
    NSString *jsCode = [NSString stringWithFormat:@"setInnerHtml(\"%@\")", html];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)setEditable:(BOOL)editable
{
    NSString *value = (editable ? @"true" : @"false");
    [self setAttribute:@"contenteditable" value:value];
}

- (void)undo
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Undo\")"];
}

#pragma mark Font

- (void)setFontSize:(NSUInteger)size
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%i')", size]];
}

- (void)setFont:(NSString *)fontName
{
    if (fontName != nil)
    {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontName', false, '%@')", fontName]];
    }
}

- (void)setFontColor:(NSString *)colorString
{
    if (colorString != nil)
    {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('foreColor', false, '%@')", colorString]];
    }
}

- (NSString *)getCurrentFontName
{
    return [webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontName')"];
}

- (NSUInteger)getCurrentFontSize
{
    return [[webView stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"] intValue];
}

- (void)scrollBy:(float)count
{
    CGPoint offset = webView.scrollView.contentOffset;
    offset.y += count;
    [webView.scrollView setContentOffset:offset animated:YES];
}

- (void)saveRange
{
    [webView stringByEvaluatingJavaScriptFromString:@"saveRange()"];
}

- (void)restoreRange
{
    [webView stringByEvaluatingJavaScriptFromString:@"restoreRange()"];
}

- (void)insertImage:(NSString *)imagePath size:(CGSize)size
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('insertImage', false, '%@')", imagePath]];
    NSString *jsFunc = [NSString stringWithFormat:@"ajustImageSize('%@', '%f', '%f')", imagePath, size.width, size.height];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

#pragma mark WebView Delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if (delegate != nil && [delegate respondsToSelector:@selector(richEditor:shouldStartLoadWithRequest:)])
    {
        [delegate richEditor:self shouldStartLoadWithRequest:request];
    }
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (delegate != nil && [delegate respondsToSelector:@selector(richEditorDidFinishLoad:)])
    {
        [delegate richEditorDidFinishLoad:self];
    }
}

@end


