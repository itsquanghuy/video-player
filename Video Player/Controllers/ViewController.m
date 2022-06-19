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
    
    self.page = 1;
    
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
        
        self.movies = [NSMutableArray new];
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        
        [AuthService
            authenticate:deviceUUID
            completionHandler:^(NSMutableDictionary * _Nonnull authJSON) {
                [[NSUserDefaults standardUserDefaults]
                    setValue:[authJSON valueForKey:@"access_token"]
                    forKey:@"access_token"
                ];
                
                [MovieService
                    getMovieListWithPage:self.page
                    completionHandler:^(NSMutableDictionary * _Nonnull moviesJSON) {
                        self.itemsPerPage = [[moviesJSON valueForKey:@"items_per_page"] longValue];
                        self.totalItems = [[moviesJSON valueForKey:@"total_items"] longValue];
                        self.movies = [NSMutableArray arrayWithArray:[moviesJSON valueForKey:@"items"]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self initTableView];
                            [self.loadingSpinner stopAnimating];
                        });
                    }
                    errorHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self displayFallback];
                        });
                    }
                ];
            }
            errorHandler:^(NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayFallback];
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
    fallbackMessage.text = @"Your device is not supported.";
    fallbackMessage.font = [UIFont systemFontOfSize:16];
    fallbackMessage.textAlignment = NSTextAlignmentCenter;
    [fallbackMessage setCenter:CGPointMake(
        self.view.frame.size.width / 2,
        self.view.frame.size.height / 2)
    ];
    [self.view addSubview:fallbackMessage];
}

- (void)presentVideoPlayer:(NSString *)movieUUID movieID:(NSInteger)movieID currentTime:(Float64)currentTime {
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
    playerVC.movieId = movieID;
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
    cell.imageView.image = [UIImage
        imageWithData:[[NSData alloc]
            initWithContentsOfURL:[NSURL
                URLWithString:[NSString
                    stringWithFormat:@"%@/movies/%@/poster", [Config baseURL], [movie valueForKey:@"uuid"]]
            ]
        ]
    ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL scrollToBottomDetected = indexPath.section == tableView.numberOfSections - 1 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
    if (scrollToBottomDetected) {
        if (self.itemsPerPage * self.page < self.totalItems) {
            self.page++;
            
            [MovieService
                getMovieListWithPage:self.page
                completionHandler:^(NSMutableDictionary * _Nonnull json) {
                    NSArray *movies = (NSArray *)[json valueForKey:@"items"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.movies = [NSMutableArray arrayWithArray:[self.movies arrayByAddingObjectsFromArray:movies]] ;
                        [self.tableView reloadData];
                    });
                }
                errorHandler:^(NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self displayFallback];
                    });
                }
            ];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *movie = self.movies[indexPath.row];
    
    [PlaybackService
        getPlaybackWithMovieID:[[movie valueForKey:@"id"] longValue]
        completionHandler:^(NSMutableDictionary * _Nonnull json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self
                    presentVideoPlayer:[movie valueForKey:@"uuid"]
                    movieID:[[movie valueForKey:@"id"] longValue]
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
