// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLGithubObject.m instead.

#import "_TLGithubObject.h"

const struct TLGithubObjectAttributes TLGithubObjectAttributes = {
	.created_at = @"created_at",
	.githubID = @"githubID",
	.updated_at = @"updated_at",
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




@dynamic created_at;






@dynamic githubID;






@dynamic updated_at;






@dynamic url;






@dynamic author;

	






@end
