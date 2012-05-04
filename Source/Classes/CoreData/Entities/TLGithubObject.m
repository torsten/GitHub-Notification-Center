#import "TLGithubObject.h"

@implementation TLGithubObject


+ (id)fetchOrCreateWithID:(NSString *)githubID
     managedObjectContext:(NSManagedObjectContext *)moc
{
    TLGithubObject *object = [self.class fetchEntityWithPredicate:[NSPredicate predicateWithFormat:@"githubID = %@", githubID]
                                             managedObjectContext:moc];

    // Create object in database if not already present
    if (object == nil)
    {
        object = [self.class insertInManagedObjectContext:moc];
        object.githubID = githubID;
    }

    return object;
}


@end
