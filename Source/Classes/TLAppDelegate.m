//
//  TLAppDelegate.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLGitHubAPI.h"


@interface TLAppDelegate()

@property (nonatomic, strong) TLGitHubAPI *api;

@end


#define SIDEBAR_WIDTH 395

@implementation TLAppDelegate

@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;

@synthesize splitView;
@synthesize masterView;
@synthesize detailView;

@synthesize pullRequestTable;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    self.api = [[TLGitHubAPI alloc] init];
    [self.api updateIntoMOC:self.managedObjectContext];

    _pullRequestData = [[NSMutableArray alloc] initWithCapacity:0];
    [self.pullRequestTable reloadData];

    switchSidebar = NO;
    [self.splitView adjustSubviews];

    // [self.api generateDummiesIntoMOC:self.managedObjectContext];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.torsten-and-lars.GitHubNotificationCenter" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.torsten-and-lars.GitHubNotificationCenter"];
}

// ------------------------------------------------------------------------------------------
#pragma mark - NSSplitView Delegate implementation
// ------------------------------------------------------------------------------------------

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    float dividerThickness = [sender dividerThickness];

    NSRect newFrame = [sender frame];
    NSRect leftFrame = [[[sender subviews] objectAtIndex:0] frame];
    NSRect rightFrame = [[[sender subviews] objectAtIndex:1] frame];

    if ([self.masterView isHidden]) {
        rightFrame.size.width = newFrame.size.width;
        rightFrame.size.height = newFrame.size.height;
        rightFrame.origin.x = 0;

        [[[sender subviews] objectAtIndex:1] setFrame:rightFrame];
    }
    else {
        leftFrame.size.width = leftFrame.size.width;
        leftFrame.size.height = newFrame.size.height;
        leftFrame.origin = NSMakePoint(0, 0);
        rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
        rightFrame.size.height = newFrame.size.height;
        rightFrame.origin.x = leftFrame.size.width + dividerThickness;

        [[[sender subviews] objectAtIndex:0] setFrame:leftFrame];
        [[[sender subviews] objectAtIndex:1] setFrame:rightFrame];
    }
}

- (NSRect)splitView:(NSSplitView *)splitView
      effectiveRect:(NSRect)proposedEffectiveRect
       forDrawnRect:(NSRect)drawnRect
   ofDividerAtIndex:(NSInteger)dividerIndex
{
    return NSMakeRect(0, 0, 0, 0);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
    return YES;
}

// ------------------------------------------------------------------------------------------
#pragma mark - Sidebar Actions
// ------------------------------------------------------------------------------------------

- (IBAction)toggleSidebar:(id)sender
{
    NSView *contentView = [self.splitView.subviews objectAtIndex:1];

    NSRect sidebarTargetFrame = NSMakeRect(self.splitView.frame.origin.x,
                                           self.splitView.frame.origin.y,
                                           switchSidebar ? SIDEBAR_WIDTH : 0 - self.splitView.dividerThickness,
                                           self.splitView.frame.size.height);

    NSRect contenTargetFrame = NSMakeRect(switchSidebar ? SIDEBAR_WIDTH : 0  - self.splitView.dividerThickness,
                                          contentView.frame.origin.y,
                                          NSMaxX(contentView.frame) - switchSidebar ? SIDEBAR_WIDTH : 0,
                                          contentView.frame.size.height);

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.2];
    [[self.splitView animator] setFrame: sidebarTargetFrame];
    [[contentView animator] setFrame: contenTargetFrame];
    [NSAnimationContext endGrouping];

    switchSidebar = !switchSidebar;
}


// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel) {
        return __managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GitHubNotificationCenter" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;

    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];

    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];

            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }

    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"GitHubNotificationCenter.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = coordinator;

    return __persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.

    if (!__managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];

        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
