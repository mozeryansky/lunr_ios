// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.h instead.

@import CoreData;

extern const struct EventAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *avatarUrlMedium;
	__unsafe_unretained NSString *avatarUrlSquare;
	__unsafe_unretained NSString *avatarUrlThumb;
	__unsafe_unretained NSString *categoryText;
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *endTimeUTC;
	__unsafe_unretained NSString *eventLink;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *place;
	__unsafe_unretained NSString *priceRange;
	__unsafe_unretained NSString *reviews;
	__unsafe_unretained NSString *saved;
	__unsafe_unretained NSString *startTimeUTC;
	__unsafe_unretained NSString *tags;
	__unsafe_unretained NSString *visible;
} EventAttributes;

@interface EventID : NSManagedObjectID {}
@end

@interface _Event : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EventID* objectID;

@property (nonatomic, strong) NSString* address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatarUrlMedium;

//- (BOOL)validateAvatarUrlMedium:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatarUrlSquare;

//- (BOOL)validateAvatarUrlSquare:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatarUrlThumb;

//- (BOOL)validateAvatarUrlThumb:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* categoryText;

//- (BOOL)validateCategoryText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* descriptionText;

//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* endTimeUTC;

//- (BOOL)validateEndTimeUTC:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* eventLink;

//- (BOOL)validateEventLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* place;

//- (BOOL)validatePlace:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* priceRange;

//- (BOOL)validatePriceRange:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* reviews;

//- (BOOL)validateReviews:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* saved;

@property (atomic) BOOL savedValue;
- (BOOL)savedValue;
- (void)setSavedValue:(BOOL)value_;

//- (BOOL)validateSaved:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* startTimeUTC;

//- (BOOL)validateStartTimeUTC:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* tags;

//- (BOOL)validateTags:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* visible;

@property (atomic) BOOL visibleValue;
- (BOOL)visibleValue;
- (void)setVisibleValue:(BOOL)value_;

//- (BOOL)validateVisible:(id*)value_ error:(NSError**)error_;

@end

@interface _Event (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;

- (NSString*)primitiveAvatarUrlMedium;
- (void)setPrimitiveAvatarUrlMedium:(NSString*)value;

- (NSString*)primitiveAvatarUrlSquare;
- (void)setPrimitiveAvatarUrlSquare:(NSString*)value;

- (NSString*)primitiveAvatarUrlThumb;
- (void)setPrimitiveAvatarUrlThumb:(NSString*)value;

- (NSString*)primitiveCategoryText;
- (void)setPrimitiveCategoryText:(NSString*)value;

- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;

- (NSDate*)primitiveEndTimeUTC;
- (void)setPrimitiveEndTimeUTC:(NSDate*)value;

- (NSString*)primitiveEventLink;
- (void)setPrimitiveEventLink:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePlace;
- (void)setPrimitivePlace:(NSString*)value;

- (NSString*)primitivePriceRange;
- (void)setPrimitivePriceRange:(NSString*)value;

- (NSString*)primitiveReviews;
- (void)setPrimitiveReviews:(NSString*)value;

- (NSNumber*)primitiveSaved;
- (void)setPrimitiveSaved:(NSNumber*)value;

- (BOOL)primitiveSavedValue;
- (void)setPrimitiveSavedValue:(BOOL)value_;

- (NSDate*)primitiveStartTimeUTC;
- (void)setPrimitiveStartTimeUTC:(NSDate*)value;

- (NSString*)primitiveTags;
- (void)setPrimitiveTags:(NSString*)value;

- (NSNumber*)primitiveVisible;
- (void)setPrimitiveVisible:(NSNumber*)value;

- (BOOL)primitiveVisibleValue;
- (void)setPrimitiveVisibleValue:(BOOL)value_;

@end
