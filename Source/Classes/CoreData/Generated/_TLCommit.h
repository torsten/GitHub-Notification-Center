// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLCommit.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLCommitAttributes {
	__unsafe_unretained NSString *message;
} TLCommitAttributes;

extern const struct TLCommitRelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *pullRequest;
} TLCommitRelationships;

extern const struct TLCommitFetchedProperties {
} TLCommitFetchedProperties;

@class TLComment;
@class TLPullRequest;



@interface TLCommitID : NSManagedObjectID {}
@end

@interface _TLCommit : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLCommitID*)objectID;




@property (nonatomic, strong) NSString* message;


//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* comments;

- (NSMutableSet*)commentsSet;




@property (nonatomic, strong) TLPullRequest* pullRequest;

//- (BOOL)validatePullRequest:(id*)value_ error:(NSError**)error_;





@end

@interface _TLCommit (CoreDataGeneratedAccessors)

- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(TLComment*)value_;
- (void)removeCommentsObject:(TLComment*)value_;

@end

@interface _TLCommit (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;





- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;



- (TLPullRequest*)primitivePullRequest;
- (void)setPrimitivePullRequest:(TLPullRequest*)value;


@end
