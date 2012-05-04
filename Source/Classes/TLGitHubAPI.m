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
    TLAuthor *author = [TLAuthor fetchOrCreateWithID:@"githubID" managedObjectContext:moc];
    author.name = @"Lars Schneider";
    author.avatarURL = @"https://secure.gravatar.com/avatar/4e2a3b00174ca6190261d1d6cf41be2a?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png";

    TLPullRequest *pullRequest = [TLPullRequest fetchOrCreateWithID:@"xxxPullRequest" managedObjectContext:moc];
    pullRequest.numberValue = 11;
    pullRequest.label = @"My new pull request";

    TLComment *pullRequestComment = [TLComment fetchOrCreateWithID:@"xxxPullRequestComment" managedObjectContext:moc];
    pullRequestComment.message = @"laber rababer pull request";
    [pullRequest addCommentsObject:pullRequestComment];


    TLCommit *commit = [TLCommit fetchOrCreateWithID:@"123commit" managedObjectContext:moc];

    TLComment *commitComment = [TLComment  fetchOrCreateWithID:@"123commitComment" managedObjectContext:moc];
    commitComment.message = @"commit comment";
    [commit addCommentsObject:commitComment];

    [pullRequest addCommitsObject:commit];

    [moc saveChanges];
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
                NSString *gitHubId = [[dict objectForKey:@"id"] stringValue];

                NSLog(@" - label: %@", label);
                NSLog(@" - pull#: %d", number);
                NSLog(@" - date: %@", date);
                NSLog(@" - url: %@", url);
                NSLog(@" - id: %@", gitHubId);

                // user =     {
                //     "avatar_url" = "https://secure.gravatar.com/avatar/7bce86ef594d03d98383f9a9d842d32d?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png";
                //     "gravatar_id" = 7bce86ef594d03d98383f9a9d842d32d;
                //     id = 13548;
                //     login = torsten;
                //     url = "https://api.github.com/users/torsten";
                // };
                NSDictionary *userDict = [dict objectForKey:@"user"];

                TLAuthor *author = [TLAuthor fetchOrCreateWithID:[[userDict objectForKey:@"id"] stringValue] managedObjectContext:moc];
                author.name = [userDict objectForKey:@"login"];
                author.avatarURL = [userDict objectForKey:@"avatar_url"];
                author.url = [NSString stringWithFormat:@"http://github.com/%@", author.name];

                TLPullRequest *pullRequest = [TLPullRequest fetchOrCreateWithID:gitHubId managedObjectContext:moc];
                pullRequest.label = label;
                pullRequest.numberValue = number;
                pullRequest.author = author;
                pullRequest.url = url;

                [moc saveChanges];

                [self updateCommentsForPullRequest:pullRequest inRepo:repo intoMOC:moc];
                [self updateCommitsForPullRequest:pullRequest inRepo:repo intoMOC:moc];


                // NSLog(@"pull req success: (%@) %@", [thing class], thing);
            }
        }
        failure:^(NSError * err)
        {
            NSLog(@"Repo fetch fail: %@", err);
        }];
    }
}


- (void)updateCommentsForPullRequest:(TLPullRequest *)pullRequest
                              inRepo:(NSString *)repo
                             intoMOC:(NSManagedObjectContext *)moc
{
    int pullRequestId = pullRequest.numberValue;

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
        //         url = "https://api.github.com/repos/6wunderkinder/.../issues/comments/5508406";
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

            // [moc saveChanges];
        }
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
    int pullRequestId = pullRequest.numberValue;

    [self.engine commitsInPullRequest:pullRequestId forRepository:repo
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

            NSString *date = [[[dict objectForKey:@"commit"] objectForKey:@"author"] objectForKey:@"date"]; // 2012-05-03T07:23:23-07:00

            NSLog(@"   - sha: %@", sha);
            NSLog(@"   - message: %@", message);
            NSLog(@"   - date: %@", date);

            [self updateCommentsForCommit:sha inRepo:repo intoMOC:moc];
        }
    }
    failure:^(NSError * err)
    {
        NSLog(@"Commit fetch fail: %@", err);
    }];
}


- (void)updateCommentsForCommit:(NSString *)sha // TODO: Make this TLCommit
                         inRepo:(NSString *)repo
                        intoMOC:(NSManagedObjectContext *)moc
{
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

        }
    }
    failure:^(NSError * err)
    {
        NSLog(@"Commit comment fetch fail: %@", err);
    }];
}


@end
