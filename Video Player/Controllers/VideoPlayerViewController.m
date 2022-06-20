//
//  VideoPlayerViewController.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController () <AVPlayerViewControllerDelegate>

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer
        scheduledTimerWithTimeInterval:1.0
        target:self
        selector:@selector(savePlaybackCurrentTime)
        userInfo:nil
        repeats:YES
    ];
}

- (void)savePlaybackCurrentTime {
    if (self.isMovieSeries) {
        [PlaybackService
            updatePlaybackWithEpisodeUUID:self.movieUUID
            currentTime:[NSNumber numberWithInt:CMTimeGetSeconds([self.player currentTime])]
            completionHandler:nil
            errorHandler:nil
        ];
    } else {
        [PlaybackService
            updatePlaybackWithMovieUUID:self.movieUUID
            currentTime:[NSNumber numberWithInt:CMTimeGetSeconds([self.player currentTime])]
            completionHandler:nil
            errorHandler:nil
        ];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

@end
