//
//  PullRequestTableEntry.m
//  GitHubNotificationCenter
//
//  Created by Kristijan Simic on 04.05.12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "PullRequestTableEntry.h"

@implementation PullRequestTableEntry

@synthesize pullRequestName;
@synthesize pullRequestDescription;
@synthesize pullRequestAuthorImage;
@synthesize pullRequestAuthorName;
@synthesize pullRequestOriginRepo;
@synthesize pullRequestCommentCount;
@synthesize pullRequestCommitCount;
@synthesize pullRequestNumber;

- (void)setObjectValue:(id)objectValue
{
	[super setObjectValue:objectValue];
}

@end
