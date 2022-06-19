//
//  MovieService.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "MovieService.h"

@implementation MovieService

+ (void)getMovieListWithPage:(NSInteger)page completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    [Http
        request:[NSString stringWithFormat:@"%@/movies?page=%ld", [Config baseURL], page]
        method:@"GET"
        headers:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
            }
        ]
        body:nil
        completionHandler:^(NSMutableDictionary * _Nonnull json) {
            completionHandler(json);
        }
        errorHandler:^(NSError * _Nullable error) {
            errorHandler(error);
        }
    ];
}

@end
