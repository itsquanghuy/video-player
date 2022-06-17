//
//  Http.h
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#ifndef Http_h
#define Http_h

@interface Http : NSObject

+ (void)request:(NSString * _Nonnull)urlWithString method:(NSString * _Nonnull)method headers:(NSMutableDictionary * _Nullable)headers body:(NSMutableDictionary * _Nullable)body completionHandler:(void (^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end

#endif /* Http_h */
