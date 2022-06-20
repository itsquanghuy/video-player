//
//  SeriesViewController.h
//  Video Player
//
//  Created by Vu Huy on 20/06/2022.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerViewController.h"
#import "MovieService.h"
#import "PlaybackService.h"
#import "MovieModel.h"
#import "MovieSeriesMetadataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeriesViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) MovieModel *movieModel;
@property (strong, nonatomic) NSArray *metadataModel;
@property (strong, nonatomic) NSArray *movieSeries;

@end

NS_ASSUME_NONNULL_END
