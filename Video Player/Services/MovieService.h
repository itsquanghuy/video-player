//
//  MovieService.h
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#ifndef MovieService_h
#define MovieService_h

#import "Http.h"
#import "Config.h"

@interface MovieService : NSObject

+ (void)getMovieListWithPage:(NSInteger)page completionHandler:(void (^ _Nullable)(NSMutableDictionary * _Nonnull))completionHandler errorHandler:(void (^_Nullable)(NSError * _Nullable))errorHandler;

@end

#endif /* MovieService_h */
