//
//  ViewController.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = [NSArray new];
    NSString *device_uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [Http
        request:[NSString stringWithFormat:@"%@/auth", [Config baseURL]]
        method:@"POST"
        headers:nil
        body:[[NSMutableDictionary alloc] initWithDictionary:@{@"uuid": device_uuid}]
        completionHandler:^(
            NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 401) {
                [self displayFallback];
                return;
            }
            
            if ([data length] > 0 && error == nil) {
                NSMutableDictionary *authResults = [JSON decode:data];
                [[NSUserDefaults standardUserDefaults]
                    setValue:[authResults valueForKey:@"access_token"]
                    forKey:@"access_token"
                ];
                
                [Http
                    request:[NSString stringWithFormat:@"%@/movies?page=1", [Config baseURL]]
                    method:@"GET"
                    headers:[[NSMutableDictionary alloc]
                        initWithDictionary:@{
                            @"Authorization": [NSString stringWithFormat:@"Bearer %@", [authResults valueForKey:@"access_token"]]
                        }
                    ]
                    body:nil
                    completionHandler:^(
                        NSData * _Nullable data,
                        NSURLResponse * _Nullable response,
                        NSError * _Nullable error) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if ([httpResponse statusCode] == 401) {
                            [self displayFallback];
                            return;
                        }
                        
                        if ([data length] > 0 && error == nil) {
                            NSMutableDictionary *movieResults = [JSON decode:data];
                            self.movies = [movieResults valueForKey:@"items"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self initTableView];
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self displayFallback];
                            });
                        }
                    }
                ];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayFallback];
                });
            }
        }
    ];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc]
        initWithFrame:CGRectMake(
            0,
            0,
            self.view.bounds.size.width,
            self.view.bounds.size.height
        )
        style:UITableViewStylePlain
    ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)displayFallback {
    UILabel *fallbackMessage = [[UILabel alloc]
        initWithFrame:CGRectMake(
            0,
            0,
            self.view.bounds.size.width,
            self.view.bounds.size.height
        )
    ];
    fallbackMessage.text = @"Your device is not supported.";
    fallbackMessage.font = [UIFont systemFontOfSize:16];
    fallbackMessage.textAlignment = NSTextAlignmentCenter;
    [fallbackMessage setCenter:CGPointMake(
        self.view.frame.size.width / 2,
        self.view.frame.size.height / 2)
    ];
    [self.view addSubview:fallbackMessage];
}

- (void)presentVideoPlayer:(NSString *)movieUUID movieID:(NSString *)movieID currentTime:(Float64)currentTime {
    NSString *movieURLWithString = [NSString stringWithFormat:@"%@/movies/%@", [Config baseURL], movieUUID];
    NSURL *url = [NSURL URLWithString:movieURLWithString];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers
        setValue:[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
        forKey:@"Authorization"
    ];
    AVURLAsset *asset = [AVURLAsset
        URLAssetWithURL:url
        options: @{@"AVURLAssetHTTPHeaderFieldsKey" : headers}
    ];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    VideoPlayerViewController *playerVC = [VideoPlayerViewController new];
    playerVC.view.frame = self.view.bounds;
    playerVC.player = player;
    playerVC.showsPlaybackControls = YES;
    playerVC.movieId = [NSString stringWithFormat:@"%@", movieID];
    [self presentViewController:playerVC animated:YES completion:^{
        int32_t timescale = player.currentItem.asset.duration.timescale;
        CMTime targetTime = CMTimeMakeWithSeconds(currentTime, timescale);
        [player
            seekToTime:targetTime
            toleranceBefore:kCMTimeZero
            toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                [player play];
            }
        ];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSMutableDictionary *movie = self.movies[indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"cell"
        ];
    }
    
    cell.textLabel.text = [movie valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:24 weight:16];
    cell.detailTextLabel.text = [movie valueForKey:@"description"];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 3;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *movie = self.movies[indexPath.row];
    
    [Http
        request:[NSString
            stringWithFormat:@"%@/playbacks/%@/current-time", [Config baseURL], [movie valueForKey:@"id"]]
        method:@"GET"
        headers:[[NSMutableDictionary alloc]
            initWithDictionary:@{
                @"Authorization": [NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]]
            }
        ]
        body:nil
        completionHandler:^(
            NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 401) {
                [self displayFallback];
                return;
            }
            
            if ([data length] > 0 && error == nil) {
                NSMutableDictionary *playbackResult = [JSON decode:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self
                        presentVideoPlayer:[movie valueForKey:@"uuid"]
                        movieID:[movie valueForKey:@"id"]
                        currentTime:[[NSString stringWithFormat:@"%@", [playbackResult valueForKey:@"current_time"]] floatValue]
                    ];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayFallback];
                });
            }
        }
    ];
}

@end
