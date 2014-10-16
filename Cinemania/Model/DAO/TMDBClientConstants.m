//
//  TMDBClientConstants.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 10/1/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "TMDBClientConstants.h"


#pragma mark - API_KEY

NSString* const TMDBApiKey=@"ed2f89aa774281fcada8f17b73c8fa05";

#pragma mark - API URLs

NSString * const TMDBBaseURL = @"http://api.themoviedb.org/3/";
NSString * const TMDBBaseURLSSL = @"https://api.themoviedb.org/3/";

#pragma mark - Configuration

NSString * const TMDBConfiguration = @"configuration";

#pragma mark - Movies

NSString * const TMDBMovie = @"movie/:id";
NSString * const TMDBMovieAlternativeTitles = @"movie/:id/alternative_titles";
NSString * const TMDBMovieCredits = @"movie/:id/credits";
NSString * const TMDBMovieImages = @"movie/:id/images";
NSString * const TMDBMovieKeywords = @"movie/:id/keywords";
NSString * const TMDBMovieReleases = @"movie/:id/releases";
NSString * const TMDBMovieTrailers = @"movie/:id/trailers";
NSString * const TMDBMovieTranslations = @"movie/:id/translations";
NSString * const TMDBMovieSimilarMovies = @"movie/:id/similar_movies";
NSString * const TMDBMovieReviews = @"movie/:id/reviews";
NSString * const TMDBMovieLists = @"movie/:id/lists";
NSString * const TMDBMovieChanges = @"movie/:id/changes";

NSString * const TMDBMovieLatest = @"movie/latest";
NSString * const TMDBMovieUpcoming = @"movie/upcoming";
NSString * const TMDBMovieTheatres = @"movie/now_playing";
NSString * const TMDBMoviePopular = @"movie/popular";
NSString * const TMDBMovieTopRated = @"movie/top_rated";

#pragma mark - Genres

NSString * const TMDBGenreList = @"genre/list";
NSString * const TMDBGenreMovies = @"genre/:id/movies";

#pragma mark - Collections

NSString * const TMDBCollection = @"collection/:id";
NSString * const TMDBCollectionImages = @"collection/:id/images";

#pragma mark - Search

NSString * const TMDBSearchMovie = @"search/movie";
NSString * const TMDBSearchPerson = @"search/person";
NSString * const TMDBSearchCollection = @"search/collection";
NSString * const TMDBSearchList = @"search/list";
NSString * const TMDBSearchCompany = @"search/company";
NSString * const TMDBSearchKeyword = @"search/keyword";

#pragma mark - People

NSString * const TMDBPeople = @"person/:id";
NSString * const TMDBPeopleMovieCredits = @"person/:id/movie_credits";
NSString * const TMDBPeopleImages = @"person/:id/images";
NSString * const TMDBPeopleChanges = @"person/:id/changes";
NSString * const TMDBPeoplePopular = @"person/popular";
NSString * const TMDBPeopleLatest = @"person/latest";

#pragma mark - Lists

NSString * const TMDBList = @"list/:id";
NSString * const TMDBListItemStatus = @"list/:id/item_status";

#pragma mark - Companies

NSString * const TMDBCompany = @"company/:id";
NSString * const TMDBCompanyMovies = @"company/:id/movies";

#pragma mark - Keywords

NSString * const TMDBKeyword = @"keyword/:id";
NSString * const TMDBKeywordMovies = @"keyword/:id/movies";

#pragma mark - Discover

NSString * const TMDBDiscover = @"discover/movie";

#pragma mark - Reviews

NSString * const TMDBReview = @"review/:id";

#pragma mark - Changes

NSString * const TMDBChangesMovie = @"movie/changes";
NSString * const TMDBChangesPerson = @"person/changes";

#pragma mark - Jobs

NSString * const TMDBJobList = @"job/list";

#pragma mark - Posters

NSString * const TMDBPosters= @"http://image.tmdb.org/t/p/w185";