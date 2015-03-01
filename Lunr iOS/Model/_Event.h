// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.h instead.

#import <CoreData/CoreData.h>

extern const struct EventAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *saved;
} EventAttributes;

@interface EventID : NSManagedObjectID {}
@end

@interface _Event : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EventID* objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* saved;

@property (atomic) BOOL savedValue;
- (BOOL)savedValue;
- (void)setSavedValue:(BOOL)value_;

//- (BOOL)validateSaved:(id*)value_ error:(NSError**)error_;

@end

@interface _Event (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

- (NSNumber*)primitiveSaved;
- (void)setPrimitiveSaved:(NSNumber*)value;

- (BOOL)primitiveSavedValue;
- (void)setPrimitiveSavedValue:(BOOL)value_;

@end
