//
//  ViewController.h
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerViewController.h"
#import "Http.h"
#import "Config.h"
#import "JSON.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong) NSArray *movies;

@end

NS_ASSUME_NONNULL_END
