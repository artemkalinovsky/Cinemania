//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "TMDBMoviesServerStore.h"
#import "Movie.h"
#import "Actor.h"
#import "LocalMoviesStore.h"


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

- (void)fetchPopularMoviesFromServerForDataController:(MoviesDataController *)moviesDataController
{
    static int pageNumber=1;
    static BOOL isFirstAppRun=YES;
    [[TMDBClient sharedManager] getMoviesFromCategory:TMDBMoviePopular
                                       withParameters:@{@"page":@(pageNumber)}
                                   usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(data!=nil)
         {
             if (isFirstAppRun)
             {
                 [[LocalMoviesStore sharedManager] clearCache];
                 isFirstAppRun=NO;
             }
             
             id json=[NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
             // NSLog(@"Your JSON Object: %@", json);
             NSArray *dictsArray = [json objectForKey:@"results"];
             for (NSDictionary* dict in dictsArray)
             {
                 Movie *movie = [[Movie alloc] initWithServerResponse:dict
                                      andInsertInManagedObjectContext:[LocalMoviesStore sharedManager].managedObjectContext];
                 NSString *movieId=[NSString stringWithFormat:@"%ld",(long)movie.filmID.integerValue];
                 
                 //fetch runtime and overview
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
                              [movie setValue:json[@"overview"] forKey:@"overview"];
                          }
                          @catch (NSException *exception)
                          {
                              [movie setValue:@(0) forKey:@"runtime"];
                          }
                          

                      }
                  }];
                 //fetch casts
                 [[TMDBClient sharedManager] getMoviesFromCategory:TMDBMovieCredits
                                                    withParameters:@{@"id":movieId}
                                                usingResponseBlock:^(NSURLResponse *response, NSData *data, NSError *error)
                  {
                      if(data!=nil)
                      {
                          NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:nil];
                          NSArray *dictsArray = [json objectForKey:@"cast"];
                          for (NSDictionary* dict in dictsArray)
                          {
                              Actor *actor=[[Actor alloc] initWithServerResponse:dict
                                                 andInsertInManagedObjectContext:[LocalMoviesStore sharedManager].managedObjectContext];
                              [movie addActorsObject:actor];
                          }
                          
                          
                      }
                  }];

             }
             [[LocalMoviesStore sharedManager].managedObjectContext save:&error];
             [moviesDataController.delegate moviesLoadingComplete];
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