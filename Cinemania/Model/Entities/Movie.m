//
//  Movie.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/15/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initMovieWithName:(NSString *)name
{
    self=[super init];
    if(self)
    {
        self.name=name;
        self.summary = @"";
        self.diretor = @"";
        self.casts = @"";
        self.runtime = @"";
        self.budget = [[NSDecimalNumber alloc] initWithFloat:0.0f];
        self.revenue = [[NSDecimalNumber alloc] initWithFloat:0.0f];
        self.releaseDate = [[NSDate alloc] init];
        self.posters = [[NSData alloc] init];
        return self;
    }
    return nil;
}
@end