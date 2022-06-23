//
//  PlaybackModel.h
//  Video Player
//
//  Created by Vu Huy on 23/06/2022.
//

#ifndef PlaybackModel_h
#define PlaybackModel_h

@interface PlaybackModel : NSObject

@property (nonatomic, assign) BOOL isEpisode;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) int currentTime;

+ getInstance;

@end

#endif /* PlaybackModel_h */
