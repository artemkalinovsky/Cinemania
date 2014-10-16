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

- (UIImage*)fetchPosterFromDiskWithName:(NSString *)posterName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    NSString *localFilePath = [NSString stringWithFormat:@"%@%@",dataPath,posterName];
    UIImage *poster=[UIImage imageNamed:localFilePath];
    return poster;
}

- (void)saveAtDiskMoviePoster:(NSData *) posterImageData WithName:(NSString *)posterName;
{
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

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end