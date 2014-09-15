//
//  Movie.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/15/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Film.h"

@interface Movie : Film

@property (strong, nonatomic) NSDecimalNumber *budget;
@property (strong, nonatomic) NSDecimalNumber *revenue;
@property (strong, nonatomic) NSString *diretor;

-(instancetype) initMovieWithName:(NSString *)name;

@end
