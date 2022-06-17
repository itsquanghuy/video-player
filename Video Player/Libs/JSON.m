//
//  JSON.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@implementation JSON

+ (NSMutableDictionary *)decode:(NSData *)data {
    return [NSJSONSerialization
        JSONObjectWithData:data
        options:NSJSONReadingMutableLeaves
        error:nil
    ];
}

@end
