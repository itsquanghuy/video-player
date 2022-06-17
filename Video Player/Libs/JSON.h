//
//  JSON.h
//  Video Player
//
//  Created by Vu Huy on 17/06/2022.
//

#ifndef JSON_h
#define JSON_h

@interface JSON : NSObject

+ (NSMutableDictionary *)decode:(NSData *)data;

@end

#endif /* JSON_h */
