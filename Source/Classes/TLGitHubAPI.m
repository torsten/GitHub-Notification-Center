//
//  TLGitHubAPI.m
//  GitHubNotificationCenter
//
//  Created by Torsten Becker on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//

#import "NSDateFormatter+Extensions.h"
#import "TLAuthor.h"
#import "TLComment.h"
#import "TLCommit.h"
#import "TLGitHubAPI.h"
#import "TLPullRequest.h"
#import "TLRepository.h"
#import <UAGithubEngine/UAGithubEngine.h>


// ------------------------------------------------------------------------------------------


@interface TLGitHubAPI ()

@property (nonatomic, strong) UAGithubEngine *engine;

/** NSArray of NSStrings */
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


- (TLAuthor *)authorWithDict:(NSDictionary *)userDict intoMOC:(NSManagedObjectContext *)moc
{
    TLAuthor *author = [TLAuthor fetchOrCreateWithID:[[userDict objectForKey:@"id"] stringValue]
                                managedObjectContext:moc];
    author.name = [userDict objectForKey:@"login"];
    author.avatarURL = [userDict objectForKey:@"avatar_url"];
    author.url = [NSString stringWithFormat:@"https://github.com/%@", author.name];

    return author;
}


- (void)updateIntoMOC:(NSManagedObjectContext *)moc
{
    for (NSString *repoName in self.reposToWatch)
    {
        [self.engine repository:repoName success:^(NSArray *repositories)
        {
            NSDictionary *dict = [repositories lastObject];

            TLRepository *repo = [TLRepository fetchOrCreateWithID:[[dict objectForKey:@"id"] stringValue]
                                              managedObjectContext:moc];
            repo.name = repoName;
            repo.created_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            repo.updated_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];
            repo.url = [dict objectForKey:@"html_url"];

            [self updatePullRequestsForRepository:repo intoMOC:moc];
            [moc saveChanges];
        }
        failure:^(NSError *err)
        {
            NSLog(@"Repo fetch fail: %@", err);
        }];
    }
}


- (void)updatePullRequestsForRepository:(TLRepository *)repo
                                intoMOC:(NSManagedObjectContext *)moc
{
    [self.engine pullRequestsForRepository:repo.name success:^(NSArray *pullRequests)
    {
        // NSLog(@"pull reqest success: (%@) %@", [pullRequests class], pullRequests);

        for (NSDictionary *dict in pullRequests)
        {
            NSString *githubID = [[dict objectForKey:@"id"] stringValue];

            TLAuthor *author = [self authorWithDict:[dict objectForKey:@"user"] intoMOC:moc];

            TLPullRequest *pullRequest = [TLPullRequest fetchOrCreateWithID:githubID managedObjectContext:moc];
            pullRequest.label = [dict objectForKey:@"title"];
            pullRequest.author = author;
            pullRequest.url = [dict objectForKey:@"html_url"];
            pullRequest.number = [dict objectForKey:@"number"];
            pullRequest.created_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            pullRequest.updated_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];

            [self updateCommentsForPullRequest:pullRequest inRepo:repo.name intoMOC:moc];
            [self updateCommitsForPullRequest:pullRequest inRepo:repo.name intoMOC:moc];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        NSLog(@"Pull request fail: %@", err);
    }];
}


- (void)updateCommentsForPullRequest:(TLPullRequest *)pullRequest
                              inRepo:(NSString *)repo
                             intoMOC:(NSManagedObjectContext *)moc
{
    int pullRequestNumber = pullRequest.numberValue;

    [self.engine commentsForIssue:pullRequestNumber forRepository:repo success:^(NSArray *comments)
    {
        // NSLog(@"pull request comments success: (%@) %@", [comments class], comments);

        for (NSDictionary *dict in comments)
        {
            NSDate *date = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            NSString *message = [dict objectForKey:@"body"];
            int commentId = [[dict objectForKey:@"id"] intValue];
            NSString *url = [NSString stringWithFormat:@"https://github.com/%@/pull/%d#issuecomment-%d",
                                                       repo, pullRequestNumber, commentId];

            NSLog(@"   - id: %d", commentId);
            NSLog(@"   - message: %@", message);
            NSLog(@"   - date: %@", date);
            NSLog(@"   - url: %@", url);

            NSDictionary *userDict = [dict objectForKey:@"user"];
            TLAuthor *author = [self authorWithDict:userDict intoMOC:moc];

            TLComment *pullRequestComment = [TLComment fetchOrCreateWithID:[[dict objectForKey:@"id"] stringValue]
                                                      managedObjectContext:moc];
            pullRequestComment.message = message;
            pullRequestComment.url = url;
            pullRequestComment.author = author;
            pullRequestComment.created_at = date;

            [pullRequest addCommentsObject:pullRequestComment];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        NSLog(@"Pull comment fetch fail: %@", err);
    }];
}


- (void)updateCommitsForPullRequest:(TLPullRequest *)pullRequest
                             inRepo:(NSString *)repo
                            intoMOC:(NSManagedObjectContext *)moc
{
    int pullRequestNumber = pullRequest.numberValue;

    [self.engine commitsInPullRequest:pullRequestNumber forRepository:repo
    success:^(id thing)
    {
        // NSLog(@"commit success: (%@) %@", [thing class], thing);
        // (__NSArrayM) (
        //         {
        //         author =         {
            // ...
        //         };
        //         commit =         {
        //             author =             {
        //                 date = "2012-05-03T07:23:23-07:00";
        //                 email = "torsten.becker@gmail.com";
        //                 name = "Torsten Becker";
        //             };
        //             committer =             {
        //                 date = "2012-05-03T07:23:23-07:00";
        //                 email = "torsten.becker@gmail.com";
        //                 name = "Torsten Becker";
        //             };
        //             message = "Do not attempt to delete any database files if we have an in-memory store.";
        //             tree =             {
        //                 sha = d4...;
        //                 url = "https://api.github.com/repos/6wunderkinder/.../git/trees/d43...";
        //             };
        //             url = "https://api.github.com/repos/6wunderkinder/.../git/commits/83e...";
        //         };
        //         committer =         {
        //             "avatar_url" = "https://secure.gravatar.com/avatar/7b...?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png";
        //             "gravatar_id" = 7bce86ef594d03d98383f9a9d842d32d;
        //             id = 13548;
        //             login = torsten;
        //             url = "https://api.github.com/users/torsten";
        //         };
        //         parents =         (
        //                         {
        //                 sha = 61...;
        //                 url = "https://api.github.com/repos/6wunderkinder/.../commits/61...";
        //             }
        //         );
        //         sha = 83...;
        //         url = "https://api.github.com/repos/6wunderkinder/.../commits/83...";
        //     },
        // ....



        NSArray *commits = (NSArray *)thing;

        for (NSDictionary *dict in commits)
        {
            // date, url, (author),
            // message

            NSString *sha = [dict objectForKey:@"sha"];
            NSString *message = [[dict objectForKey:@"commit"] objectForKey:@"message"];

            NSString *dateString = [[[dict objectForKey:@"commit"] objectForKey:@"author"] objectForKey:@"date"];
            NSDate *date = [NSDateFormatter dateFromRFC3339String:dateString];

            NSLog(@"   - sha: %@", sha);
            NSLog(@"   - message: %@", message);
            NSLog(@"   - date: %@", date);

            TLCommit *commit = [TLCommit fetchOrCreateWithID:sha managedObjectContext:moc];
            commit.message = message;
            commit.url = [NSString stringWithFormat:@"https://github.com/%@/commit/%@", repo, sha];
            commit.created_at = date;

            [pullRequest addCommitsObject:commit];

            [self updateCommentsForCommit:commit inRepo:repo intoMOC:moc];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        NSLog(@"Commit fetch fail: %@", err);
    }];
}


- (void)updateCommentsForCommit:(TLCommit *)commit
                         inRepo:(NSString *)repo
                        intoMOC:(NSManagedObjectContext *)moc
{
    NSString *sha = commit.githubID;

    [self.engine commitCommentsForCommit:sha inRepository:repo
    success:^(id thing)
    {
        // NSLog(@"commit comment success: (%@) %@", [thing class], thing);
        //  (__NSArrayM) (
        //         {
        //         body = "Test comment in commit ";
        //         "commit_id" = ;
        //         "created_at" = "2012-05-04T11:20:46Z";
        //         "html_url" = ""https://github.com/6wunderkinder/.../commit/b90...#commitcomment-1291705"";
        //         id = 1291705;
        //         line = 67;
        //         path = "Source/Classes/....h";
        //         position = 5;
        //         "updated_at" = "2012-05-04T11:20:46Z";
        //         url = "https://api.github.com/repos/6wunderkinder/.../comments/1291705";
        //         user =         {
        //         };
        //     },
        //         {
        //         body = "?";
        //         "commit_id" = b902495df8e27f87311ffae187657bd47d5d7266;
        //         "created_at" = "2012-05-04T11:55:47Z";
        //         "html_url" = "https://github.com/6wunderkinder/.../commit/b90...#commitcomment-1291843";
        //         id = 1291843;
        //         line = 67;
        //         path = "Source/Classes/WKAPIMacros.h";
        //         position = 5;
        //         "updated_at" = "2012-05-04T11:55:47Z";
        //         url = "https://api.github.com/repos/6wunderkinder/.../comments/1291843";
        //         user =         {
        //         };
        //     }
        // )

        NSArray *commitComments = (NSArray *)thing;

        for (NSDictionary *dict in commitComments)
        {
            NSString *message = [dict objectForKey:@"body"];
            NSString *githubID = [[dict objectForKey:@"id"] stringValue];
            NSDate *date = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];

            TLComment *commitComment = [TLComment fetchOrCreateWithID:githubID managedObjectContext:moc];
            commitComment.message = message;
            commitComment.url = [NSString stringWithFormat:@"https://github.com/%@/commit/%@#commitcomment-%@",
                                                           repo, sha, githubID];
            commitComment.updated_at = date;

            [commit addCommentsObject:commitComment];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        NSLog(@"Commit comment fetch fail: %@", err);
    }];
}


@end
