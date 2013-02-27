//
//  RPDataController.h
//  tangoair
//
//  Copyright 2011 XtremeMac. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DataController : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext *)createManagedObjectContext;
- (void)save;
- (void)cancel;
- (void)deleteCoreDataStore;


#pragma mark Factory Methods

- (NSManagedObject *)newManagedObjectForClass:(Class)aClass;


#pragma mark Fetch Methods

- (NSManagedObject *)fetchObjectForClass:(Class)aClass withIndentifierValue:(id)ident;
- (NSManagedObject *)fetchObjectForClass:(Class)aClass withDescription:(NSString *)description;
- (NSManagedObject *)fetchObjectForClass:(Class)aClass withKey:(NSString *)key;

- (NSManagedObject *)fetchObjectForClass:(Class)aClass withAttribute:(NSString *)key ofValue:(id)value;
- (NSArray *)fetchObjectsForClass:(Class)aClass withAttribute:(NSString *)key ofValue:(id)value;

- (NSManagedObject *)fetchObjectForEntity:(NSEntityDescription *)entity withAttribute:(NSString *)attribute ofValue:(id)value;

- (NSArray *)fetchObjectsForClass:(Class)aClass;
- (NSArray *)fetchObjectsForClass:(Class)aClass withPredicate:(NSPredicate *)predicate;
- (NSInteger)fetchCountOfObjectsForClass:(Class)aClass;

- (NSArray *)fetchUsingFetchRequest:(NSFetchRequest *)fetchRequest;

- (NSManagedObject *)fetchObjectForManagedObjectID:(NSManagedObjectID *)managedObjectID;

#pragma mark Fetch Request Methods

- (NSFetchRequest *)fetchRequestForClass:(Class)aClass withPredicate:(NSPredicate *)predicate;
- (NSFetchRequest *)fetchRequestForClass:(Class)aClass sortedByAttribute:(NSString *)attributeName;
- (NSFetchRequest *)fetchRequestForClass:(Class)aClass sortedByAttribute:(NSString *)attributeName ascending:(BOOL)ascending;
- (NSFetchRequest *)fetchRequestForClass:(Class)aClass;	


#pragma mark Object Management Methods

- (void)deleteObjectsNotInSet:(NSSet *)objects forClass:(Class)aClass;
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjectsInSet:(NSSet *)set;

@end
