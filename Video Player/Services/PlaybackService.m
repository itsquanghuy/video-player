//
//  PlaybackService.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "PlaybackService.h"

@implementation PlaybackService

+ (void)getPlaybackWithMovieID:(NSInteger)movieID completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    [Http
        request:[NSString
            stringWithFormat:@"%@/playbacks/%ld/current-time", [Config baseURL], movieID]
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

+ (void)updatePlaybackWithMovieID:(NSInteger)movieID currentTime:(NSNumber * _Nonnull)currentTime completionHandler:(void (^)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^)(NSError * _Nullable))errorHandler {
    [Http
        request:[NSString stringWithFormat:@"%@/playbacks/%ld/current-time", [Config baseURL], movieID]
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
