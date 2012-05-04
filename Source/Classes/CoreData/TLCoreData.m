//
//  TLCoreData.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLCoreData.h"


NSString *const kTLDatabaseModelFileName = @"GitHubNotificationCenter";
NSString *const kTLDatabaseModelFolder = @"GitHubNotificationCenter";


@interface TLCoreData ()
{
    NSManagedObjectModel            *_managedObjectModel;
    NSManagedObjectContext          *_managedObjectContext;
    NSPersistentStoreCoordinator    *_persistentStoreCoordinator;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectModel;


- (void)initManagedObjectModel;
- (void)initPersistentStoreCoordinator;
- (void)initMainManagedObjectContext;

- (void)contextDidSave:(NSNotification *)notification;

@end


@implementation TLCoreData


@synthesize managedObjectModel = _managedObjectContext;


// ------------------------------------------------------------------------------------------
#pragma mark - Singleton
// ------------------------------------------------------------------------------------------
// c.f. http://cocoasamurai.blogspot.com/2011/04/singletons-your-doing-them-wrong.html
+ (TLCoreData *)shared
{
    static dispatch_once_t pred;
    static TLCoreData *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[TLCoreData alloc] init];
    });

    return shared;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Initialization
// ------------------------------------------------------------------------------------------
- (id)init
{
    if ((self = [super init]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];

        [self initManagedObjectModel];
        [self initPersistentStoreCoordinator];
        [self initMainManagedObjectContext];
    }

    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Core Data Stack
// ------------------------------------------------------------------------------------------
+ (NSURL *)persistentStoreURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *rootSupportDir = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *appSupportDir = [rootSupportDir URLByAppendingPathComponent:kTLDatabaseModelFolder];

    // Check if directory exist, try to create if not
    NSError *error = nil;
    NSDictionary *properties = [appSupportDir resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];

    if (properties == nil)
    {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError)
        {
            ok = [fileManager createDirectoryAtPath:[appSupportDir path] withIntermediateDirectories:YES attributes:nil error:&error];
        }

        if (ok == NO)
        {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] == NO)
    {
        NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [appSupportDir path]];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"Wunderkit Error" code:101 userInfo:dict];

        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }

    return [appSupportDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kTLDatabaseModelFileName]];
}


- (void)initManagedObjectModel
{
    if (_managedObjectModel == nil)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:kTLDatabaseModelFileName ofType:@"momd"];
        NSURL *momURL = [NSURL fileURLWithPath:path];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    }
}


- (void)initPersistentStoreCoordinator
{
    if ((_persistentStoreCoordinator == nil) && (_managedObjectModel != nil))
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

        NSDictionary *options = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil]
                                                            forKeys:[NSArray arrayWithObjects:NSMigratePersistentStoresAutomaticallyOption, NSInferMappingModelAutomaticallyOption, nil]];

        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:[self.class persistentStoreURL]
                                                             options:options
                                                               error:&error])
        {
            NSLog(@"Add persistent store failed with error %@, %@", error, [error userInfo]);
            _persistentStoreCoordinator = nil;
        }
    }
}


- (void)initMainManagedObjectContext
{
    if (_managedObjectContext == nil && _persistentStoreCoordinator)
    {
        ZAssert([NSThread isMainThread], @"Main MOC must be created in main thread.");
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.undoManager = nil;
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
    }
}


// ------------------------------------------------------------------------------------------
#pragma mark - Property Getter
// ------------------------------------------------------------------------------------------
+ (NSManagedObjectContext *)mainManagedObjectContext
{
    return [TLCoreData shared].managedObjectModel;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Operations
// ------------------------------------------------------------------------------------------
+ (void)deleteDatabase
{
    NSError *error = nil;

    // [NSFileManager defaultManager] is not thread-safe.
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager removeItemAtURL:[self.class persistentStoreURL] error:&error] == NO)
    {
        NSLog(@"Persistent store deletion failed with error %@, %@", error, [error userInfo]);
    }
}


- (void)reset
{
    @synchronized(self)
    {
        _managedObjectContext = nil;
        _managedObjectModel = nil;
        _persistentStoreCoordinator = nil;

        [self.class deleteDatabase];

        // Re-initialise the model and store
        [self initManagedObjectModel];
        [self initPersistentStoreCoordinator];
    }
}


// ------------------------------------------------------------------------------------------
#pragma mark - Notifications
// ------------------------------------------------------------------------------------------
// This method is called on NSManagedObjectContextDidSaveNotification. All worker threads have their
// own Managed Object Context. This method will merge the changes of these MOCs into the main thread
// MOC.
// Attention: This method is called in the context of the worker thread!
// c.f. http://www.duckrowing.com/2010/03/11/using-core-data-on-multiple-threads/
- (void)contextDidSave:(NSNotification *)notification
{
    [_managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                            withObject:notification waitUntilDone:YES];
}


@end


