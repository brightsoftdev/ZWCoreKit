#import "ZWManagedObjectArchiving.h"

@interface ZWManagedObjectArchiver()

@property (nonatomic, strong) NSMutableDictionary *objects;
@property (nonatomic, strong) NSString *rootObjectIdentifier;

- (id)identifierForObject:(NSManagedObject *)pObject;
- (id)propertyListForObject:(NSManagedObject *)pObject;
- (id)propertyListForRelationshipWithName:(NSString *)pRelationshipName inObject:(NSManagedObject *)pObject;

@end

@implementation ZWManagedObjectArchiver

#pragma mark - Properties

@synthesize objects;
@synthesize rootObjectIdentifier;

#pragma mark - Initialization

+ (NSData *)archivedDataWithRootObject:(NSManagedObject *)pRootObject {
	ZWManagedObjectArchiver *archiver = [[self alloc] init];
	archiver.rootObjectIdentifier = [archiver identifierForObject:pRootObject];
	[archiver propertyListForObject:pRootObject];
	return [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithObjectsAndKeys:
														archiver.objects, @"objects",
														archiver.rootObjectIdentifier, @"rootObjectIdentifier",
														nil]];
}
- (id)init {
	if((self = [super init])) {
		objects = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark - Actions

- (id)identifierForObject:(NSManagedObject *)pObject {
	if(pObject == nil) {
		return [NSNull null];
	}
	return pObject.objectID.URIRepresentation.absoluteString;
}
- (id)propertyListForObject:(NSManagedObject *)pObject {
	if(pObject == nil) {
		return [NSNull null];
	}
	NSString *identifier = [self identifierForObject:pObject];
	id existingPropertyList = [self.objects objectForKey:identifier];
	if(existingPropertyList != nil) {
		return existingPropertyList;
	}
	NSEntityDescription *entityDescription = pObject.entity;
	
	NSMutableDictionary *propertyList = [NSMutableDictionary dictionary];
	[propertyList setObject:entityDescription.name forKey:@"entityName"];
	[propertyList setObject:entityDescription.versionHash forKey:@"entityVersionHash"];
	[propertyList setObject:identifier forKey:@"identifier"];
	[propertyList setObject:[pObject dictionaryWithValuesForKeys:entityDescription.attributesByName.allKeys] forKey:@"attributes"];
	
	[self.objects setObject:propertyList forKey:identifier];
	
	NSMutableDictionary *propertyListRelationships = [NSMutableDictionary dictionary];
	[propertyList setObject:propertyListRelationships forKey:@"relationships"];
	
	for(NSString *relationshipName in entityDescription.relationshipsByName) {
		[propertyListRelationships setObject:[self propertyListForRelationshipWithName:relationshipName inObject:pObject]
									  forKey:relationshipName];
	}
	
	return propertyList;
}
- (id)propertyListForRelationshipWithName:(NSString *)pRelationshipName inObject:(NSManagedObject *)pObject {
	NSRelationshipDescription *relationshipDescription = [pObject.entity.relationshipsByName objectForKey:pRelationshipName];
	
	if(relationshipDescription.isToMany) {
		id src = [pObject valueForKey:pRelationshipName];
		id dst = nil;
		if(relationshipDescription.isOrdered) {
			dst = [NSMutableOrderedSet orderedSet];
		} else {
			dst = [NSMutableSet set];
		}
		for(NSManagedObject *object in src) {
			NSString *identifier = [self identifierForObject:object];
			[self propertyListForObject:object];
			[dst addObject:identifier];
		}
		return ([dst count] > 0) ? dst : [NSNull null];
	} else {
		NSString *identifier = [self identifierForObject:[pObject valueForKey:pRelationshipName]];
		[self propertyListForObject:[pObject valueForKey:pRelationshipName]];
		return identifier;
	}
}

@end


@interface ZWManagedObjectUnarchiver()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL insert;
@property (nonatomic, strong) NSMutableDictionary *entities;
@property (nonatomic, strong) NSDictionary *archivedObjects;
@property (nonatomic, strong) NSMutableDictionary *unarchivedObjects;

- (NSManagedObject *)objectForIdentifier:(NSString *)pIdentifier;
- (id)objectsForIdentifiers:(id)pIdentifiers;

@end
@implementation ZWManagedObjectUnarchiver

#pragma mark - Properties

@synthesize context;
@synthesize insert;
@synthesize entities;
@synthesize archivedObjects;
@synthesize unarchivedObjects;

#pragma mark - Initialization

+ (NSManagedObject *)unarchiveObjectWithData:(NSData *)pData context:(NSManagedObjectContext *)pContext insert:(BOOL)pInsert {
	ZWManagedObjectUnarchiver *unarchiver = [[self alloc] init];
	NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:pData];
	if(dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]) {
		unarchiver.context = pContext;
		unarchiver.insert = pInsert;
		unarchiver.archivedObjects = [dictionary objectForKey:@"objects"];
		return [unarchiver objectForIdentifier:[dictionary objectForKey:@"rootObjectIdentifier"]];
	}
	return nil;
}
- (id)init {
	if((self = [super init])) {
		unarchivedObjects = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark - Actions

- (NSManagedObject *)objectForIdentifier:(NSString *)pIdentifier {
	if(pIdentifier == nil || ![pIdentifier isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSManagedObject *unarchivedObject = [self.unarchivedObjects objectForKey:pIdentifier];
	if(unarchivedObject != nil) {
		return unarchivedObject;
	}
	
	NSDictionary *archivedObject = [self.archivedObjects objectForKey:pIdentifier];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[archivedObject objectForKey:@"entityName"] inManagedObjectContext:self.context];
	if(![entityDescription.versionHash isEqualToData:[archivedObject objectForKey:@"entityVersionHash"]]) {
		[NSException raise:@"Invalid archived data" format:@"Mismatching version hashes, archived managed object's entity version hash differs from version hash in the provided context."];
		return nil;
	}
	
	
	Class entityClass = NSClassFromString([entityDescription managedObjectClassName]);
	if(entityClass == nil) {
		[NSException raise:@"Invalid archived data" format:@"Cannot find custom class with name %@ for managed object with entity name %@", entityDescription.managedObjectClassName, entityDescription.name];
		return nil;
	}
	
	NSManagedObject *object = [[entityClass alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:(self.insert) ? self.context : nil];
	[object setValuesForKeysWithDictionary:[archivedObject objectForKey:@"attributes"]];
	
	[self.unarchivedObjects setObject:object forKey:pIdentifier];
	
	NSDictionary *relationships = [archivedObject objectForKey:@"relationships"];
	for(NSString *relationshipName in relationships) {
		id relationshipValue = [relationships objectForKey:relationshipName];
		if([relationshipValue isKindOfClass:[NSString class]]) {
			relationshipValue = [self objectForIdentifier:relationshipValue];
		} else if([relationshipValue isKindOfClass:[NSOrderedSet class]] ||
				  [relationshipValue isKindOfClass:[NSSet class]]) {
			relationshipValue = [self objectsForIdentifiers:relationshipValue];
		} else if([relationshipValue isKindOfClass:[NSNull class]]) {
			relationshipValue = nil;
		}
		[object setValue:relationshipValue forKey:relationshipName];
	}
	
	return object;
}
- (id)objectsForIdentifiers:(id)pIdentifiers {
	if(pIdentifiers == nil) {
		return nil;
	}
	id collection = nil;
	if([pIdentifiers isKindOfClass:[NSOrderedSet class]]) {
		collection = [NSMutableOrderedSet orderedSetWithCapacity:[pIdentifiers count]];
	} else if([pIdentifiers isKindOfClass:[NSSet class]]) {
		collection = [NSMutableSet setWithCapacity:[pIdentifiers count]];
	} else {
		return nil;
	}
	for(id identifier in pIdentifiers) {
		NSManagedObject *object = [self objectForIdentifier:identifier];
		if(object != nil) {
			[collection addObject:object];
		}
	}
	return ([collection count] > 0) ? collection : nil;
}

@end

@implementation NSManagedObject (ZWManagedObjectCopying)

- (id)copyUsingContext:(NSManagedObjectContext *)pContext insert:(BOOL)pInsert {
	NSEntityDescription *entity = [NSEntityDescription entityForName:self.entity.name inManagedObjectContext:pContext];
	Class entityClass = NSClassFromString(entity.managedObjectClassName);
	NSManagedObject *copy = [[entityClass alloc] initWithEntity:entity insertIntoManagedObjectContext:((pInsert) ? pContext : nil)];
	[copy setValuesForKeysWithDictionary:[self dictionaryWithValuesForKeys:self.entity.attributesByName.allKeys]];
	return copy;
}
- (id)copyIncludingRelationshipsUsingContext:(NSManagedObjectContext *)pContext insert:(BOOL)pInsert {
	NSData *d = [ZWManagedObjectArchiver archivedDataWithRootObject:self];
	return [ZWManagedObjectUnarchiver unarchiveObjectWithData:d context:pContext insert:pInsert];
}

@end
