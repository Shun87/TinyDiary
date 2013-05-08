//
//  DiaryGeneralContentCell.h
//  iDiary
//
//  Created by chenshun on 12-11-21.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvancedCellDelegate;

@interface AdvancedCell : UITableViewCell
{  
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIImageView *thumbImageView;
    NSString *dateText;
    NSString *detailText;
    UIImage *thumbnail;
    
    BOOL opened;
    UIView *contentFrontView;
    UIView *optionButtonView;
    
    id<AdvancedCellDelegate> delegate;
}
@property (nonatomic, assign)id<AdvancedCellDelegate> delegate;
@property (nonatomic, assign)BOOL opened;
@property (nonatomic, copy)NSString *dateText;
@property (nonatomic, copy)NSString *detailText;
@property (nonatomic, retain)UIImage *thumbnail;

- (void)setBackgroundImageName:(NSString *)imagePath;
- (void)slideCell:(BOOL)open;
@end


@protocol AdvancedCellDelegate <UITableViewDelegate>

- (void)handleTouchOnCell:(AdvancedCell *)cell tag:(NSInteger)tag;

@end