// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLRepository.m instead.

#import "_TLRepository.h"

const struct TLRepositoryAttributes TLRepositoryAttributes = {
	.name = @"name",
	.repositoryDescription = @"repositoryDescription",
};

const struct TLRepositoryRelationships TLRepositoryRelationships = {
};

const struct TLRepositoryFetchedProperties TLRepositoryFetchedProperties = {
};

@implementation TLRepositoryID
@end

@implementation _TLRepository

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Repository" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Repository";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Repository" inManagedObjectContext:moc_];
}

- (TLRepositoryID*)objectID {
	return (TLRepositoryID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic repositoryDescription;











@end
