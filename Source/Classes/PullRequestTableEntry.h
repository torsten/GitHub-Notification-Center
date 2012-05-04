//
//  PullRequestTableEntry.h
//  GitHubNotificationCenter
//
//  Created by Kristijan Simic on 04.05.12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PullRequestTableEntry : NSTableCellView

@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestName;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestDescription;
@property (nonatomic, strong, readwrite) IBOutlet NSImageView *pullRequestAuthorImage;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestAuthorName;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestOriginRepo;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestCommentCount;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestCommitCount;
@property (nonatomic, strong, readwrite) IBOutlet NSTextField *pullRequestNumber;

@end
