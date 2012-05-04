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


- (void)generateDummiesIntoMOC:(NSManagedObjectContext *)moc
{
    // TLPullRequest *pullRequest = [TLPullRequest insertInManagedObjectContext:moc];
}


- (void)updateIntoMOC:(NSManagedObjectContext *)moc
{
    for (NSString *repo in self.reposToWatch)
    {
        [self.engine pullRequestsForRepository:repo
        success:^(id thing)
        {
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
                int number = [[dict objectForKey:@"number"] intValue];
                
                NSLog(@" - label: %@", label);
                NSLog(@" - pull#: %d", number);
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
                
                [self updateCommentsForPullRequest:number inRepo:repo intoPullRequest:nil];
                
                // NSLog(@"pull req success: (%@) %@", [thing class], thing);
            }
        }
        failure:^(NSError * err)
        {
            NSLog(@"Repo fetch fail: %@", err);
        }];
    }
}


- (void)updateCommentsForPullRequest:(int)pullRequestId
                              inRepo:(NSString *)repo
                     intoPullRequest:(TLPullRequest *)pullRequest
{
    [self.engine commentsForIssue:pullRequestId forRepository:repo
    success:^(id thing)
    {
        // NSLog(@"pull comment success: (%@) %@", [thing class], thing);
        // (__NSArrayM) (
        //         {
        //         body = "Test comment on pull request";
        //         "created_at" = "2012-05-04T11:20:29Z";
        //         id = 5508406;
        //         "updated_at" = "2012-05-04T11:21:55Z";
        //         url = "https://api.github.com/repos/6wunderkinder/wunderkit-clientapi/issues/comments/5508406";
        //     }
        // )
        
        NSArray *comments = (NSArray *)thing;

        for (NSDictionary *dict in comments)
        {
            // date, url, (author), 
            // message
            
            NSString *date = [dict objectForKey:@"created_at"]; // 2012-05-04T11:20:29Z
            NSString *message = [dict objectForKey:@"body"];
            int commentId = [[dict objectForKey:@"id"] intValue];
            NSString *url = [NSString stringWithFormat:@"https://github.com/%@/pull/%d#issuecomment-%d",
                                                       repo, pullRequestId, commentId];

            NSLog(@"   - id: %d", commentId);
            NSLog(@"   - message: %@", message);
            NSLog(@"   - date: %@", date);
            NSLog(@"   - url: %@", url);
            
            
            NSDictionary *userDict = [dict objectForKey:@"user"];
            // user =         {
            //     "avatar_url" = "https://secure.gravatar.com/avatar/7bce86ef594d03d98383f9a9d842d32d?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png";
            //     "gravatar_id" = 7bce86ef594d03d98383f9a9d842d32d;
            //     id = 13548;
            //     login = torsten;
            //     url = "https://api.github.com/users/torsten";
            // };
        }
    }
    failure:^(NSError * err)
    {
        NSLog(@"Pull comment fetch fail: %@", err);
    }];
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



@end
