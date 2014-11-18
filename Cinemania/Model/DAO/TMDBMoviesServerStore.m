//
// Created by Artem Kalinovsky on 10/14/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "TMDBMoviesServerStore.h"
#import "Movie.h"
#import "Actor.h"
#import "LocalMoviesStore.h"
#import "Reachability.h"

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

- (void)fetchRuntimeAndOverviewForMovie:(Movie *)movie
{
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
                                               movie.runtime = json[@"runtime"];
                                               movie.overview = json[@"overview"];
                                           }
                                           @catch (NSException *exception)
                                           {
                                               movie.runtime = @(0);
                                           }
                                           [[LocalMoviesStore sharedManager].managedObjectContext save:&error];
                                       }
                                   }];
}

- (void)fetchCastsForMovie:(Movie *)movie
{
    NSString *movieId=[NSString stringWithFormat:@"%ld",(long)movie.filmID.integerValue];

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
                                               Actor *actor=[[Actor alloc] initWithServerResponse:dict];
                                               if(actor!=nil)
                                               {
                                                   [movie addActorsObject:actor];
                                               }
                                           }
                                       }
                                   }];
}

- (void)fetchPopularMoviesFromServerForDataController:(MoviesDataController *)moviesDataController
{
    static int pageNumber=1;
    static BOOL isFirstAppRun=YES;
    static BOOL connectionChecked=NO;
    if (!connectionChecked)
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're offline"
                                                            message:@"Check your connection to get latest movies."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [moviesDataController.delegate moviesLoadingComplete];
        }
        connectionChecked=YES;
    }
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
                                           
                                           NSArray *dictsArray = [json objectForKey:@"results"];
                                           for (NSDictionary* dict in dictsArray)
                                           {
                                               Movie *movie = [[Movie alloc] initWithServerResponse:dict];
                                               @synchronized (self)
                                               {
                                                   [self fetchRuntimeAndOverviewForMovie:movie];
                                                   [self fetchCastsForMovie:movie];
                                               }
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

- (NSURL *)prepareTrailerLinkByMovieId:(NSNumber *)movieId
{
    NSData *jsonData = [[TMDBClient sharedManager] getJsonDataForTrailerByMovieId:movieId];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil)
        {
            //NSLog(@"%@", result);
            NSDictionary *dict = result[@"youtube"];
            NSString *trailerCode = [NSString stringWithFormat:@"%@", [[dict valueForKey:@"source"] firstObject]];
            //NSLog(@"%@",trailerCode);
            NSString *urlVideoString = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", trailerCode];
            NSURL *urlVideo = [NSURL URLWithString:urlVideoString];
            return urlVideo;
        }
    }
    return nil;
}
@end