// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLAuthor.m instead.

#import "_TLAuthor.h"

const struct TLAuthorAttributes TLAuthorAttributes = {
	.avatarURL = @"avatarURL",
	.name = @"name",
};

const struct TLAuthorRelationships TLAuthorRelationships = {
	.githubObjects = @"githubObjects",
};

const struct TLAuthorFetchedProperties TLAuthorFetchedProperties = {
};

@implementation TLAuthorID
@end

@implementation _TLAuthor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Author";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc_];
}

- (TLAuthorID*)objectID {
	return (TLAuthorID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic avatarURL;






@dynamic name;






@dynamic githubObjects;

	
- (NSMutableSet*)githubObjectsSet {
	[self willAccessValueForKey:@"githubObjects"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"githubObjects"];
  
	[self didAccessValueForKey:@"githubObjects"];
	return result;
}
	






@end
