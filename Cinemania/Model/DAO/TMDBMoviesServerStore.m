//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "TMDBMoviesServerStore.h"
#import "TMDBClient.h"
#import "Movie.h"
#import "SqliteMoviesStore.h"


@implementation TMDBMoviesServerStore

+ (instancetype)sharedManager
{
    static TMDBMoviesServerStore *tmdbMoviesServerStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tmdbMoviesServerStore = [[self alloc] init];
    });
    
    return tmdbMoviesServerStore;
}

- (void)fetchPopularMoviesFromServer
{
    static int pageNumber=1;
    [[TMDBClient sharedManager] getMoviesFromCategory:TMDBMoviePopular
                                       withParameters:@{@"page":@(pageNumber)}
                                   usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
                                   {
                                       if(data!=nil)
                                       {
                                           id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSLog(@"Your JSON Object: %@", json);

                                           NSArray *dictsArray = [json objectForKey:@"results"];
                                           for (NSDictionary* dict in dictsArray)
                                           {
                                               Movie *movie = [[Movie alloc] initWithServerResponse:dict
                                                                    andInsertInManagedObjectContext:[SqliteMoviesStore sharedManager].managedObjectContext];
                                           }
                                           [[SqliteMoviesStore sharedManager].managedObjectContext save:&error];
                                           [[MoviesDataController sharedManager].delegate moviesLoadingComplete];
                                       }
                                   }];
    pageNumber++;
}

- (UIImage *)fetchMoviePosterWithFileName:(NSString *)posterFileName
{
    __block UIImage *poster;
    poster = [UIImage imageNamed:posterFileName];
    if(!poster)
    {
        //HTTP Request
        [[TMDBClient sharedManager] getMoviePosterFrom:TMDBPosters
                                    withPosterFileName:posterFileName
                                    usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if(data!=nil)
             {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
                 if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                 {
                     [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                               withIntermediateDirectories:NO
                                                                attributes:nil
                                                                     error:&error]; //Create folder
                 }
                 NSString *localFilePath = [NSString stringWithFormat:@"%@%@",dataPath,posterFileName];
                 [data writeToFile:localFilePath atomically:YES];
                 poster = [[UIImage alloc] initWithData:data];
             }
             return poster;
         }];
    }
    return poster;
}

@end