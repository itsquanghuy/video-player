//
//  Http.m
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#import <Foundation/Foundation.h>
#import "Http.h"

@implementation Http

+ (void)request:(NSString *)urlWithString method:(NSString * _Nonnull)method headers:(NSMutableDictionary * _Nullable)headers body:(NSMutableDictionary * _Nullable)body completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:urlWithString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (headers != nil) {
        for (NSString *key in headers.allKeys) {
            [request addValue:[headers valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    [request setHTTPMethod:method];
    
    if ([method isEqual:@"POST"] || [method isEqual:@"PUT"]) {
        if (body == nil) {
            body = [[NSMutableDictionary alloc] init];
        }
        
        NSDictionary *mapData = body;
        NSData *data = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:nil];
        [request setHTTPBody:data];
    }
    
    NSURLSessionDataTask *task;
    if (completionHandler == nil) {
        task = [urlSession dataTaskWithRequest:request];
    }
    task = [urlSession dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

@end
