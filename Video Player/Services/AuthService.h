//
//  AuthService.h
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#ifndef AuthService_h
#define AuthService_h

#import "Http.h"
#import "Config.h"

@interface AuthService : NSObject

+ (void)authenticate:(NSString * _Nonnull)deviceUUID completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^_Nullable)(NSError * _Nullable))errorHandler;

@end


#endif /* AuthService_h */
