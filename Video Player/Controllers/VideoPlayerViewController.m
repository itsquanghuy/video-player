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

- (void)viewDidAppear:(BOOL)animated {
    self.playbackModel = [PlaybackModel getInstance];
    self.playbackModel.isEpisode = self.isMovieSeries;
    self.playbackModel.uuid = self.movieUUID;
}

- (void)savePlaybackCurrentTime {
    self.playbackModel.currentTime = CMTimeGetSeconds([self.player currentTime]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    
    if (self.isMovieSeries) {
        [PlaybackService
            updatePlaybackWithEpisodeUUID:self.playbackModel.uuid
            currentTime:[NSNumber numberWithInt:self.playbackModel.currentTime]
            completionHandler:nil
            errorHandler:nil
        ];
    } else {
        [PlaybackService
            updatePlaybackWithMovieUUID:self.playbackModel.uuid
            currentTime:[NSNumber numberWithInt:self.playbackModel.currentTime]
            completionHandler:nil
            errorHandler:nil
        ];
    }
}

@end
