//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Movie;

@interface MoviesDataController : NSObject

- (NSUInteger) movieCount;
- (Movie *) movieAtIndex:(NSUInteger)index;
- (void) fetchPopularMoviesWithParams:(NSDictionary*) params andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end