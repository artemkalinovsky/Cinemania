//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "Movie.h"
#import "ILMovieDBClient.h"

@interface MoviesDataController()

@property (strong, nonatomic) NSMutableArray *movieList;

@end


@implementation MoviesDataController

-(NSMutableArray*) movieList
{
    if(!_movieList) _movieList=[[NSMutableArray alloc]init];
    return _movieList;
}

-(instancetype) init
{
    self=[super init];
    if(self)
    {
        return self;
    }
    return nil;
}

-(void) fetchPopularMoviesWithParams:(NSDictionary*) params andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //NSMutableArray* objectsArray = [NSMutableArray array];//???
    [ILMovieDBClient sharedClient].apiKey = @"ed2f89aa774281fcada8f17b73c8fa05";
    [[ILMovieDBClient sharedClient] GET:kILMovieDBMoviePopular parameters:params block:^(id responseObject, NSError *error)
    {
        if (!error) {
            NSLog(@"%@", responseObject);
            
            NSArray* dictsArray = [responseObject objectForKey:@"results"];
            
            
            for (NSDictionary* dict in dictsArray)
            {
                Movie* movie = [[Movie alloc] initWithServerResponse:dict andManagedObjectContext:managedObjectContext];
                //Get runtime for current movie
               /* NSDictionary* _params = @{@"id": movie.filmID};
                [[ILMovieDBClient sharedClient] GET:kILMovieDBMovie parameters:_params block:^(id responseObject, NSError *error)
                {
                    if (!error)
                    {
                        NSLog(@"%@", responseObject);

                        NSArray *dictsArray = [responseObject objectForKey:@"response"];
                        [movie setFromServerResponse:dictsArray];
                    }
                }];*/
                [self.movieList addObject:movie];
            }
            
        }
    }];
}

-(NSUInteger) movieCount
{
    return [self.movieList count];
}

- (Movie *)movieAtIndex:(NSUInteger)index
{
    return [self.movieList objectAtIndex:index];
}
@end