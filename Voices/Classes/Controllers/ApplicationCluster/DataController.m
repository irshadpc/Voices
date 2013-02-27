
//
//  DataController.m
//  CD
//
//  Created by Greg Price on 10/19/12.
//

#import "DataController.h"
#import "ApplicationContext.h"
#import "Constants.h"
#import "FileController.h"

@interface DataController()

@property (nonatomic, retain, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)registerForNotification;
- (void)unregisterForNotification;
- (NSString *)persistentStorePath;

@end

@implementation DataController

@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;

#pragma mark Setup and Teardown Methods

- (id)init {
	self = [super init];
	if (self != nil) {
		[self registerForNotification];
	}
	return self;
}

- (void)registerForNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)unregisterForNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self unregisterForNotification];
}


#pragma mark Observer Methods

- (void)managedObjectContextDidSaveNotification:(NSNotification *)note {
	
	[self performSelectorOnMainThread:@selector(mergeChanges:) withObject:note waitUntilDone:YES];	
}

- (void)mergeChanges:(NSNotification *)note {
	[[self managedObjectContext] mergeChangesFromContextDidSaveNotification:note];
}


#pragma mark Accesor Methods

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
	NSAssert([NSThread isMainThread], @"managedObjectContext access on a background thread, use createManagedObjectContext method instead");
	
    if (managedObjectContext == nil) {
		managedObjectContext = [self createManagedObjectContext];
	}
	
	return managedObjectContext;
}

- (NSManagedObjectContext *)createManagedObjectContext {
	NSManagedObjectContext *moc = nil;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator: coordinator];
    }
    return moc;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath:[self persistentStorePath]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:storeUrl 
														options:options 
														  error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		NSAssert(error == nil, @"error creating persistentStoreCoordinator");	
    }   
	
    return persistentStoreCoordinator;
}

- (NSString *)persistentStorePath {
    NSString *path = [[ApplicationContext sharedInstance].fileController pathToDocuments];
	return [path stringByAppendingPathComponent:@"CoreData.sqlite"];
}


#pragma mark Public Methods

- (void)save {
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			NSAssert(error == nil, @"error saving MOC");
        }
    }
}

- (void)cancel {
	[managedObjectContext rollback];
}

- (void)deleteCoreDataStore {
#ifdef DEBUG
    self.persistentStoreCoordinator = nil;
    self.managedObjectContext = nil;	
    self.managedObjectModel = nil;
	[[NSFileManager defaultManager] removeItemAtPath:[self persistentStorePath] error:nil];	
#else
	NSLog(@"ATTEMPT TO deleteCoreDataStore IN NON DEBUG BUILD");
#endif
}


#pragma mark Factory Methods

// This method is used to createa a new managed object of the request class. It is created in the default context.
- (NSManagedObject *)newManagedObjectForClass:(Class)aClass {

	NSManagedObjectContext *moc = [self managedObjectContext];
	NSManagedObjectModel *mom = [self managedObjectModel];
	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
	NSManagedObject *mo = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
	return mo;
}


#pragma mark Fetch Methods

// This method is used to fetch an object of the request class with the specified identifier value.
// kEntityUserInfoIdAttributeKey must be defined the the entity's user info.
//- (NSManagedObject *)fetchObjectForClass:(Class)aClass withIndentifierValue:(id)ident {
//
//	NSManagedObjectModel *mom = [self managedObjectModel];
//	
//	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
//	NSString *fieldName = [[entity userInfo] objectForKey:kEntityUserInfoIdAttributeKey];
//	if (fieldName == nil) {
//		NSLog(@"nil kEntityUserInfoIdAttributeKey for entity %@", aClass);
//		return nil;
//	}
//	
//	return [self fetchObjectForEntity:entity withAttribute:fieldName ofValue:ident];
//}

// This method is used to fetch an object of the request class with the specified description value.
// kEntityUserInfoDescriptionAttributeKey must be defined the the entity's user info.
//- (NSManagedObject *)fetchObjectForClass:(Class)aClass withDescription:(NSString *)description {
//
//	NSManagedObjectModel *mom = [self managedObjectModel];
//	
//	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
//	NSString *fieldName = [[entity userInfo] objectForKey:kEntityUserInfoDescriptionAttributeKey];
//	if (fieldName == nil) {
//		NSLog(@"nil kEntityUserInfoDescriptionAttributeKey for entity %@", aClass);
//		return nil;
//	}
//	
//	return [self fetchObjectForEntity:entity withAttribute:fieldName ofValue:description];
//}

// This method is used to fetch an object of the request class with the specified key value.
// kEntityUserInfoDescriptionAttributeKey must be defined the the entity's user info.
//- (NSManagedObject *)fetchObjectForClass:(Class)aClass withKey:(NSString *)key {
//	
//	NSManagedObjectModel *mom = [self managedObjectModel];
//	
//	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
//	NSString *fieldName = [[entity userInfo] objectForKey:kEntityUserInfoKeyAttributeKey];
//	if (fieldName == nil) {
//		NSLog(@"nil kEntityUserInfoKeyAttributeKey for entity %@", aClass);
//		return nil;
//	}
//	
//	return [self fetchObjectForEntity:entity withAttribute:fieldName ofValue:key];
//	
//}

// This method is used to an object of the requested class with specified attribute and value
- (NSManagedObject *)fetchObjectForClass:(Class)aClass withAttribute:(NSString *)key ofValue:(id)value {
	return [[self fetchObjectsForClass:aClass withAttribute:key ofValue:value] lastObject];
}

// This method is used to fetch objects of the requested class with specified attribute and value
- (NSArray *)fetchObjectsForClass:(Class)aClass withAttribute:(NSString *)key ofValue:(id)value {
	if (key == nil) {
		return nil;
	}

	NSManagedObjectModel *mom = [self managedObjectModel];	
	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	
	return [self fetchUsingFetchRequest:request];	
}

// This method will fetch an object for the the request entity, attribute, and attribute value.
- (NSManagedObject *)fetchObjectForEntity:(NSEntityDescription *)entity withAttribute:(NSString *)attribute ofValue:(id)value {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:request error:&error];
    
	if (results == nil) {
		NSLog(@"error: %@", error);
		return nil;
	} else if ([results count] != 1) {
#ifdef DEBUG
		NSLog(@"expected 1 object, retrieved %d for %@ with %@ of %@", [results count], [entity name], attribute, value);
#endif		
		return nil;
	}
	
	return [results lastObject];
}

- (NSArray *)fetchObjectsForClass:(Class)aClass {
	return [self fetchObjectsForClass:aClass withPredicate:nil];
}

- (NSArray *)fetchObjectsForClass:(Class)aClass withPredicate:(NSPredicate *)predicate {
	NSManagedObjectModel *mom = [self managedObjectModel];
	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	return [self fetchUsingFetchRequest:request];	
}

- (NSInteger)fetchCountOfObjectsForClass:(Class)aClass {
	NSInteger retval = 0;
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSManagedObjectModel *mom = [self managedObjectModel];	
	NSEntityDescription *entity = [[mom entitiesByName] objectForKey:NSStringFromClass(aClass)];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	NSError *error = nil;
	retval = [moc countForFetchRequest:request error:&error];

	if (error != nil) {
		NSLog(@"error: %@", error);
	}		
	return retval;
}

- (NSArray *)fetchUsingFetchRequest:(NSFetchRequest *)request {
	NSManagedObjectContext *moc = [self managedObjectContext];
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:request error:&error];
	if (results == nil) {
		NSLog(@"error: %@", error);
		return [NSArray array];
	}
	return results;
}

- (NSManagedObject *)fetchObjectForManagedObjectID:(NSManagedObjectID *)managedObjectID {
    return [[self managedObjectContext] objectWithID:managedObjectID];
}

#pragma mark -
#pragma mark Fetch Request Methods 

- (NSFetchRequest *)fetchRequestForClass:(Class)aClass withPredicate:(NSPredicate *)predicate {

	NSFetchRequest *request = [self fetchRequestForClass:aClass];
	[request setPredicate:predicate];
	
	return request;
}

- (NSFetchRequest *)fetchRequestForClass:(Class)aClass sortedByAttribute:(NSString *)attributeName {
	return [self fetchRequestForClass:aClass sortedByAttribute:attributeName ascending:YES];
}

- (NSFetchRequest *)fetchRequestForClass:(Class)aClass sortedByAttribute:(NSString *)attributeName ascending:(BOOL)ascending {
	NSFetchRequest *request = [self fetchRequestForClass:aClass];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

	[request setSortDescriptors:sortDescriptors];
	
	return request;	
}

- (NSFetchRequest *)fetchRequestForClass:(Class)aClass {
	
	NSManagedObjectModel *mom = self.managedObjectModel;
		
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[[mom entitiesByName] objectForKey:NSStringFromClass(aClass)]];
	
	return request;
}


#pragma mark -
#pragma mark Object Management Methods

- (void)deleteObjectsNotInSet:(NSSet *)objects forClass:(Class)aClass {
	NSArray *allObjects = [self fetchObjectsForClass:aClass];
	
	int counter = 0;
	for (NSManagedObject *managedObject in allObjects) {
		if (![objects containsObject:managedObject]) {
			[self.managedObjectContext deleteObject:managedObject];
			counter++;
		}
	}	
	
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (void)deleteObjectsInSet:(NSSet *)set {
    for (NSManagedObject *mo in set) {
        [self deleteObject:mo];
    }
}

@end
















