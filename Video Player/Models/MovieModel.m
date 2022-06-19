//
//  MovieModel.m
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"

@implementation MovieModel

- (id)initWithMovieId:(NSInteger)movieId title:(NSString *)title description:(NSString *)description uuid:(NSString *)uuid releaseYear:(NSInteger)releaseYear isMovieSeries:(BOOL)isMovieSeries {
    self.movieId = movieId;
    self.movieTitle = title;
    self.movieDescription = description;
    self.movieUUID = uuid;
    self.movieReleaseYear = releaseYear;
    self.isMovieSeries = isMovieSeries;
    return self;
}

@end
