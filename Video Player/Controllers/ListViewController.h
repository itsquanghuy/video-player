//
//  ListViewController.h
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerViewController.h"
#import "SeriesViewController.h"
#import "Config.h"
#import "JSON.h"
#import "AuthService.h"
#import "MovieService.h"
#import "PlaybackService.h"
#import "MovieModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) UIAlertController *alert;
@property (nonatomic, assign) BOOL loaded;
@property (strong) NSMutableArray *movies;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger itemsPerPage;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, strong) NSCache<NSNumber *, UIImage *> *posterCache;

@end

NS_ASSUME_NONNULL_END
