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
             id json=[NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
             // NSLog(@"Your JSON Object: %@", json);
             NSArray *dictsArray = [json objectForKey:@"results"];
             for (NSDictionary* dict in dictsArray)
             {
                 Movie *movie = [[Movie alloc] initWithServerResponse:dict
                                      andInsertInManagedObjectContext:[SqliteMoviesStore sharedManager].managedObjectContext];
                 
                 NSString *movieId=[NSString stringWithFormat:@"%ld",(long)movie.filmID.integerValue];
                 [[TMDBClient sharedManager] getMoviesFromCategory:TMDBMovie
                                                    withParameters:@{@"id":movieId}
                                                usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
                  {
                      if(data!=nil)
                      {
                          NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:nil];
                          @try
                          {
                              [movie setValue:json[@"runtime"] forKey:@"runtime"];
                          }
                          @catch (NSException *exception)
                          {
                              [movie setValue:@(0) forKey:@"runtime"];
                          }

                      }
                  }];
             }
             [[SqliteMoviesStore sharedManager].managedObjectContext save:&error];
             [[MoviesDataController sharedManager].delegate moviesLoadingComplete];
         }
     }];
    pageNumber++;
}

- (void)fetchMoviePosterWithFileName:(NSString *)posterFileName usingResponseBlock:(TMDBClientResponseBlock)block
{
    [[TMDBClient sharedManager] getMoviePosterFrom:TMDBPosters
                                withPosterFileName:posterFileName
                                usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         block(response, data, error);
     }];
}
@end