// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLComment.m instead.

#import "_TLComment.h"

const struct TLCommentAttributes TLCommentAttributes = {
    .message = @"message",
};

const struct TLCommentRelationships TLCommentRelationships = {
    .commit = @"commit",
    .pullRequest = @"pullRequest",
};

const struct TLCommentFetchedProperties TLCommentFetchedProperties = {
};

@implementation TLCommentID
@end

@implementation _TLComment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
    return @"Comment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:moc_];
}

- (TLCommentID*)objectID {
    return (TLCommentID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}




@dynamic message;






@dynamic commit;



@dynamic pullRequest;








@end
