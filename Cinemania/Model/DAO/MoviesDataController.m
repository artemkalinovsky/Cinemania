//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "TMDBClient.h"
#import "Movie.h"

@interface MoviesDataController()



@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation MoviesDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager
{
    static MoviesDataController *moviesDataController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moviesDataController = [[self alloc] init];
    });

    return moviesDataController;
}

#pragma mark - MoviesDataController Methods
-(NSMutableArray*) movieList
{
    if(!_movieList) _movieList=[[NSMutableArray alloc]init];
    return _movieList;
}

-(void) fetchPopularMoviesFromServer
{
    static int pageNumber=1;
    [[TMDBClient sharedManager] GET:TMDBMoviePopular withParameters:@{@"page":@(pageNumber)} usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
            {
                if(data!=nil)
                {
                    id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"Your JSON Object: %@", json);

                    NSArray* dictsArray = [json objectForKey:@"results"];
                    for (NSDictionary* dict in dictsArray)
                    {
                        Movie* movie = [[Movie alloc] initWithServerResponse:dict andManagedObjectContext:self.managedObjectContext];
                        [self.movieList addObject:movie];
                        //[self.managedObjectContext save:&error];
                    }
                    [_managedObjectContext save:&error];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesLoadComplete" object:nil];
                }
            }];
    pageNumber++;
}

-(NSUInteger) movieCount
{
    return [self.movieList count];
}

- (Movie *)movieAtIndex:(NSUInteger)index
{
    return [self.movieList objectAtIndex:index];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSArray*) getMovies
{
    NSFetchRequest *moviesRequest = [[NSFetchRequest alloc]initWithEntityName:@"Film"]; //entity name must be Movie!!!!
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:moviesRequest error:&error];

    return results;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
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
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cinemania.sqlite"];

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

-(NSFetchedResultsController *)fetchMovies
{
    /*if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _fetchedResultsController;*/

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film"// why NOT Movie!!!!?????
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    // Create a sort descriptor for the request
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
            initWithKey:@"releaseDate"
              ascending:YES
               selector:@selector(localizedCaseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    // Now create the fetched results controller
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:self.managedObjectContext
              sectionNameKeyPath:@"releaseDate"
                       cacheName:@"Master"];




//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Movie"];
    NSError *error = nil;
   /* NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                      managedObjectContext:[[MoviesDataController sharedManager] mainContext]
                                                                                        sectionNameKeyPath:nil cacheName:@"Master"];*/

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