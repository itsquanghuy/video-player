//
//  PlaybackService.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "PlaybackService.h"

@implementation PlaybackService

+ (void)getPlaybackWithMovieUUID:(NSString * _Nonnull)movieUUID completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString
            stringWithFormat:@"%@/playbacks/%@/current-time", config.baseURL, movieUUID]
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

+ (void)updatePlaybackWithMovieUUID:(NSString * _Nonnull)movieUUID currentTime:(NSNumber * _Nonnull)currentTime completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString stringWithFormat:@"%@/playbacks/%@/current-time", config.baseURL, movieUUID]
        method:@"PUT"
        headers:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
            }
        ]
        body:[[NSMutableDictionary alloc]
            initWithDictionary:@{@"current_time": currentTime}
        ]
        completionHandler:nil
        errorHandler:nil
    ];
}

+ (void)getPlaybackWithEpisodeUUID:(NSString * _Nonnull)movieUUID completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString
            stringWithFormat:@"%@/playbacks/episodes/%@/current-time", config.baseURL, movieUUID]
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

+ (void)updatePlaybackWithEpisodeUUID:(NSString * _Nonnull)movieUUID currentTime:(NSNumber * _Nonnull)currentTime completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString stringWithFormat:@"%@/playbacks/episodes/%@/current-time", config.baseURL, movieUUID]
        method:@"PUT"
        headers:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
            }
        ]
        body:[[NSMutableDictionary alloc]
            initWithDictionary:@{@"current_time": currentTime}
        ]
        completionHandler:nil
        errorHandler:nil
    ];
}

@end
