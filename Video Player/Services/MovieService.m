//
//  MovieService.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "MovieService.h"

@implementation MovieService

+ (void)getMovieListByPage:(NSInteger)page completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString stringWithFormat:@"%@/movies?page=%ld", config.baseURL, page]
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

+ (void)getMovieSeries:(NSString * _Nonnull)movieUUID completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString stringWithFormat:@"%@/movies/%@/episodes", config.baseURL, movieUUID]
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
