//
//  TLCoreData.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLCoreData : NSObject

+ (NSManagedObjectContext *)mainManagedObjectContext;
+ (void)deleteDatabase;

@end
