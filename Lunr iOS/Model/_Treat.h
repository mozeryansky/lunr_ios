// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Treat.h instead.

#import <CoreData/CoreData.h>

extern const struct TreatAttributes {
	__unsafe_unretained NSString *id;
} TreatAttributes;

@interface TreatID : NSManagedObjectID {}
@end

@interface _Treat : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TreatID* objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@end

@interface _Treat (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

@end
