// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLPullRequest.m instead.

#import "_TLPullRequest.h"

const struct TLPullRequestAttributes TLPullRequestAttributes = {
    .label = @"label",
};

const struct TLPullRequestRelationships TLPullRequestRelationships = {
    .comments = @"comments",
    .commits = @"commits",
};

const struct TLPullRequestFetchedProperties TLPullRequestFetchedProperties = {
};

@implementation TLPullRequestID
@end

@implementation _TLPullRequest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"PullRequest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
    return @"PullRequest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"PullRequest" inManagedObjectContext:moc_];
}

- (TLPullRequestID*)objectID {
    return (TLPullRequestID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}




@dynamic label;






@dynamic comments;


- (NSMutableSet*)commentsSet {
    [self willAccessValueForKey:@"comments"];

    NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];

    [self didAccessValueForKey:@"comments"];
    return result;
}


@dynamic commits;








@end
