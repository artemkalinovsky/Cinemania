//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "LocalMoviesStore.h"

@interface LocalMoviesStore()
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation LocalMoviesStore

+ (instancetype)sharedManager
{
    static LocalMoviesStore *localMoviesStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localMoviesStore = [[self alloc] init];
    });

    return localMoviesStore;
}

- (void)clearCache
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cinemania.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

//    NSManagedObjectContext *context =_managedObjectContext;
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
//    NSError *error;
//    NSArray *movies = [context executeFetchRequest:request error:&error];
//    if (movies == nil)
//    {
//        // handle error
//    }
//    else
//    {
//        for (NSManagedObject *movie in movies)
//        {
//            [context deleteObject:movie];
//        }
//        [context save:&error];
//    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cinemania" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cinemania.sqlite"];
//
//    static BOOL isFirstRun = YES;
//    if(isFirstRun)
//    {
//        [self clearCache];
//        isFirstRun = NO;
//    }
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
     Replace this implementation with code to handle the error appropriately.

     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.


     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:*/
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        //  * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
        //     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
        /*     BOOL success = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL
                                                                            options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES}
                                                                              error:&error];
             if (!success)
             {
        //  Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
                 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                 abort();
             }*/
    }

    return _persistentStoreCoordinator;
}

- (NSFetchedResultsController *)fetchMoviesAndSortBy:(NSString *)fieldName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    // Create a sort descriptor for the request
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
            initWithKey:fieldName
              ascending:NO
               selector:@selector(compare:)];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // Now create the fetched results controller
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:self.managedObjectContext
              sectionNameKeyPath:fieldName
                       cacheName:@"Master"];

    NSError *error = nil;

    if (![frc performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return frc;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end