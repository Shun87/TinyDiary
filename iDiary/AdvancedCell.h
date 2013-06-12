//
//  DiaryGeneralContentCell.h
//  iDiary
//
//  Created by chenshun on 12-11-21.
//  Copyright (c) 2012年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Time_light_gray 0x7a7f88
#define Tip_Blue    0x145dd6
#define Day_Color   0x4c5a65
#define Title_Color 0x3b3b3b

@protocol AdvancedCellDelegate;

@interface AdvancedCell : UITableViewCell
{  
    IBOutlet UILabel *contentLabel;
    IBOutlet UIImageView *thumbImageView;
    IBOutlet UILabel  *day;
    IBOutlet UILabel  *week;
    IBOutlet UILabel *time;
    IBOutlet UILabel  *title;
    UIImage *thumbnail;
    
    BOOL opened;
    
    id<AdvancedCellDelegate> delegate;
    NSMutableArray *badgeArray;
}
@property (nonatomic, assign)id<AdvancedCellDelegate> delegate;
@property (nonatomic, retain)UIImage *thumbnail;

@property (nonatomic, retain)IBOutlet UILabel *contentLabel;
@property (nonatomic, retain)IBOutlet UIImageView *thumbImageView;
@property (nonatomic, retain)IBOutlet UILabel  *day;
@property (nonatomic, retain)IBOutlet UILabel  *week;
@property (nonatomic, retain)IBOutlet UILabel  *title;
@property (nonatomic, retain) IBOutlet UILabel *time;

- (void)setBackgroundImageName:(NSString *)imagePath;
- (void)setData:(NSDate *)date;
- (void)setTitleStr:(NSString *)text;
- (void)setcontent:(NSString *)text;
- (void)setDayColor:(UIColor *)color;
- (void)setDiaryTag:(NSArray *)tags;
@end


@protocol AdvancedCellDelegate <UITableViewDelegate>

- (void)handleTouchOnCell:(AdvancedCell *)cell tag:(NSInteger)tag;

@end