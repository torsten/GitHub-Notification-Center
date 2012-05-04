// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLCommit.m instead.

#import "_TLCommit.h"

const struct TLCommitAttributes TLCommitAttributes = {
    .message = @"message",
};

const struct TLCommitRelationships TLCommitRelationships = {
    .comments = @"comments",
    .pullRequest = @"pullRequest",
};

const struct TLCommitFetchedProperties TLCommitFetchedProperties = {
};

@implementation TLCommitID
@end

@implementation _TLCommit

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Commit" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
    return @"Commit";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Commit" inManagedObjectContext:moc_];
}

- (TLCommitID*)objectID {
    return (TLCommitID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}




@dynamic message;






@dynamic comments;


- (NSMutableSet*)commentsSet {
    [self willAccessValueForKey:@"comments"];

    NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];

    [self didAccessValueForKey:@"comments"];
    return result;
}


@dynamic pullRequest;








@end
