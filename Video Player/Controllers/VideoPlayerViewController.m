//
//  VideoPlayerViewController.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    int64_t currentTime = self.player.currentItem.currentTime.value;
    int32_t timescale = self.player.currentItem.asset.duration.timescale;
    int64_t seconds = currentTime / timescale;
    NSLog(@"%lld", seconds);
    
//    [Http
//        request:[NSString stringWithFormat:@"%@/playbacks/%@/current-time", [Config baseURL], self.movieId]
//        method:@"PUT"
//        headers:[[NSMutableDictionary alloc]
//            initWithDictionary:@{
//                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
//            }
//        ]
//        body:[[NSMutableDictionary alloc]
//            initWithDictionary:@{
//                @"current_time": [NSNumber numberWithLongLong:currentTime]
//            }
//        ]
//        completionHandler:nil
//    ];
}

@end
