//
//  TLAppDelegate.m
//  GitHubNotificationCenter
//
//  Created by Lars Schneider on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLGitHubAPI.h"
#import "PullRequestTableEntry.h"

#import "TLPullRequest.h"
#import "TLAuthor.h"
#import "TLCoreData.h"

@interface TLAppDelegate()

@property (nonatomic, strong) TLGitHubAPI *api;

@end


#define SIDEBAR_WIDTH 395

@implementation TLAppDelegate

@synthesize window = _window;
@synthesize api = _api;

@synthesize splitView;
@synthesize masterView;
@synthesize detailView;

@synthesize pullRequestTable;
@synthesize pullRequestsArrayController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    self.api = [[TLGitHubAPI alloc] init];
    [self.api updateIntoMOC:[TLCoreData mainManagedObjectContext]];

    [self.pullRequestTable reloadData];

    switchSidebar = NO;
    [self.splitView adjustSubviews];
}


/// Proxy for Interface builder
- (NSManagedObjectContext *)mainManagedObjectContext
{
    return [TLCoreData mainManagedObjectContext];
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {


    PullRequestTableEntry *result = (PullRequestTableEntry *) [tableView makeViewWithIdentifier:@"PullRequest" owner:self];
    result.frame = NSMakeRect(0, 0, 395, 90);

    TLPullRequest *pullRequest = [self.pullRequestsArrayController.arrangedObjects objectAtIndex:row];

    [result.pullRequestName bind:@"value" toObject:pullRequest withKeyPath:@"label" options:nil];
    [result.pullRequestDescription bind:@"value" toObject:pullRequest withKeyPath:@"pullRequestDescription" options:nil];
    [result.pullRequestAuthorName bind:@"value" toObject:pullRequest.author withKeyPath:@"name" options:nil];
    // [result.pullRequestOriginRepo bind:@"value" toObject:pullRequest.repository withKeyPath:@"name" options:nil];

    if (!result.pullRequestAuthorImage.image) {
        dispatch_queue_t queue = dispatch_queue_create("GitHubNotificationCenter",NULL);

        dispatch_async(queue,^{
            NSImage *newImage;
            NSURL *imageURL = [NSURL URLWithString:pullRequest.author.avatarURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            if (imageData != nil) {
                newImage = [[NSImage alloc] initWithData:imageData];
                [result.pullRequestAuthorImage setImage:newImage];
            }
        });
    }

    result.pullRequestCommentCount.stringValue = [NSString stringWithFormat:@"Comments %ld", pullRequest.comments.count];
    result.pullRequestCommitCount.stringValue = [NSString stringWithFormat:@"Commits %ld", pullRequest.commits.count];

    // return the result.
    return result;
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


@end
