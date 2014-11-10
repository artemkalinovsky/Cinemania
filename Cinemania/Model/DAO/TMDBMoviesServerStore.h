//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesDataController.h"
#import "TMDBClient.h"


@interface TMDBMoviesServerStore : NSObject 
+ (instancetype)sharedManager;
- (void)fetchPopularMoviesFromServerForDataController:(MoviesDataController*) moviesDataController;
- (void)fetchMoviePosterWithFileName:(NSString *)posterFileName
                  usingResponseBlock:(TMDBClientResponseBlock)block;
- (NSURL *) prepareTrailerLinkByMovieId:(NSNumber *)movieId;
@end