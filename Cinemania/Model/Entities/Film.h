//
//  Film.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/22/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Film : NSManagedObject

@property (nonatomic, retain) NSNumber * filmID;
@property (nonatomic, retain) NSString * originalTitle;
@property (nonatomic, retain) NSString * posterPath;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * voteAverage;

-(NSString *)getFormatedReleaseDate:(NSDate *)releaseDate;
-(instancetype)initWithServerResponse:(NSDictionary*)responseObject andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
