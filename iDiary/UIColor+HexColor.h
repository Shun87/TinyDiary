//
//  UIColor+HexColor.h
//  Text2Group
//
//  Created by chenshun on 13-4-13.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TableViewBKColor 0xe1e1e1
#define SeperatorColor  0xe3e3e3
#define BlueNavigationBar 0x1a7cc5

#define LightGray 0xe3e3e3
#define Light_blue 0x455e7e

@interface UIColor (HexColor)

+ (UIColor *)colorFromHex:(NSInteger) value;

@end
