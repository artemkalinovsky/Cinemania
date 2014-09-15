//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "MoviesDataController.h"
#import "Movie.h"
@interface MoviesDataController()

@property (nonatomic, readonly) NSMutableArray *movieList;
-(void) initializeWithDefaultMovies;

@end


@implementation MoviesDataController

-(instancetype) init
{
    self=[super init];
    if(self)
    {
        _movieList=[[NSMutableArray alloc] init];
        [self initializeWithDefaultMovies];
        return self;
    }
    return nil;
}

-(void)initializeWithDefaultMovies
{
    [self addMovieWithName:@"Edge of Tomorrow"];
    [self addMovieWithName:@"Captain America: The Winter Soldier"];
    [self addMovieWithName:@"Maleficent"];
    [self addMovieWithName:@"Godzilla"];
    [self addMovieWithName:@"The Expendables 3"];
    [self addMovieWithName:@"Divergent"];
    [self addMovieWithName:@"Neighbors"];
    [self addMovieWithName:@"The Prince"];
    [self addMovieWithName:@"Frozen"];
    [self addMovieWithName:@"Need for Speed"];
}

-(void)addMovieWithName:(NSString *)name
{
    Movie *movie=[[Movie alloc] initMovieWithName:name];
    [self.movieList addObject:movie];
}

- (void)addMovieWithName:(NSString *)name summary:(NSString *)summary releaseDate:(NSDate *)releaseDate casts:(NSString *)casts posters:(NSData *)posters runtime:(NSDate *)runtime
{
    
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