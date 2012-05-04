// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TLRepository.h instead.

#import <CoreData/CoreData.h>
#import "TLGithubObject.h"

extern const struct TLRepositoryAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *repositoryDescription;
} TLRepositoryAttributes;

extern const struct TLRepositoryRelationships {
} TLRepositoryRelationships;

extern const struct TLRepositoryFetchedProperties {
} TLRepositoryFetchedProperties;





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






@end

@interface _TLRepository (CoreDataGeneratedAccessors)

@end

@interface _TLRepository (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveRepositoryDescription;
- (void)setPrimitiveRepositoryDescription:(NSString*)value;




@end
