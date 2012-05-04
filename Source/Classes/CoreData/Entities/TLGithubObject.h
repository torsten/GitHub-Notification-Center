#import "_TLGithubObject.h"

@interface TLGithubObject : _TLGithubObject {}

+ (id)fetchOrCreateWithID:(NSString *)githubID
     managedObjectContext:(NSManagedObjectContext *)moc;

@end
