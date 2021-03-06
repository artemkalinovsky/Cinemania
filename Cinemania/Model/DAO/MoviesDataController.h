//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoviesDataControllerDelegate;
@class Movie;


@interface MoviesDataController : NSObject
@property (weak, nonatomic) id <MoviesDataControllerDelegate> delegate;
- (NSArray *)fetchMoviesFromLocalStoreAndSortBy:(NSString *)fieldName;
- (void)fetchPopularMoviesFromRemoteStore;
- (UIImage*)fetchPosterFromDiskWithName:(NSString *)posterName;
- (void)saveAtDiskMoviePoster:(NSData *)posterImageData
                     withName:(NSString *)posterName;
- (NSURL *)getTrailerUrlForMovie:(Movie *)movie;
@end

@protocol MoviesDataControllerDelegate
@required
- (void)moviesLoadingComplete;
@end
