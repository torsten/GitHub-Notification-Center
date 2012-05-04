// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLPullRequest.m instead.

#import "_TLPullRequest.h"

const struct TLPullRequestAttributes TLPullRequestAttributes = {
	.label = @"label",
	.number = @"number",
	.pullRequestDescription = @"pullRequestDescription",
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
	
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic label;






@dynamic number;



- (int16_t)numberValue {
	NSNumber *result = [self number];
	return [result shortValue];
}

- (void)setNumberValue:(int16_t)value_ {
	[self setNumber:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumberValue {
	NSNumber *result = [self primitiveNumber];
	return [result shortValue];
}

- (void)setPrimitiveNumberValue:(int16_t)value_ {
	[self setPrimitiveNumber:[NSNumber numberWithShort:value_]];
}





@dynamic pullRequestDescription;






@dynamic comments;

	
- (NSMutableSet*)commentsSet {
	[self willAccessValueForKey:@"comments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];
  
	[self didAccessValueForKey:@"comments"];
	return result;
}
	

@dynamic commits;

	
- (NSMutableSet*)commitsSet {
	[self willAccessValueForKey:@"commits"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"commits"];
  
	[self didAccessValueForKey:@"commits"];
	return result;
}
	






@end
