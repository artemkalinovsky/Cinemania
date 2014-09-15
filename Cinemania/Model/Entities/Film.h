//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Film : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *casts;
@property (strong, nonatomic) NSData *posters;
@property (strong, nonatomic) NSString *runtime;

-(NSString *)getFormatedReleaseDate:(NSDate *)releaseDate;

@end