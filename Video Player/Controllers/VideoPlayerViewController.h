//
//  VideoPlayerViewController.h
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <AVKit/AVKit.h>
#import "Http.h"
#import "PlaybackService.h"
#import "PLaybackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerViewController : AVPlayerViewController

@property (nonatomic, strong) NSString * movieUUID;
@property (strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isMovieSeries;
@property (nonatomic, strong) PlaybackModel *playbackModel;

@end

NS_ASSUME_NONNULL_END
