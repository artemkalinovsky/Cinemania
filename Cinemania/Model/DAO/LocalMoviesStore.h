//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesDataController.h"

@interface LocalMoviesStore : NSObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
+ (instancetype)sharedManager;
- (NSFetchedResultsController *)fetchMoviesAndSortBy:(NSString *)fieldName;
- (void)clearCache;
@end