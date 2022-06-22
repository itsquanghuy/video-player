//
//  AuthService.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "AuthService.h"

@implementation AuthService

+ (void)authenticate:(NSString *)deviceUUID completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^_Nullable)(NSError * _Nullable))errorHandler {
    Config *config = [Config getInstance];
    [Http
        request:[NSString stringWithFormat:@"%@/auth", config.baseURL]
        method:@"POST"
        headers:nil
        body:[[NSMutableDictionary alloc] initWithDictionary:@{@"uuid": deviceUUID}]
        completionHandler:^(NSMutableDictionary * _Nonnull authJSON) {
            completionHandler(authJSON);
        }
        errorHandler:^(NSError * _Nullable error) {
            errorHandler(error);
        }
    ];
}

@end
