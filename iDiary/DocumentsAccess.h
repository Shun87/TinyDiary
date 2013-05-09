//
//  iCloudAccess.h
//  iDiary
//
//  Created by  on 13-2-20.
//  Copyright (c) 2013年 ;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DocumentsAccessDelegate;

@interface DocumentsAccess : NSObject
{
    NSURL *ubiquityURL;
    BOOL iCloudAvailable;
    NSMetadataQuery *query;
    
    id<DocumentsAccessDelegate> delegate;
    BOOL uploadToiCloud;
}
@property (readonly)BOOL iCloudAvailable;
@property (nonatomic, retain)NSURL *ubiquityURL;

- (id)initWithDelegate:(id<DocumentsAccessDelegate>) aDelegate;
- (void)initializeiDocAccess:(void (^)(BOOL available))completion;
- (void)startQueryForPattern:(NSString *)pattern;

- (NSURL *)iCloudDocURL;

// move
- (void)localToiCloud:(NSString *)fileExtension completion:(void (^)(NSArray *fileArray))completion;
- (void)iCloudToLocal:(NSString *)fileExtension completion:(void (^)(NSArray *fileArray))completion;

// delete
- (void)deleteFile:(NSURL *)url;

- (void)stopQuery;
- (void)enableQuery:(BOOL)enable;

// flags
- (BOOL)iCloudOn;
- (void)setiCloudOn:(BOOL)on;
- (BOOL)iCloudWasOn;
- (void)setiCloudWasOn:(BOOL)on;
- (BOOL)iCloudPrompted;
- (void)setiCloudPrompted:(BOOL)prompted;
@end

@protocol DocumentsAccessDelegate <NSObject>

- (void)queryDidFinished:(NSArray *)array;

@end
