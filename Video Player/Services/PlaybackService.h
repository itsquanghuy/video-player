//
//  PlaybackService.h
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#ifndef PlaybackService_h
#define PlaybackService_h

#import "Http.h"
#import "Config.h"

@interface PlaybackService : NSObject

+ (void)getPlaybackWithMovieUUID:(NSString * _Nonnull)movieUUID completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^_Nullable)(NSError * _Nullable))errorHandler;

+ (void)updatePlaybackWithMovieUUID:(NSString * _Nonnull)movieUUID currentTime:(NSNumber * _Nonnull)currentTime completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^_Nullable)(NSError * _Nullable))errorHandler;

+ (void)getPlaybackWithEpisodeUUID:(NSString * _Nonnull)movieUUID completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^ _Nullable)(NSError * _Nullable))errorHandler;

+ (void)updatePlaybackWithEpisodeUUID:(NSString * _Nonnull)movieUUID currentTime:(NSNumber * _Nonnull)currentTime completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^ _Nullable)(NSError * _Nullable))errorHandler;

@end


#endif /* PlaybackService_h */
