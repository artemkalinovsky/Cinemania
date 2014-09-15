//
// Created by Artem Kalinovsky on 9/15/14.
// Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "Film.h"


@implementation Film
-(NSString *)getFormatedReleaseDate:(NSDate *)releaseDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(NSDateFormatterStyle) kCFDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:(NSDateFormatterStyle) kCFDateFormatterShortStyle];
    NSString *strDate = [dateFormatter stringFromDate:self.releaseDate];
    return  strDate;
}
@end