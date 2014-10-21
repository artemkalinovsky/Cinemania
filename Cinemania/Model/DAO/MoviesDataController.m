//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "LocalMoviesStore.h"
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
    return [[[LocalMoviesStore sharedManager] fetchMovies] fetchedObjects];
}

- (void)fetchPopularMoviesFromRemoteStore
{
    static BOOL isFirstAppRun=YES;
    if (isFirstAppRun)
    {
        [[LocalMoviesStore sharedManager] clearCache];
        isFirstAppRun=NO;
    }
    [[TMDBMoviesServerStore sharedManager] fetchPopularMoviesFromServer];
}

- (UIImage*)fetchPosterFromDiskWithName:(NSString *)posterName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    NSString *localFilePath = [NSString stringWithFormat:@"%@%@",dataPath,posterName];
    UIImage *poster=[UIImage imageNamed:localFilePath];
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

@end