//
//  Settings.m
//  iDiary
//
//  Created by  on 13-2-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "Settings.h"

#define kPsdOn  @"psdOn"
#define kCloudOn  @"cloudOn"

@implementation Settings
@synthesize psdProtectOn, iCloudOn;

- (id)init
{
    if (self = [super init])
    {
        self.psdProtectOn = [[[NSUserDefaults standardUserDefaults] objectForKey:kPsdOn] boolValue];
        self.iCloudOn = [[[NSUserDefaults standardUserDefaults] objectForKey:kCloudOn] boolValue];
    }
    
    return self;
}

- (void)setICloudOn:(BOOL)on
{
    iCloudOn = on;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", self.iCloudOn] forKey:kCloudOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPsdProtectOn:(BOOL)on
{
    psdProtectOn = on;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", self.psdProtectOn] forKey:kPsdOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
