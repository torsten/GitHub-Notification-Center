//
//  TLManagedObject.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLManagedObject.h"

@implementation TLManagedObject


+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                                  limit:(NSUInteger)fetchLimit
                    includesSubentities:(BOOL)includesSubentities
                        sortDescriptors:(NSArray *)sortDescriptors
                   managedObjectContext:(NSManagedObjectContext *)moc
{
    ZAssert([[self class] respondsToSelector:@selector(entityInManagedObjectContext:)], @"Class does not have 'entityInManagedObjectContext' method to determine entity description.");

    NSEntityDescription *entityDescription = [[self class] performSelector:@selector(entityInManagedObjectContext:) withObject:moc];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = predicate;
    fetchRequest.fetchLimit = fetchLimit;
    fetchRequest.includesSubentities = includesSubentities;
    fetchRequest.sortDescriptors = sortDescriptors;
    NSError *fetchError = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&fetchError];

    if (results == nil)
    {
        ALog(@"Fetching failed with error %@, %@", fetchError, [fetchError userInfo]);
        return nil;
    }

    return results;
}


+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                        sortDescriptors:(NSArray *)sortDescriptors
                   managedObjectContext:(NSManagedObjectContext *)moc
{
    return [[self class] fetchEntitiesWithPredicate:predicate
                                              limit:0
                                includesSubentities:YES
                                    sortDescriptors:sortDescriptors
                               managedObjectContext:moc];
}


+ (NSArray *)fetchEntitiesWithPredicate:(NSPredicate *)predicate
                   managedObjectContext:(NSManagedObjectContext *)moc
{
    return [[self class] fetchEntitiesWithPredicate:predicate sortDescriptors:nil managedObjectContext:moc];
}


// Request one (!) entity from data store. Failes in case more than one is fetched.
+ (id)fetchEntityWithPredicate:(NSPredicate *)predicate
          managedObjectContext:(NSManagedObjectContext *)moc
{
    ZAssert(moc, @"Managed object context must not be `nil`.");

    // Limit number of fetched items. Supposed to improve performance on SQLite store.
    // c.f. http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreData/Articles/cdPerformance.html#//apple_ref/doc/uid/TP40003468
    NSArray *results = [[self class] fetchEntitiesWithPredicate:predicate
                                                          limit:1
                                            includesSubentities:YES
                                                sortDescriptors:nil
                                           managedObjectContext:moc];

    if (results.count == 0)
    {
        return nil;
    }
    else if (results.count == 1)
    {
        return [results objectAtIndex:0];
    }
    else
    {
        ALog(@"Muliple objects fetched altough only a single one was expected.");
        return nil;
    }
}


@end
