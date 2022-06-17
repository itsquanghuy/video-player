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
    
    [Http
        request:[NSString stringWithFormat:@"%@/playbacks/%@/current-time", [Config baseURL], self.movieId]
        method:@"PUT"
        headers:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
            }
        ]
        body:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"current_time": [NSNumber numberWithInt:CMTimeGetSeconds([self.player currentTime])]
            }
        ]
        completionHandler:nil
    ];
}

@end
