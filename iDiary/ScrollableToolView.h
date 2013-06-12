//
//  ScrollableScrollableToolView.h
//  iDiary
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelTouchesScrollView.h"
#import "RichEditView.h"

@protocol ScrollableToolViewDelegate;
@interface ScrollableToolView : UIView<UIScrollViewDelegate>
{
    CancelTouchesScrollView *scrollView;
    float _maxContentOffset;
    float _minContentOffset;
    
    NSMutableArray *textArray;
    id<ScrollableToolViewDelegate>delegate;
    UIImageView *hilightImageView;
    RichEditView *editView;
}
@property (nonatomic, retain)RichEditView *editView;
@property (nonatomic, retain)CancelTouchesScrollView *scrollView;
@property (nonatomic, assign)id<ScrollableToolViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame imageNames:(NSArray *)names titleArray:(NSArray *)array delegate:(id)aDelegate;
- (NSString *)buttonTextOfIndex:(NSInteger)index;

@end


@protocol ScrollableToolViewDelegate <NSObject>

- (void)selectItemOnScrollTool:(id)sender;
- (BOOL)shouldBeFirstResponder;
@end