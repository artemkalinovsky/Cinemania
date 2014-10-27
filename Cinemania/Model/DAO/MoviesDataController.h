//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoviesDataControllerDelegate;


@interface MoviesDataController : NSObject
@property (weak, nonatomic) id <MoviesDataControllerDelegate> delegate;
- (NSArray *)fetchMoviesFromLocalStore;
- (void)fetchPopularMoviesFromRemoteStore;
- (UIImage*)fetchPosterFromDiskWithName:(NSString *)posterName;
- (void)saveAtDiskMoviePoster:(NSData *)posterImageData
                     withName:(NSString *)posterName;
@end

@protocol MoviesDataControllerDelegate
@required
- (void)moviesLoadingComplete;
@end
