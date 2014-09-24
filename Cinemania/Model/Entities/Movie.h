//
//  Movie.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/22/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Film.h"


@interface Movie : Film

@property (nonatomic, retain) NSNumber * budget;
@property (nonatomic, retain) NSData * casts;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSNumber * revenue;
@property (nonatomic, retain) NSNumber * runtime;

-(instancetype)initWithServerResponse:(NSDictionary*)responseObject andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
