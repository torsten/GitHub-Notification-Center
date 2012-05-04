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
            ALog(@"Repo fetch fail: %@", err);
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
            pullRequest.author = author;
            pullRequest.label = [dict objectForKey:@"title"];
            pullRequest.url = [dict objectForKey:@"html_url"];
            pullRequest.number = [dict objectForKey:@"number"];
            pullRequest.created_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            pullRequest.updated_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];
            pullRequest.repository = repo;

            [self updateCommentsForPullRequest:pullRequest inRepo:repo intoMOC:moc];
            [self updateCommitsForPullRequest:pullRequest inRepo:repo intoMOC:moc];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        ALog(@"Pull request fail: %@", err);
    }];
}


- (void)updateCommentsForPullRequest:(TLPullRequest *)pullRequest
                              inRepo:(TLRepository *)repo
                             intoMOC:(NSManagedObjectContext *)moc
{
    int pullRequestNumber = pullRequest.numberValue;

    [self.engine commentsForIssue:pullRequestNumber forRepository:repo.name success:^(NSArray *comments)
    {
        // NSLog(@"pull request comments success: (%@) %@", [comments class], comments);

        for (NSDictionary *dict in comments)
        {
            NSString *githubID = [[dict objectForKey:@"id"] stringValue];
            TLAuthor *author = [self authorWithDict:[dict objectForKey:@"user"] intoMOC:moc];

            TLComment *pullRequestComment = [TLComment fetchOrCreateWithID:githubID managedObjectContext:moc];
            pullRequestComment.author = author;
            pullRequestComment.message = [dict objectForKey:@"body"];
            pullRequestComment.created_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            pullRequestComment.updated_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];
            pullRequestComment.url = [NSString stringWithFormat:@"https://github.com/%@/pull/%d#issuecomment-%@",
                                                                repo.name,
                                                                pullRequestNumber,
                                                                [dict objectForKey:@"id"]];

            [pullRequest addCommentsObject:pullRequestComment];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        ALog(@"Pull comment fetch fail: %@", err);
    }];
}


- (void)updateCommitsForPullRequest:(TLPullRequest *)pullRequest
                             inRepo:(TLRepository *)repo
                            intoMOC:(NSManagedObjectContext *)moc
{
    [self.engine commitsInPullRequest:pullRequest.numberValue forRepository:repo.name success:^(NSArray *commits)
    {
        // NSLog(@"commit success: (%@) %@", [commits class], commits);

        for (NSDictionary *dict in commits)
        {
            NSString *sha = [dict objectForKey:@"sha"];
            NSString *message = [[dict objectForKey:@"commit"] objectForKey:@"message"];
            NSString *dateString = [[[dict objectForKey:@"commit"] objectForKey:@"author"] objectForKey:@"date"];
            NSDate *date = [NSDateFormatter dateFromRFC3339String:dateString];
            TLAuthor *author = [self authorWithDict:[dict objectForKey:@"author"] intoMOC:moc];

            TLCommit *commit = [TLCommit fetchOrCreateWithID:sha managedObjectContext:moc];
            commit.message = message;
            commit.created_at = date; // commits do not have updated_at
            commit.url = [NSString stringWithFormat:@"https://github.com/%@/commit/%@", repo.name, sha];
            commit.author = author;

            [pullRequest addCommitsObject:commit];

            [self updateCommentsForCommit:commit inRepo:repo intoMOC:moc];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        ALog(@"Commit fetch fail: %@", err);
    }];
}


- (void)updateCommentsForCommit:(TLCommit *)commit
                         inRepo:(TLRepository *)repo
                        intoMOC:(NSManagedObjectContext *)moc
{
    NSString *sha = commit.githubID;

    [self.engine commitCommentsForCommit:sha inRepository:repo.name success:^(NSArray *commitComments)
    {
        // NSLog(@"commit comments success: (%@) %@", [commitComments class], commitComments);

        for (NSDictionary *dict in commitComments)
        {
            NSString *githubID = [[dict objectForKey:@"id"] stringValue];
            TLAuthor *author = [self authorWithDict:[dict objectForKey:@"user"] intoMOC:moc];

            TLComment *commitComment = [TLComment fetchOrCreateWithID:githubID managedObjectContext:moc];

            commitComment.message = [dict objectForKey:@"body"];
            commitComment.url = [NSString stringWithFormat:@"https://github.com/%@/commit/%@#commitcomment-%@",
                                                           repo.name, sha, githubID];
            commitComment.created_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"created_at"]];
            commitComment.updated_at = [NSDateFormatter dateFromRFC3339String:[dict objectForKey:@"updated_at"]];
            commitComment.author = author;

            [commit addCommentsObject:commitComment];
        }

        [moc saveChanges];
    }
    failure:^(NSError * err)
    {
        ALog(@"Commit comment fetch fail: %@", err);
    }];
}


@end
