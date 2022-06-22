//
//  Config.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation Config

static Config *instance;

+ (id)getInstance {
    if (!instance) {
        instance = [[Config alloc] init];
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
