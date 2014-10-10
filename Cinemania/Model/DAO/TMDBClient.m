//
//  TMDBClient.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 10/1/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "TMDBClient.h"

@implementation TMDBClient

+ (instancetype)sharedManager
{
    static TMDBClient *moviesDatabaseClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moviesDatabaseClient = [[self alloc] init];
    });

    return moviesDatabaseClient;
}

-(void) GET:(NSString *)path withParameters:(NSDictionary *)parameters usingResponseBlock:(TMDBClientResponseBlock)block
{
    NSString *strURL=[NSString stringWithFormat:@"%@%@?api_key=%@",TMDBBaseURL,path,TMDBApiKey];
    if ([strURL rangeOfString:@":id"].location != NSNotFound)
    {
        strURL = [strURL stringByReplacingOccurrencesOfString:@":id" withString:parameters[@"id"]];
    }

    NSArray *paramKeys=parameters.allKeys;
    NSArray *paramValues=parameters.allValues;

    for(int i=0;i<parameters.count;i++)
    {
        NSString *tmpParam=[NSString stringWithFormat:@"&%@=%@",[paramKeys objectAtIndex:i], [paramValues objectAtIndex:i]];
        strURL= [strURL stringByAppendingString:tmpParam];
    }

    NSURL *url=[NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
            block(response,data,error);

    }];
}

@end