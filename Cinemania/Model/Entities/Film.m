//
//  Film.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/25/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Film.h"


@implementation Film

@dynamic filmID;
@dynamic originalTitle;
@dynamic posterPath;
@dynamic releaseDate;
@dynamic voteAverage;


- (NSString *)getFormattedReleaseDate:(NSDate *)releaseDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(NSDateFormatterStyle) kCFDateFormatterMediumStyle];
    // [dateFormatter setTimeStyle:(NSDateFormatterStyle) kCFDateFormatterShortStyle];//there's actually no time of release, only date
    NSString *strDate = [dateFormatter stringFromDate:self.releaseDate];
    return  strDate;
}

- (NSString *)getFormattedRuntime:(NSNumber *)runtime
{
    long runtimeIntValue=runtime.integerValue;
    long hours=runtimeIntValue/60;
    long minutes=runtimeIntValue%60;
    return [NSString stringWithFormat:@"%ld hr %ld min",hours,minutes];
}
@end
