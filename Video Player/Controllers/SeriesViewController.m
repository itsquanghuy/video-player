//
//  SeriesViewController.m
//  Video Player
//
//  Created by Vu Huy on 20/06/2022.
//

#import "SeriesViewController.h"

@interface SeriesViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingSpinner setCenter:CGPointMake(
        self.view.frame.size.width / 2,
        self.view.frame.size.height / 2)
    ];
    [self.view addSubview:self.loadingSpinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSpinner startAnimating];
        });
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(orientationChanged:)
            name:UIDeviceOrientationDidChangeNotification
            object:[UIDevice currentDevice]
        ];
        
        [MovieService
            getMovieSeries:self.movieModel.movieUUID
            completionHandler:^(NSMutableDictionary * _Nonnull json) {
                self.movieSeries = (NSArray *)[json valueForKey:@"series"];
                self.metadataModel = (NSArray *)[json valueForKey:@"metadata"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initTableView];
                    [self.loadingSpinner stopAnimating];
                });
            }
            errorHandler:^(NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayFallback];
                    [self.loadingSpinner stopAnimating];
                });
            }
        ];
    });
}

- (void)orientationChanged:(NSNotification *)notification {
    self.tableView.frame = CGRectMake(
        0,
        0,
        self.view.bounds.size.width,
        self.view.bounds.size.height
    );
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
    fallbackMessage.text = @"There is no series for this movie.";
    fallbackMessage.font = [UIFont systemFontOfSize:16];
    fallbackMessage.textAlignment = NSTextAlignmentCenter;
    [fallbackMessage setCenter:CGPointMake(
        self.view.frame.size.width / 2,
        self.view.frame.size.height / 2)
    ];
    [self.view addSubview:fallbackMessage];
}

- (void)presentVideoPlayer:(NSString *)movieUUID currentTime:(Float64)currentTime {
    NSString *movieURLWithString = [NSString stringWithFormat:@"%@/movies/%@/media", [Config baseURL], movieUUID];
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
    playerVC.movieUUID = movieUUID;
    [self presentViewController:playerVC animated:YES completion:^{
        int32_t timescale = player.currentItem.asset.duration.timescale;
        CMTime targetTime = CMTimeMakeWithSeconds(currentTime, timescale);
        [player
            seekToTime:targetTime
            toleranceBefore:kCMTimeZero
            toleranceAfter:kCMTimeZero
            completionHandler:^(BOOL finished) {
                [player play];
            }
        ];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.metadataModel.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Season %@", [self.metadataModel[section] valueForKey:@"season"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.metadataModel[section] valueForKey:@"number_of_episodes"] longValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable episode, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [[episode valueForKey:@"uuid"] isEqual:[NSString stringWithFormat:@"s%lde%ld-%@", indexPath.section + 1, indexPath.row + 1, self.movieModel.movieUUID]];
    }];
    NSMutableDictionary *episode = [self.movieSeries filteredArrayUsingPredicate:predicate][0];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"cell"
        ];
    }
    
    cell.textLabel.text = [episode valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:24 weight:16];
    cell.detailTextLabel.text = [episode valueForKey:@"description"];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 3;
    cell.imageView.image = [UIImage
        imageWithData:[[NSData alloc]
            initWithContentsOfURL:[NSURL
                URLWithString:[NSString
                    stringWithFormat:@"%@/movies/%@/poster", [Config baseURL], [episode valueForKey:@"uuid"]]
            ]
        ]
    ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [PlaybackService
        getPlaybackWithMovieUUID:self.movieModel.movieUUID
        completionHandler:^(NSMutableDictionary * _Nonnull json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self
                    presentVideoPlayer:self.movieModel.movieUUID
                    currentTime:[[NSString stringWithFormat:@"%@", [json valueForKey:@"current_time"]] floatValue]
                ];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            });
        }
        errorHandler:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayFallback];
            });
        }
    ];
}

@end
