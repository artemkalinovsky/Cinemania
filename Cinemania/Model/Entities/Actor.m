//
//  Actor.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/26/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Actor.h"
#import "Movie.h"
#import "LocalMoviesStore.h"


@implementation Actor

@dynamic actorID;
@dynamic firstName;
@dynamic lastName;
@dynamic name;
@dynamic movies;


- (instancetype)initWithServerResponse:(NSDictionary*)responseObject
{
    NSManagedObjectContext *managedObjectContext = [LocalMoviesStore sharedManager].managedObjectContext;
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:managedObjectContext];
    [self setValue:responseObject[@"name"] forKey:@"name"];
    return self;
}

@end
