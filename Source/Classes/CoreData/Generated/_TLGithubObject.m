// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLGithubObject.m instead.

#import "_TLGithubObject.h"

const struct TLGithubObjectAttributes TLGithubObjectAttributes = {
    .date = @"date",
    .githubID = @"githubID",
    .url = @"url",
};

const struct TLGithubObjectRelationships TLGithubObjectRelationships = {
    .author = @"author",
};

const struct TLGithubObjectFetchedProperties TLGithubObjectFetchedProperties = {
};

@implementation TLGithubObjectID
@end

@implementation _TLGithubObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"GithubObject" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
    return @"GithubObject";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"GithubObject" inManagedObjectContext:moc_];
}

- (TLGithubObjectID*)objectID {
    return (TLGithubObjectID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}




@dynamic date;






@dynamic githubID;






@dynamic url;






@dynamic author;








@end
