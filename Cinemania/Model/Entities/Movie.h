//
//  Movie.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/25/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Film.h"

@class Actor;

@interface Movie : Film

@property (nonatomic, retain) NSNumber *budget;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSNumber *revenue;
@property (nonatomic, retain) NSNumber *runtime;
@property (nonatomic, retain) NSSet *actors;

- (instancetype)initWithServerResponse:(NSDictionary*)responseObject;
- (NSString *)getNamesOfAllActors;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

@end
