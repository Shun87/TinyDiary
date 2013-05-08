//
//  iCloudAccess.m
//  iDiary
//
//  Created by  on 13-2-20.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "DocumentsAccess.h"
#import "FilePath.h"

@interface DocumentsAccess()
@property (readwrite)BOOL iCloudAvailable;
@property (nonatomic, retain)NSMetadataQuery *query;
@end

@implementation DocumentsAccess
@synthesize iCloudAvailable, ubiquityURL, query;

- (void)delloc
{
    [query release];
    [ubiquityURL release];
    [super dealloc];
}

- (id)initWithDelegate:(id<DocumentsAccessDelegate>) aDelegate
{
    if (self = [super init])
    {
        delegate = aDelegate;
        uploadToiCloud = NO;
    }
    
    return self;
}

- (void)initializeiDocAccess:(void (^)(BOOL available))completion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        iCloudAvailable = (ubiquityURL != nil);
        if (ubiquityURL != nil) 
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(TRUE);
            });            
        }            
        else 
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(FALSE);
            });
        }
    });
}

- (void)startQueryForPattern:(NSString *)pattern
{
    if (self.iCloudAvailable)
    {
        [self stopQuery];
        
        self.query = [[[NSMetadataQuery alloc] init] autorelease];
        [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        
        // Add a predicate for finding the documents
        [query setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",
                             NSMetadataItemFSNameKey, pattern]];
        
        // 不要UPDATA吧 每次去QUERY
        // 再icloud和local中切换的时候， 发现NSMetadataQueryDidUpdateNotification和NSMetadataQueryDidFinishGatheringNotification查询的结果不一致。
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(queryDidUpdataGathering:)
//                                                     name:NSMetadataQueryDidUpdateNotification
//                                                   object:query];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryDidFinishGathering:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:query];
        
        [query startQuery];
    }
}

- (void)queryDidUpdataGathering:(NSNotification *)notification
{
    NSMetadataQuery *aQuery = [notification object];
    
    // Always disable updates while processing results.
    [aQuery disableUpdates];

    //if (uploadToiCloud)
    {
        // 如果一开始就是再icloud上就不要去更新列表。如果是从本地上传到icloud则需要更新， 直接进finished即可.
        NSLog(@"queryDidUpdataGathering %d", [aQuery resultCount]);
        if (delegate != nil && [delegate respondsToSelector:@selector(queryDidFinished:)])
        {
            [delegate queryDidFinished:[aQuery results]];
        }
    }
    
    [aQuery enableUpdates];
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    
    NSMetadataQuery *aQuery = [notification object];
    NSLog(@"queryDidFinishGathering %d", [aQuery resultCount]);
    // Always disable updates while processing results.
    [aQuery disableUpdates];

    if (delegate != nil && [delegate respondsToSelector:@selector(queryDidFinished:)])
    {
        [delegate queryDidFinished:[aQuery results]];
    }
    
    // Reenable query updates.
    [aQuery enableUpdates];
}

- (void)stopQuery
{
    if (query) {
        
        NSLog(@"No longer watching iCloud dir...");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:nil];
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidUpdateNotification object:nil];
        [query stopQuery];
        self.query = nil;
    }
    //[query stopQuery];
}

- (void)enableQuery:(BOOL)enable
{
    if (enable)
    {
        [query enableUpdates];
    }
    else
    {
        [query disableUpdates];
    }
}

- (void)localToiCloud:(NSString *)fileExtension completion:(void (^)(NSArray *fileArray))completion
{
    NSArray *localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[FilePath localDocumentsDirectoryURL]
                                                            includingPropertiesForKeys:nil
                                                                               options:0
                                                                                 error:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *destArray = [NSMutableArray array];
    for (int i=0; i < [localDocuments count]; i++) 
    {
        NSURL * fileURL = [localDocuments objectAtIndex:i];
        if ([[fileURL pathExtension] isEqualToString:fileExtension]) 
        {
            NSString *fileName = [fileURL lastPathComponent];
            NSURL * docsDir = [ubiquityURL URLByAppendingPathComponent:@"Documents" isDirectory:YES];
            NSURL *destURL = [docsDir URLByAppendingPathComponent:fileName];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                NSError * error;
                BOOL success = [[NSFileManager defaultManager] setUbiquitous:YES
                                                                   itemAtURL:fileURL 
                                                              destinationURL:destURL 
                                                                       error:&error];
                if (!success)
                {
                    NSLog(@"Failed to move %@ to %@: %@", fileURL, destURL, error.localizedDescription); 
                }
                else
                {
                    [destArray addObject:destURL];
                    completion(destArray);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        uploadToiCloud = YES;
                    });
                }
            });
        }
    }
}

- (void)iCloudToLocal:(NSString *)fileExtension completion:(void (^)(NSArray *fileArray))completion
{
//    [self.query stopQuery];
//    
//    NSURL *iCloudDocURL = [ubiquityURL URLByAppendingPathComponent:@"Documents" isDirectory:YES];
//    NSArray *iCloudDocs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:iCloudDocURL
//                                                            includingPropertiesForKeys:nil
//                                                                               options:0
//                                                                                 error:nil];
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    NSMutableArray *destArray = [NSMutableArray array];
//    for (int i=0; i < [iCloudDocs count]; i++) 
//    {
//        NSURL * fileURL = [iCloudDocs objectAtIndex:i];
//        if ([[fileURL pathExtension] isEqualToString:fileExtension]) 
//        {
//            NSString *fileName = [fileURL lastPathComponent];
//            NSURL * docsDir = [FilePath localDocumentsDirectoryURL];
//            NSURL *destURL = [docsDir URLByAppendingPathComponent:fileName];
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                NSError * error;
//                BOOL success = [[NSFileManager defaultManager] setUbiquitous:NO
//                                                                   itemAtURL:fileURL 
//                                                              destinationURL:destURL 
//                                                                       error:&error];
//                if (success)
//                {
//                    [mutableArray addObject:fileURL];
//                    [destArray addObject:destURL];
//                    if ([mutableArray count] == [iCloudDocs count])
//                    {
//                        completion(destArray);
//                    }
//                }
//                else
//                {
//                    NSLog(@"Failed to move %@ to %@: %@", fileURL, destURL, error.localizedDescription); 
//                }
//            });
//        }
//    }
}

- (void)deleteFile:(NSURL *)url
{
    // Wrap in file coordinator
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        [fileCoordinator coordinateWritingItemAtURL:url
                                            options:NSFileCoordinatorWritingForDeleting
                                              error:nil
                                         byAccessor:^(NSURL* writingURL) {
                                             // Simple delete to start
                                             NSFileManager* fileManager = [[NSFileManager alloc] init];
                                             [fileManager removeItemAtURL:writingURL error:nil];
                                         }];
    });
}

- (NSURL *)iCloudDocURL
{
    return [self.ubiquityURL URLByAppendingPathComponent:@"Documents" isDirectory:YES];
}

- (BOOL)iCloudOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudOn"];
}

- (void)setiCloudOn:(BOOL)on
{    
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)iCloudWasOn 
{    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"];
}

- (void)setiCloudWasOn:(BOOL)on 
{    
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudWasOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)iCloudPrompted 
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudPrompted"];
}

- (void)setiCloudPrompted:(BOOL)prompted 
{    
    [[NSUserDefaults standardUserDefaults] setBool:prompted forKey:@"iCloudPrompted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
