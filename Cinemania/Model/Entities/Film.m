//
//  Film.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/25/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Film.h"


@implementation Film

@dynamic filmID;
@dynamic originalTitle;
@dynamic posterPath;
@dynamic releaseDate;
@dynamic voteAverage;


-(instancetype) initWithServerResponse:(NSDictionary*)responseObject andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:managedObjectContext];
    if (self)
    {
        [self setValue:responseObject[@"id"] forKey:@"filmID"];
        [self setValue:responseObject[@"poster_path"] forKey:@"posterPath"];
        [self setValue:responseObject[@"original_title"] forKey:@"originalTitle"];
        [self setValue:responseObject[@"vote_average"] forKey:@"voteAverage"];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //2013-10-04
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* releaseDate = [dateFormatter dateFromString:responseObject[@"release_date"]];
        [self setValue:releaseDate forKey:@"releaseDate"];

        return self;
    }
    return nil;
}


-(NSString *)getFormatedReleaseDate:(NSDate *)releaseDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(NSDateFormatterStyle) kCFDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:(NSDateFormatterStyle) kCFDateFormatterShortStyle];
    NSString *strDate = [dateFormatter stringFromDate:self.releaseDate];
    return  strDate;
}

@end
