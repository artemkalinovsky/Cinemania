//
//  Movie.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/25/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Movie.h"
#import "Actor.h"


@implementation Movie

@dynamic budget;
@dynamic overview;
@dynamic revenue;
@dynamic runtime;
@dynamic actors;

-(instancetype) initWithServerResponse:(NSDictionary*)responseObject andInsertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithServerResponse:responseObject andManagedObjectContext:managedObjectContext];

    if (self)
    {
        self = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:managedObjectContext];
        [self setValue:responseObject[@"id"] forKey:@"filmID"];
        [self setValue:responseObject[@"poster_path"] forKey:@"posterPath"];
        [self setValue:responseObject[@"original_title"] forKey:@"originalTitle"];
        [self setValue:responseObject[@"vote_average"] forKey:@"voteAverage"];
        //add runtime,casts, overview
        [self setValue:@"" forKey:@"overview"];
        // [self setValue:nil forKey:@"casts"];
        [self setValue:@(0) forKey:@"revenue"];
        [self setValue:@(0) forKey:@"budget"];
        [self setValue:@(0) forKey:@"runtime"];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //2013-10-04
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* releaseDate = [dateFormatter dateFromString:responseObject[@"release_date"]];
        [self setValue:releaseDate forKey:@"releaseDate"];
        
        return self;
    }
    return nil;
}

@end
