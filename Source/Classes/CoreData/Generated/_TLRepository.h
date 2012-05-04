// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLRepository.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLRepositoryAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *repositoryDescription;
} TLRepositoryAttributes;

extern const struct TLRepositoryRelationships {
	__unsafe_unretained NSString *pullRequests;
} TLRepositoryRelationships;

extern const struct TLRepositoryFetchedProperties {
} TLRepositoryFetchedProperties;

@class TLPullRequest;




@interface TLRepositoryID : NSManagedObjectID {}
@end

@interface _TLRepository : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLRepositoryID*)objectID;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* repositoryDescription;


//- (BOOL)validateRepositoryDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* pullRequests;

- (NSMutableSet*)pullRequestsSet;





@end

@interface _TLRepository (CoreDataGeneratedAccessors)

- (void)addPullRequests:(NSSet*)value_;
- (void)removePullRequests:(NSSet*)value_;
- (void)addPullRequestsObject:(TLPullRequest*)value_;
- (void)removePullRequestsObject:(TLPullRequest*)value_;

@end

@interface _TLRepository (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveRepositoryDescription;
- (void)setPrimitiveRepositoryDescription:(NSString*)value;





- (NSMutableSet*)primitivePullRequests;
- (void)setPrimitivePullRequests:(NSMutableSet*)value;


@end
