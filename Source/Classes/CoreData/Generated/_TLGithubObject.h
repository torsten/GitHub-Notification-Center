// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLGithubObject.h instead.

#import <CoreData/CoreData.h>
#import "TLManagedObject.h"

extern const struct TLGithubObjectAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *githubID;
	__unsafe_unretained NSString *updated_at;
	__unsafe_unretained NSString *url;
} TLGithubObjectAttributes;

extern const struct TLGithubObjectRelationships {
	__unsafe_unretained NSString *author;
} TLGithubObjectRelationships;

extern const struct TLGithubObjectFetchedProperties {
} TLGithubObjectFetchedProperties;

@class TLAuthor;






@interface TLGithubObjectID : NSManagedObjectID {}
@end

@interface _TLGithubObject : TLManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLGithubObjectID*)objectID;




@property (nonatomic, strong) NSDate* created_at;


//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* githubID;


//- (BOOL)validateGithubID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* updated_at;


//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* url;


//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TLAuthor* author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;





@end

@interface _TLGithubObject (CoreDataGeneratedAccessors)

@end

@interface _TLGithubObject (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSString*)primitiveGithubID;
- (void)setPrimitiveGithubID:(NSString*)value;




- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (TLAuthor*)primitiveAuthor;
- (void)setPrimitiveAuthor:(TLAuthor*)value;


@end
