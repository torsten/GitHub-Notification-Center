// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLPullRequest.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLPullRequestAttributes {
	__unsafe_unretained NSString *label;
	__unsafe_unretained NSString *number;
	__unsafe_unretained NSString *pullRequestDescription;
} TLPullRequestAttributes;

extern const struct TLPullRequestRelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *commits;
	__unsafe_unretained NSString *repository;
} TLPullRequestRelationships;

extern const struct TLPullRequestFetchedProperties {
} TLPullRequestFetchedProperties;

@class TLComment;
@class TLCommit;
@class TLRepository;





@interface TLPullRequestID : NSManagedObjectID {}
@end

@interface _TLPullRequest : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLPullRequestID*)objectID;




@property (nonatomic, strong) NSString* label;


//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* number;


@property int16_t numberValue;
- (int16_t)numberValue;
- (void)setNumberValue:(int16_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* pullRequestDescription;


//- (BOOL)validatePullRequestDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* comments;

- (NSMutableSet*)commentsSet;




@property (nonatomic, strong) NSSet* commits;

- (NSMutableSet*)commitsSet;




@property (nonatomic, strong) TLRepository* repository;

//- (BOOL)validateRepository:(id*)value_ error:(NSError**)error_;





@end

@interface _TLPullRequest (CoreDataGeneratedAccessors)

- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(TLComment*)value_;
- (void)removeCommentsObject:(TLComment*)value_;

- (void)addCommits:(NSSet*)value_;
- (void)removeCommits:(NSSet*)value_;
- (void)addCommitsObject:(TLCommit*)value_;
- (void)removeCommitsObject:(TLCommit*)value_;

@end

@interface _TLPullRequest (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveLabel;
- (void)setPrimitiveLabel:(NSString*)value;




- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int16_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int16_t)value_;




- (NSString*)primitivePullRequestDescription;
- (void)setPrimitivePullRequestDescription:(NSString*)value;





- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCommits;
- (void)setPrimitiveCommits:(NSMutableSet*)value;



- (TLRepository*)primitiveRepository;
- (void)setPrimitiveRepository:(TLRepository*)value;


@end
