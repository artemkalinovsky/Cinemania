//
//  TVShow.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/15/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Film.h"

@interface TVShow : Film

@property (strong, nonatomic) NSString *showType;//for example: soap opera
@property (strong, nonatomic) NSString *showStatus;//for example: returning series

@end
