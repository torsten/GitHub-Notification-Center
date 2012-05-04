//
//  TLAppDelegate.h
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TLAppDelegate : NSObject <NSApplicationDelegate, NSSplitViewDelegate, NSTableViewDelegate>
{
    NSMutableArray *_pullRequestData;
    BOOL switchSidebar;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSManagedObjectContext *mainManagedObjectContext;

@property (readwrite, strong, nonatomic) IBOutlet NSSplitView *splitView;
@property (readwrite, strong, nonatomic) IBOutlet NSView *masterView;
@property (readwrite, strong, nonatomic) IBOutlet NSView *detailView;

@property (readwrite, strong, nonatomic) IBOutlet NSTableView *pullRequestTable;
@property (readwrite, strong, nonatomic) IBOutlet NSArrayController *pullRequestsArrayController;

- (IBAction)toggleSidebar:(id)sender;

@end
