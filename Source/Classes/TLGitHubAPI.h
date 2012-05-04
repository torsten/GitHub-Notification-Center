//
//  TLGitHubAPI.h
//  GitHubNotificationCenter
//
//  Created by Torsten Becker on 5/4/12.
//  Copyright (c) 2012 6Wunderkinder. All rights reserved.
//


/** Our thing wrapper around UAGithubEngine */
@interface TLGitHubAPI : NSObject

- (id)init;

- (void)generateDummiesIntoMOC:(NSManagedObjectContext *)moc;

/** Recursively fetches all pull requests stores in CoreData */
- (void)updateIntoMOC:(NSManagedObjectContext *)moc;

@end
