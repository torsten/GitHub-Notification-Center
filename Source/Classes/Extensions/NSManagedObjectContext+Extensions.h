//
//  NSManagedObjectContext+Extensions.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 11/7/11.
//  Copyright (c) 2011 6Wunderkinder. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (Extensions)

- (void)saveChanges;
- (void)discardChanges;

@end
