// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLPullRequest.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLPullRequestAttributes {
	__unsafe_unretained NSString *label;
} TLPullRequestAttributes;

extern const struct TLPullRequestRelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *commits;
} TLPullRequestRelationships;

extern const struct TLPullRequestFetchedProperties {
} TLPullRequestFetchedProperties;

@class TLComment;
@class TLCommit;



@interface TLPullRequestID : NSManagedObjectID {}
@end

@interface _TLPullRequest : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLPullRequestID*)objectID;




@property (nonatomic, strong) NSString* label;


//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* comments;

- (NSMutableSet*)commentsSet;




@property (nonatomic, strong) TLCommit* commits;

//- (BOOL)validateCommits:(id*)value_ error:(NSError**)error_;





@end

@interface _TLPullRequest (CoreDataGeneratedAccessors)

- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(TLComment*)value_;
- (void)removeCommentsObject:(TLComment*)value_;

@end

@interface _TLPullRequest (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveLabel;
- (void)setPrimitiveLabel:(NSString*)value;





- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;



- (TLCommit*)primitiveCommits;
- (void)setPrimitiveCommits:(TLCommit*)value;


@end
