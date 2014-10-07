//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MOVIES_LOAD_COMPLETE @"MoviesLoadComplete"

@class Movie;

@interface MoviesDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (instancetype) sharedManager;
- (void) fetchPopularMoviesFromServer;
- (NSFetchedResultsController *) fetchMovies;
- (NSArray*) getMovies;

@end