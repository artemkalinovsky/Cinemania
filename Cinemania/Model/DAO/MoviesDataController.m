//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "SqliteMoviesStore.h"
#import "TMDBMoviesServerStore.h"

@implementation MoviesDataController

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
- (NSArray *)fetchMoviesFromLocalStore
{
    return [[[SqliteMoviesStore sharedManager] fetchMovies] fetchedObjects];
}

- (void)fetchPopularMoviesFromRemoteStore
{
    [[TMDBMoviesServerStore sharedManager] fetchPopularMoviesFromServer];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end