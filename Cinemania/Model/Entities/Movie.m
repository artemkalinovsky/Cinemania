//
//  Movie.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/25/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Movie.h"
#import "Actor.h"
#import "LocalMoviesStore.h"


@implementation Movie

@dynamic budget;
@dynamic overview;
@dynamic revenue;
@dynamic runtime;
@dynamic actors;

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject
{
    NSManagedObjectContext *managedObjectContext = [LocalMoviesStore sharedManager].managedObjectContext;
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
    [self setValue:responseObject[@"id"] forKey:@"filmID"];
    
    if (responseObject[@"poster_path"] == (id)[NSNull null] || [responseObject[@"poster_path"] length] == 0)
    {
        [self setValue:@"no_path" forKey:@"posterPath"];
    }
    else
    {
       [self setValue:responseObject[@"poster_path"] forKey:@"posterPath"];
    }
    
    //[self setValue:responseObject[@"original_title"] forKey:@"originalTitle"];
    [self setValue:responseObject[@"title"] forKey:@"originalTitle"];
    [self setValue:responseObject[@"vote_average"] forKey:@"voteAverage"];
    //add runtime,casts, overview
    [self setValue:@"" forKey:@"overview"];
    [self setValue:@(0) forKey:@"revenue"];
    [self setValue:@(0) forKey:@"budget"];
    [self setValue:@(0) forKey:@"runtime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //2013-10-04
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *releaseDate = [dateFormatter dateFromString:responseObject[@"release_date"]];
    [self setValue:releaseDate forKey:@"releaseDate"];
    self.actors=[[NSSet alloc] init];
    return self;
}

- (NSString *)getNamesOfAllActors
{
    NSMutableString *castsString=[[NSMutableString alloc]init];
    NSArray *castsArray=[self.actors allObjects];
    for(int i=0;i<[castsArray count]; i++)
    {
        if([castsArray[i] isKindOfClass:[Actor class]])
        {
            Actor *tmpActor=(Actor *)castsArray[i];
            if(i==[castsArray count]-1)
            {
                [castsString appendString:[NSString stringWithFormat:@"%@",tmpActor.name]];
            }
            else
            {
                [castsString appendString:[NSString stringWithFormat:@"%@, ", tmpActor.name]];
            }
        }
    }
    return castsString;
}
@end
