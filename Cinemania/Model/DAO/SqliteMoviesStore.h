//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesDataController.h"

@interface SqliteMoviesStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
+ (instancetype)sharedManager;
- (NSFetchedResultsController *)fetchMovies;
@end