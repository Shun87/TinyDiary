//
//  PlistDocument.h
//  TinyDiaryPro
//
//  Created by  on 13-5-15.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlistDocument : UIDocument
{
    NSMutableDictionary *plistDic;
}
@property (nonatomic, retain)NSMutableDictionary *plistDic;

- (void)addItem:(NSDictionary *)dictionary forName:(NSString *)name;
@end
