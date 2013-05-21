//
//  CalendarViewController.h
//  TinyDiaryPro
//
//  Created by  on 13-5-14.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"

@interface CalendarViewController : UIViewController
{
    KalViewController *kalViewController;
    NSMutableArray *dayDiaryArray;
}
@end
