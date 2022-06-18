//
//  VideoPlayerViewController.h
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <AVKit/AVKit.h>
#import "Http.h"
#import "Config.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerViewController : AVPlayerViewController

@property (strong) NSString *movieId;
@property (strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END
