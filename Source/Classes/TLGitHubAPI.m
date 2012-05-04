//
//  TLGitHubAPI.m
//  GitHubNotificationCenter
//
//  Created by Torsten Becker on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "TLGitHubAPI.h"
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
                NSLog(@" - dict: %@", dict);
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
