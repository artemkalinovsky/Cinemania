//
//  TMDBClient.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 10/1/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMDBClientConstants.h"

typedef void (^TMDBClientResponseBlock)(NSURLResponse *response, NSData *data, NSError *error);

@interface TMDBClient : NSObject

+ (instancetype)sharedManager;
- (void)getMoviesFromCategory:(NSString *)categoryPath
               withParameters:(NSDictionary *)parameters
           usingResponseBlock:(TMDBClientResponseBlock)block;
- (void)getMoviePosterFrom:(NSString *)postersRootPath
        withPosterFileName:(NSString *)posterFileName
        usingResponseBlock:(TMDBClientResponseBlock)block;

@end
