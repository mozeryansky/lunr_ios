// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.m instead.

#import "_Event.h"

const struct EventAttributes EventAttributes = {
	.address = @"address",
	.avatarUrlMedium = @"avatarUrlMedium",
	.avatarUrlSquare = @"avatarUrlSquare",
	.avatarUrlThumb = @"avatarUrlThumb",
	.categoryText = @"categoryText",
	.descriptionText = @"descriptionText",
	.endTimeUTC = @"endTimeUTC",
	.eventLink = @"eventLink",
	.id = @"id",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
	.place = @"place",
	.priceRange = @"priceRange",
	.reviews = @"reviews",
	.saved = @"saved",
	.startTimeUTC = @"startTimeUTC",
	.tags = @"tags",
	.visible = @"visible",
};

@implementation EventID
@end

@implementation _Event

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (EventID*)objectID {
	return (EventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"savedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"saved"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"visibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"visible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic avatarUrlMedium;

@dynamic avatarUrlSquare;

@dynamic avatarUrlThumb;

@dynamic categoryText;

@dynamic descriptionText;

@dynamic endTimeUTC;

@dynamic eventLink;

@dynamic id;

- (int64_t)idValue {
	NSNumber *result = [self id];
	return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_ {
	[self setId:@(value_)];
}

- (int64_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:@(value_)];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic name;

@dynamic place;

@dynamic priceRange;

@dynamic reviews;

@dynamic saved;

- (BOOL)savedValue {
	NSNumber *result = [self saved];
	return [result boolValue];
}

- (void)setSavedValue:(BOOL)value_ {
	[self setSaved:@(value_)];
}

- (BOOL)primitiveSavedValue {
	NSNumber *result = [self primitiveSaved];
	return [result boolValue];
}

- (void)setPrimitiveSavedValue:(BOOL)value_ {
	[self setPrimitiveSaved:@(value_)];
}

@dynamic startTimeUTC;

@dynamic tags;

@dynamic visible;

- (BOOL)visibleValue {
	NSNumber *result = [self visible];
	return [result boolValue];
}

- (void)setVisibleValue:(BOOL)value_ {
	[self setVisible:@(value_)];
}

- (BOOL)primitiveVisibleValue {
	NSNumber *result = [self primitiveVisible];
	return [result boolValue];
}

- (void)setPrimitiveVisibleValue:(BOOL)value_ {
	[self setPrimitiveVisible:@(value_)];
}

@end

