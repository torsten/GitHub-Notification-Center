//
//  TLGitHubAPI.m
//  GitHubNotificationCenter
//
//  Created by Torsten Becker on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLAuthor.h"
#import "TLComment.h"
#import "TLCommit.h"
#import "TLGitHubAPI.h"
#import "TLPullRequest.h"
#import <UAGithubEngine/UAGithubEngine.h>


@interface TLGitHubAPI ()

@property (nonatomic, strong) UAGithubEngine *engine;
@property (nonatomic, strong) NSArray *reposToWatch;

@end


// ------------------------------------------------------------------------------------------


@implementation TLGitHubAPI

@synthesize engine = _engine;
@synthesize reposToWatch = _reposToWatch;


- (id)init
{
    if ((self = [super init]))
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSString *user = [defaults stringForKey:@"TLUserName"];
        NSString *pw = [defaults stringForKey:@"TLPassword"];
        NSArray *repos = [defaults stringArrayForKey:@"TLRepoList"];

        self.engine = [[UAGithubEngine alloc] initWithUsername:user password:pw withReachability:YES];
        self.reposToWatch = repos;
    }

    return self;
}

- (void)generateDummies
{
    //TLPullRequest *pullRequest = [TLPullRequest insertInManagedObjectContext:moc];
}

- (void)updateIntoMOC:(NSManagedObjectContext *)moc
{
    for (NSString *repo in self.reposToWatch)
    {
        [self.engine pullRequestsForRepository:repo
        success:^(id thing)
        {
            NSLog(@"requests: %@", [thing class]);
            NSArray *pullRequests = (NSArray *)thing;

            for (NSDictionary *dict in pullRequests)
            {
                // TLAuthor:
                // avatarURL, email, name
                
                // TLPullRequest *pullRequest = [TLPullRequest insertInManagedObjectContext:moc];
                
                // date, url, (author), 
                // label, comments, commits
                
                // pullRequest.text = self.editingView.textView.text;
                // pullRequest.tags = self.tagsForNewNote;
                // pullRequest.owner = [WKWorkspace personalWorkspace];
                // pullRequest.workspace = self.workspace;
                // pullRequest.orderIndexValue = self.note.newOrderIndex;
               
//                TLPullRequest *pullRequest = [TLPullRequest ];

                
                
                NSString *url = [dict objectForKey:@"html_url"];
                NSString *date = [dict objectForKey:@"created_at"]; // 2012-05-03T17:22:24Z
                NSString *label = [dict objectForKey:@"title"];
                NSString *number = [dict objectForKey:@"number"];
                
                NSLog(@" - label: %@", label);
                NSLog(@" - pull#: %@", number);
                NSLog(@" - date: %@", date);
                NSLog(@" - url: %@", url);
                
                
                // user =     {
                //     "avatar_url" = "https://secure.gravatar.com/avatar/7bce86ef594d03d98383f9a9d842d32d?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png";
                //     "gravatar_id" = 7bce86ef594d03d98383f9a9d842d32d;
                //     id = 13548;
                //     login = torsten;
                //     url = "https://api.github.com/users/torsten";
                // };
                NSDictionary *userDict = [dict objectForKey:@"user"];
                
                
//                NSLog(@" - dict: %@", dict);
            }
        }
        failure:^(NSError * err)
        {
            NSLog(@"Repo fetch fail: %@", err);
        }];
    }
}



// [engine pullRequestsForRepository:@"6wunderkinder/wunderkit-clientapi"
//                      success:^(id thing)
//                      {
//                          NSLog(@"success: %@", thing);
//                      }
//                      failure:^(NSError * err)
//                      {
//                          NSLog(@"fail: %@", err);
//                      }];


// [engine commitsInPullRequest:34 forRepository:@"6wunderkinder/wunderkit-clientapi"
//                      success:^(id thing)
//                      {
//                          NSLog(@"success: %@", thing);
//                      }
//                      failure:^(NSError * err)
//                      {
//                          NSLog(@"fail: %@", err);
//                      }];

// [engine commitCommentsForCommit:@"b902495df8e27f87311ffae187657bd47d5d7266" inRepository:@"6wunderkinder/wunderkit-clientapi"
//                      success:^(id thing)
//                      {
//                          NSLog(@"success: %@", thing);
//                      }
//                      failure:^(NSError * err)
//                      {
//                          NSLog(@"fail: %@", err);
//                      }];



// [engine :(NSInteger)pullRequestId forRepository:(NSString *)repositoryPath success:(UAGithubEngineSuccessBlock)successBlock failure:(UAGithubEngineFailureBlock)failureBlock];

// [engine commentsForIssue:34 forRepository:@"6wunderkinder/wunderkit-clientapi"
//                      success:^(id thing)
//                      {
//                          NSLog(@"success: (%@) %@", [thing class], thing);
//                      }
//                      failure:^(NSError * err)
//                      {
//                          NSLog(@"fail: %@", err);
//                      }];


@end
