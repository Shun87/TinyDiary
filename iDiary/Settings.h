//
//  Settings.h
//  iDiary
//
//  Created by  on 13-2-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : NSObject
{
    BOOL psdProtectOn;
    BOOL iCloudOn;
}

@property (nonatomic, assign)BOOL psdProtectOn;
@property (nonatomic, assign)BOOL iCloudOn;

@end
