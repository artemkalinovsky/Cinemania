//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "LocalMoviesStore.h"
#import "TMDBMoviesServerStore.h"
#import "Movie.h"

@implementation MoviesDataController

#pragma mark - MoviesDataController Methods
- (NSArray *)fetchMoviesFromLocalStoreAndSortBy:(NSString *)fieldName
{
    return [[[LocalMoviesStore sharedManager] fetchMoviesAndSortBy:fieldName] fetchedObjects];
}

- (void)fetchPopularMoviesFromRemoteStore
{
    [[TMDBMoviesServerStore sharedManager] fetchPopularMoviesFromServerForDataController:self];
}

- (UIImage*)fetchPosterFromDiskWithName:(NSString *)posterName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    NSString *localFilePath = [NSString stringWithFormat:@"%@%@",dataPath,posterName];
    UIImage *poster = [UIImage imageWithContentsOfFile:localFilePath];
    return poster;
}

- (void)saveAtDiskMoviePoster:(NSData *)posterImageData
                     withName:(NSString *)posterName;
{
    if(!posterName)
        return;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil]; //Create folder
    }
    NSString *localFilePath = [NSString stringWithFormat:@"%@%@",dataPath,posterName];
    [posterImageData writeToFile:localFilePath atomically:YES];

}

- (NSURL *)getTrailerUrlForMovie:(Movie *)movie
{
    return [[TMDBMoviesServerStore sharedManager] prepareTrailerLinkByMovieId:movie.filmID];

}
@end