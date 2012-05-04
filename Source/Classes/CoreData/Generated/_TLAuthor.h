// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLAuthor.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLAuthorAttributes {
	__unsafe_unretained NSString *avatarURL;
	__unsafe_unretained NSString *name;
} TLAuthorAttributes;

extern const struct TLAuthorRelationships {
	__unsafe_unretained NSString *githubObjects;
} TLAuthorRelationships;

extern const struct TLAuthorFetchedProperties {
} TLAuthorFetchedProperties;

@class TLGithubObject;




@interface TLAuthorID : NSManagedObjectID {}
@end

@interface _TLAuthor : TLGithubObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TLAuthorID*)objectID;




@property (nonatomic, strong) NSString* avatarURL;


//- (BOOL)validateAvatarURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* githubObjects;

- (NSMutableSet*)githubObjectsSet;





@end

@interface _TLAuthor (CoreDataGeneratedAccessors)

- (void)addGithubObjects:(NSSet*)value_;
- (void)removeGithubObjects:(NSSet*)value_;
- (void)addGithubObjectsObject:(TLGithubObject*)value_;
- (void)removeGithubObjectsObject:(TLGithubObject*)value_;

@end

@interface _TLAuthor (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAvatarURL;
- (void)setPrimitiveAvatarURL:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveGithubObjects;
- (void)setPrimitiveGithubObjects:(NSMutableSet*)value;


@end
