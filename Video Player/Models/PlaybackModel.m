//
//  PlaybackModel.m
//  Video Player
//
//  Created by Vu Huy on 23/06/2022.
//

#import <Foundation/Foundation.h>
#import "PlaybackModel.h"

@implementation PlaybackModel

static PlaybackModel *instance;

+ (id)getInstance {
    if (!instance) {
        instance = [[PlaybackModel alloc] init];
    }
    return instance;
}

- (id)init {
    if (!instance) {
        instance = [super init];
    }
    return instance;
}

@end
