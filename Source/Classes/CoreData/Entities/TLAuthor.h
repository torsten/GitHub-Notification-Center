#import "_TLAuthor.h"

@interface TLAuthor : _TLAuthor {}

+ (id)fetchOrCreateWithEmail:(NSString *)email
        managedObjectContext:(NSManagedObjectContext *)moc;

@end
