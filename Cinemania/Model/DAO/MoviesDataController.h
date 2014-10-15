//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoviesDataControllerDelegate;

@interface MoviesDataController : NSObject
@property (weak, nonatomic) id <MoviesDataControllerDelegate> delegate;
+ (instancetype)sharedManager;
- (NSArray *)fetchMoviesFromLocalStore;
- (void)fetchPopularMoviesFromRemoteStore;
- (UIImage *)fetchPosterWithName:(NSString *)posterName;
- (NSURL *)applicationDocumentsDirectory;
@end

@protocol MoviesDataControllerDelegate
@required
- (void)moviesLoadingComplete;
- (void)posterLoadingComplete;
@end