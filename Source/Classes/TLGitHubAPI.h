//
//  TLGitHubAPI.h
//  GitHubNotificationCenter
//
//  Created by Torsten Becker on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//


/** Our thin wrapper around UAGithubEngine */
@interface TLGitHubAPI : NSObject

/** Creates a new API wrapper with user, password, and repos to watch from NSUserDefaults. */
- (id)init;

/** Recursively fetches all pull requests stores in CoreData */
- (void)updateIntoMOC:(NSManagedObjectContext *)moc;


@end
