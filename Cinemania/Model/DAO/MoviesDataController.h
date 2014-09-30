//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Movie;

@interface MoviesDataController : NSObject
@property (strong, nonatomic) NSMutableArray *movieList;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)sharedManager;
- (NSUInteger) movieCount;
- (Movie *) movieAtIndex:(NSUInteger)index;
- (void) fetchPopularMoviesFromServerWithParams:(NSDictionary*) params;
-(NSFetchedResultsController *)fetchMovies;

@end