// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLComment.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLCommentAttributes {
	__unsafe_unretained NSString *message;
} TLCommentAttributes;

extern const struct TLCommentRelationships {
	__unsafe_unretained NSString *commit;
	__unsafe_unretained NSString *pullRequest;
} TLCommentRelationships;

extern const struct TLCommentFetchedProperties {
} TLCommentFetchedProperties;

@class TLCommit;
@class TLPullRequest;



@interface TLCommentID : NSManagedObjectID {}
@end

@interface _TLComment : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLCommentID*)objectID;




@property (nonatomic, strong) NSString* message;


//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TLCommit* commit;

//- (BOOL)validateCommit:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TLPullRequest* pullRequest;

//- (BOOL)validatePullRequest:(id*)value_ error:(NSError**)error_;





@end

@interface _TLComment (CoreDataGeneratedAccessors)

@end

@interface _TLComment (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;





- (TLCommit*)primitiveCommit;
- (void)setPrimitiveCommit:(TLCommit*)value;



- (TLPullRequest*)primitivePullRequest;
- (void)setPrimitivePullRequest:(TLPullRequest*)value;


@end
