//
//  MovieModel.h
//  Video Player
//
//  Created by Vu Huy on 19/06/2022.
//

#ifndef MovieModel_h
#define MovieModel_h

@interface MovieModel : NSObject

@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, assign) NSString *movieTitle;
@property (nonatomic, assign) NSString *movieDescription;
@property (nonatomic, assign) NSString *movieUUID;
@property (nonatomic, assign) NSInteger movieReleaseYear;
@property (nonatomic, assign) BOOL isMovieSeries;

- (id)initWithMovieId:(NSInteger)movieId title:(NSString *)title description:(NSString *)description uuid:(NSString *)uuid releaseYear:(NSInteger)releaseYear isMovieSeries:(BOOL)isMovieSeries;

@end

#endif /* MovieModel_h */
