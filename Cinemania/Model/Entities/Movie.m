//
//  Movie.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/22/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Movie.h"


@implementation Movie

@dynamic budget;
@dynamic casts;
@dynamic overview;
@dynamic revenue;
@dynamic runtime;


-(instancetype) initWithServerResponse:(NSDictionary*)responseObject andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithServerResponse:responseObject andManagedObjectContext:managedObjectContext];
    if (self)
    {
        //add runtime,casts, overview
        return self;
    }
    return nil;
}


@end
