//
//  TLManagedObject.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TLManagedObject : NSManagedObject


+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                                  limit:(NSUInteger)fetchLimit
                    includesSubentities:(BOOL)includesSubentities
                        sortDescriptors:(NSArray *)sortDescriptors
                   managedObjectContext:(NSManagedObjectContext *)moc;

+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                        sortDescriptors:(NSArray *)sortDescriptors
                   managedObjectContext:(NSManagedObjectContext *)moc;

+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                   managedObjectContext:(NSManagedObjectContext *)moc;

+ (id)fetchEntityWithPredicate:(NSPredicate *)predicate
          managedObjectContext:(NSManagedObjectContext *)moc;


@end
